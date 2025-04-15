// swiftlint:disable all
import Amplify
import Foundation

extension Haircut {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case date
    case stylist
    case photosByView
    case notesByView
    case customerID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let haircut = Haircut.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Haircuts"
    model.syncPluralName = "Haircuts"
    
    model.attributes(
      .index(fields: ["customerID"], name: "byClient"),
      .primaryKey(fields: [haircut.id])
    )
    
    model.fields(
      .field(haircut.id, is: .required, ofType: .string),
      .field(haircut.date, is: .optional, ofType: .dateTime),
      .field(haircut.stylist, is: .optional, ofType: .string),
      .field(haircut.photosByView, is: .optional, ofType: .string),
      .field(haircut.notesByView, is: .optional, ofType: .string),
      .field(haircut.customerID, is: .required, ofType: .string),
      .field(haircut.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(haircut.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Haircut: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}