import Foundation
import Amplify
import AWSPluginsCore
import AWSAPIPlugin
import AWSS3StoragePlugin
import AWSCognitoAuthPlugin
import SwiftUI


struct HaircutImage {
    var front: URL?
    var back: URL?
    var left: URL?
    var right: URL?
}

@MainActor
class ViewModel: ObservableObject {
    
    @Published var stylist: String = "Stacy Longstromb"
    @Published var customers: [Client] = []
    @Published var selectedCustomer: Client = Client(name: "")
    @Published var selectedCustomerHaircuts: [Haircut] = []
    @Published var selectedHaircut: Haircut = Haircut(
        date: Temporal.DateTime.now(),
        stylist: "",
        photosByView: "",
        notes: "",
        customerID: ""
    )
    @Published var imageDataTest: HaircutImage? = nil

    init() {}

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
    
    private func resizeImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size

        let aspectRatio = size.width / size.height

        var newSize: CGSize
        if aspectRatio > 1 {
            // Landscape
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            // Portrait or square
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    
    func uploadImage(haircutID: String, hairImages: [HairSection:UIImage]) {

        for section in HairSection.allCases {
            if let image = hairImages[section] {
                let compressed = resizeImage(image: image, maxDimension: 1024)
                if let imageData = compressed.jpegData(compressionQuality: 0.6) {
                    let key = "public/\(selectedCustomer.id)\(haircutID)\(section.label)Image.jpg"
                    Amplify.Storage.uploadData(path: .fromString(key), data: imageData)
                }
            }
        }
        
    }
    
    
    func fetchImageURLs() async throws {
        imageDataTest = nil
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
        
        let sH = urls.filter {$0.absoluteString.contains(selectedHaircut.id)}
        imageDataTest = HaircutImage(front: sH.first(where: {$0.relativePath.contains("FRONT")}),
                                     back: sH.first(where: {$0.relativePath.contains("BACK")}),
                                     left: sH.first(where: {$0.relativePath.contains("LEFT")}),
                                     right: sH.first(where: {$0.relativePath.contains("RIGHT")}))
    }

    func getCustomers() async {
        let request = GraphQLRequest<Client>.list(Client.self)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let customers):
                print("Retrieved \(customers.count) customers")
                if let firstCustomer = customers.first {
                    self.customers = Array(customers)
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


    func getCustomerHaircuts() async {
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
                }
                print("Retrieved \(haircuts.count) haircuts")
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
        
        let imageData = HairViewKeys(frontKey: "public/\(selectedCustomer.id)\(haircutID)FRONTImage.jpg", backKey: "public/\(selectedCustomer.id)\(haircutID)BACKImage.jpg", leftKey: "public/\(selectedCustomer.id)\(haircutID)LEFTImage.jpg", rightKey: "public/\(selectedCustomer.id)\(haircutID)RIGHTImage.jpg")
        
        let model = Haircut(
            id: haircutID,
            date: Temporal.DateTime.now(),
            stylist: stylist,
            photosByView: imageData.getJson(),
            notes: notes,
            customerID: selectedCustomer.id
        )

        do {
            let result = try await Amplify.API.mutate(request: .create(model))
            switch result {
            case .success(let model):
                print("Haircut created: \(model.id)")
                uploadImage(haircutID: haircutID, hairImages: hairImages)
            case .failure(let error):
                print("GraphQL mutation failed: \(error)")
            }
        } catch let error as APIError {
            print("APIError during haircut creation: \(error)")
        } catch {
            print("Unexpected error during haircut creation: \(error)")
        }
    }
    
}
