import Foundation
import Amplify
import AWSPluginsCore
import AWSAPIPlugin

@MainActor
class ViewModel: ObservableObject {
    
    @Published var stylist: String = "Stacy Longstromb"
    @Published var customers: [Customer] = []
    @Published var selectedCustomer: Customer = Customer(name: "")
    @Published var selectedCustomerHaircuts: [Haircut] = []
    @Published var selectedHaircut: Haircut = Haircut(
        date: Temporal.DateTime.now(),
        stylist: "",
        photosByView: "",
        notesByView: "",
        customerID: ""
    )

    init() {}

    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured!")
        } catch {
            print("Error configuring Amplify: \(error)")
        }
    }

    func getCustomers() async {
        let request = GraphQLRequest<Customer>.list(Customer.self)
        
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
                self.selectedCustomerHaircuts = Array(haircuts)
                if let firstHaircut = haircuts.first {
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

    func createHaircut(customerID: String, haircut: HaircutReferences) async {
        let model = Haircut(
            date: Temporal.DateTime.now(),
            stylist: stylist,
            photosByView: haircut.getPhotosJson(),
            notesByView: haircut.getNotesJson(),
            customerID: customerID
        )

        do {
            let result = try await Amplify.API.mutate(request: .create(model))
            switch result {
            case .success(let model):
                print("Haircut created: \(model)")
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
