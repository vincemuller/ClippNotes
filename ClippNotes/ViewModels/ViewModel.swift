import SwiftUI
import Foundation

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import AWSPluginsCore



@MainActor
class ViewModel: ObservableObject {
    
    // MARK: - Published Properties

    @Published var stylist: String = "Stacy Longstromb"
    @Published var customers: [Client] = []
    @Published var selectedCustomer: Client = Client(name: "")
    @Published var selectedCustomerHaircuts: [Haircut] = []
    @Published var selectedHaircut: Haircut = Haircut(
        date: Temporal.DateTime.now(),
        stylist: "",
        notes: "",
        customerID: ""
    )
    @Published var haircutThumbnails: [String: URL] = [:]
    @Published var haircutUIImages: HaircutUIImages? = nil
    @Published var daysSinceLastHaircut: Int = 0

    // MARK: - Init

    init() {}

    // MARK: - Amplify Setup

    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured!")
        } catch {
            print("Error configuring Amplify: \(error)")
        }
    }
    
    // MARK: Customers & Haircuts
    
    func fetchCustomer() async {
        let predicate = Client.keys.name == "Sara Muller"
        let request = GraphQLRequest<Client>.list(Client.self, where: predicate)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let customers):
                if let firstCustomer = customers.first {
                    self.selectedCustomer = firstCustomer
                }
            case .failure(let error):
                print("Query failed: \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("APIError during customer query: \(error)")
        } catch {
            print("Unexpected error during customer query: \(error)")
        }
    }
    
    func calculateDaysSinceLastHaircut() {
        guard let haircutDate = selectedHaircut.date?.foundationDate, haircutDate <= Date() else {
            return
        }

        let components = Calendar.current.dateComponents([.day], from: haircutDate, to: Date.now)
        daysSinceLastHaircut = components.day ?? 0
    }
    
    func fetchHaircutsForSelectedCustomer() async {
        let predicate = Haircut.keys.customerID == selectedCustomer.id
        let request = GraphQLRequest<Haircut>.list(Haircut.self, where: predicate)

        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let haircuts):
                self.selectedCustomerHaircuts = Array(haircuts).sorted {
                    $0.date?.iso8601String ?? "" > $1.date?.iso8601String ?? ""
                }
                if let firstHaircut = selectedCustomerHaircuts.first {
                    self.selectedHaircut = firstHaircut
                    self.calculateDaysSinceLastHaircut()
                }
                print("Retrieved \(haircuts.count) haircuts")
                Task {
                    try await fetchImageURLsForHaircutThumbnails()
                    try await fetchHaircutImagesForSelectedHaircut()
                }
            case .failure(let error):
                print("Query failed: \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("APIError during haircut query: \(error)")
        } catch {
            print("Unexpected error during haircut query: \(error)")
        }
    }
    
    func createHaircut(notes: String, hairImages: [HairSection:UIImage]) async {
        let haircutID = UUID().uuidString
        
        let model = Haircut(
            id: haircutID,
            date: Temporal.DateTime.now(),
            stylist: stylist,
            notes: notes,
            customerID: selectedCustomer.id
        )

        do {
            let result = try await Amplify.API.mutate(request: .create(model))
            switch result {
            case .success(let model):
                print("Haircut created: \(model.id)")
                Task {
                   await uploadHaircutImages(haircutID: haircutID, hairImages: hairImages)
                }
            case .failure(let error):
                print("GraphQL mutation failed: \(error)")
            }
        } catch let error as APIError {
            print("APIError during haircut creation: \(error)")
        } catch {
            print("Unexpected error during haircut creation: \(error)")
        }
    }
    
    // MARK: Image Upload & Download
    
    func uploadHaircutImages(haircutID: String, hairImages: [HairSection: UIImage]) async {
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for section in HairSection.allCases {
                    if let image = hairImages[section] {
                        let compressed = resizeImage(image: image, maxDimension: 1024)
                        if let imageData = compressed.jpegData(compressionQuality: 0.6) {
                            let key = "public/\(selectedCustomer.id)\(haircutID)\(section.label)Image.jpg"

                            group.addTask {
                                let uploadTask = Amplify.Storage.uploadData(
                                    path: .fromString(key),
                                    data: imageData
                                )

                                for try await progress in await uploadTask.progress {
                                    print("Upload progress for \(section.label): \(progress)")
                                }
                            }
                        }
                    }
                }

                try await group.waitForAll()
            }
            
            await fetchHaircutsForSelectedCustomer()

        } catch {
            print("At least one upload failed: \(error)")
        }
    }

    
    func fetchImageURLsForHaircutThumbnails() async throws {
        let result = try await Amplify.Storage.list(path: .fromString("public/\(selectedCustomer.id)"))
        
        guard !result.items.isEmpty else { return }
        
        let urls: [URL] = try await withThrowingTaskGroup(of: URL.self) { group in
            for item in result.items {
                group.addTask {
                    try await Amplify.Storage.getURL(path: .fromString(item.path))
                }
            }
            
            var collected: [URL] = []
            for try await url in group {
                collected.append(url)
            }
            return collected
        }
        
        for i in selectedCustomerHaircuts {
            haircutThumbnails[i.id] = urls.first(where: {$0.relativePath.contains(i.id) && $0.relativePath.contains("FRONT")})
        }
        
    }
    
    func fetchHaircutImagesForSelectedHaircut() async throws {
        let result = try await Amplify.Storage.list(path: .fromString("public/\(selectedCustomer.id)"))
        
        guard !result.items.isEmpty else { return }
        
        let matchingItems = result.items.filter { $0.path.contains(selectedHaircut.id) }
        
        let images: [HairSection: UIImage] = try await withThrowingTaskGroup(of: (HairSection, UIImage).self) { group in
            for item in matchingItems {
                group.addTask {
                    let data = try await Amplify.Storage.downloadData(path: .fromString(item.path)).value
                    guard let image = UIImage(data: data) else {
                        throw URLError(.cannotDecodeContentData)
                    }
                    
                    // Figure out which section it belongs to
                    if item.path.contains("FRONT") {
                        return (.front, image)
                    } else if item.path.contains("BACK") {
                        return (.back, image)
                    } else if item.path.contains("LEFT") {
                        return (.left, image)
                    } else if item.path.contains("RIGHT") {
                        return (.right, image)
                    } else {
                        throw NSError(domain: "Unknown section", code: -1)
                    }
                }
            }
            
            var collected: [HairSection: UIImage] = [:]
            for try await (section, image) in group {
                collected[section] = image
            }
            return collected
        }
        
        haircutUIImages = HaircutUIImages(
            front: images[.front],
            back: images[.back],
            left: images[.left],
            right: images[.right]
        )
    }


    // MARK: Helpers
    
    private func storageKey(for customerID: String, haircutID: String, section: HairSection) -> String {
        return "public/\(customerID)\(haircutID)\(section.label)Image.jpg"
    }

    private func resizeImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size

        let aspectRatio = size.width / size.height

        var newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
}
