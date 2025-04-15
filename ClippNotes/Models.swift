//
//  Models.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/10/25.
//

import Foundation


struct HairView: Codable {
    var front: String
    var back: String
    var left: String
    var right: String
    var all: String?
}

class HaircutReferences: Identifiable {
    var notesByView: HairView
    var photosByView: HairView
    
    init(notesByView: HairView, photosByView: HairView) {
        self.notesByView = notesByView
        self.photosByView = photosByView
    }
    
    func getNotesJson() -> String {
        var encodedString: String = ""
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let encodeNotes = try jsonEncoder.encode(self.notesByView)
            
            encodedString = String(data: encodeNotes, encoding: .utf8)!

        } catch {
            print(error.localizedDescription)
        }
        
        return encodedString
    }
    
    func getPhotosJson() -> String {
        var encodedString: String = ""
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let encodeNotes = try jsonEncoder.encode(self.photosByView)
            
            encodedString = String(data: encodeNotes, encoding: .utf8)!

        } catch {
            print(error.localizedDescription)
        }
        
        return encodedString
    }
}
