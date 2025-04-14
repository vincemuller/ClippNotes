// swiftlint:disable all
import Amplify
import Foundation

public struct Customer: Model {
  public let id: String
  public var name: String
  public var Haircuts: List<Haircut>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      Haircuts: List<Haircut>? = []) {
    self.init(id: id,
      name: name,
      Haircuts: Haircuts,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      Haircuts: List<Haircut>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.Haircuts = Haircuts
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}