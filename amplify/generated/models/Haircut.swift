// swiftlint:disable all
import Amplify
import Foundation

public struct Haircut: Model, Equatable {
  public let id: String
  public var date: Temporal.DateTime?
  public var stylist: String?
  public var photosByView: String?
  public var notesByView: String?
  public var customerID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      date: Temporal.DateTime? = nil,
      stylist: String? = nil,
      photosByView: String? = nil,
      notesByView: String? = nil,
      customerID: String) {
    self.init(id: id,
      date: date,
      stylist: stylist,
      photosByView: photosByView,
      notesByView: notesByView,
      customerID: customerID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      date: Temporal.DateTime? = nil,
      stylist: String? = nil,
      photosByView: String? = nil,
      notesByView: String? = nil,
      customerID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.date = date
      self.stylist = stylist
      self.photosByView = photosByView
      self.notesByView = notesByView
      self.customerID = customerID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
    
    func decodeNotesJSON() -> HairView {
        var decodedNotes: HairView = HairView(front: "", back: "", left: "", right: "", all: "")
        let jsonDecoder = JSONDecoder()
        
        if notesByView != nil {
            do {
                decodedNotes = try jsonDecoder.decode(HairView.self, from: Data(self.notesByView?.utf8 ?? "".utf8))
                print(decodedNotes)
            } catch {
                print(error.localizedDescription)

            }
            return decodedNotes
        } else {
            return decodedNotes
        }
    }
}
