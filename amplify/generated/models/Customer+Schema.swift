// swiftlint:disable all
import Amplify
import Foundation

extension Customer {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case Haircuts
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let customer = Customer.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Customers"
    model.syncPluralName = "Customers"
    
    model.attributes(
      .primaryKey(fields: [customer.id])
    )
    
    model.fields(
      .field(customer.id, is: .required, ofType: .string),
      .field(customer.name, is: .required, ofType: .string),
      .hasMany(customer.Haircuts, is: .optional, ofType: Haircut.self, associatedWith: Haircut.keys.customerID),
      .field(customer.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(customer.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Customer: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}