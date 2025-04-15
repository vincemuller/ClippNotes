// swiftlint:disable all
import Amplify
import Foundation

extension Client {
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
    let client = Client.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Clients"
    model.syncPluralName = "Clients"
    
    model.attributes(
      .primaryKey(fields: [client.id])
    )
    
    model.fields(
      .field(client.id, is: .required, ofType: .string),
      .field(client.name, is: .required, ofType: .string),
      .hasMany(client.Haircuts, is: .optional, ofType: Haircut.self, associatedWith: Haircut.keys.customerID),
      .field(client.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(client.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Client: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}