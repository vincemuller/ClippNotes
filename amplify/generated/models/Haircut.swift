// swiftlint:disable all
import Amplify
import Foundation

public struct Haircut: Model, Equatable {
  public let id: String
  public var date: Temporal.DateTime?
  public var stylist: String?
  public var notes: String?
  public var customerID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      date: Temporal.DateTime? = nil,
      stylist: String? = nil,
      notes: String? = nil,
      customerID: String) {
    self.init(id: id,
      date: date,
      stylist: stylist,
      notes: notes,
      customerID: customerID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      date: Temporal.DateTime? = nil,
      stylist: String? = nil,
      notes: String? = nil,
      customerID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.date = date
      self.stylist = stylist
      self.notes = notes
      self.customerID = customerID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
