//
//  Models.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/10/25.
//

import Foundation


class Customer {
    var id = UUID()
    var name: String
    var haircuts: [Haircut]
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.haircuts = [Haircut(date: Date.now, customerID: id, notesByView: ["FRONT": "FRONT TEXT HERE", "BACK": "BACK TEXT HERE", "ALL": "ALL TEXT HERE", "LEFT": "LEFT TEXT HERE", "RIGHT": "RIGHT TEXT HERE"], photosByView: [:])]
    }
}

class Haircut: Identifiable {
    var id = UUID()
    var date: Date
    var customerID: UUID
    var notesByView: [String: String]
    var photosByView: [String: URL]
    
    init(id: UUID = UUID(), date: Date, customerID: UUID, notesByView: [String : String], photosByView: [String : URL]) {
        self.id = id
        self.date = date
        self.customerID = customerID
        self.notesByView = notesByView
        self.photosByView = photosByView
    }
}
