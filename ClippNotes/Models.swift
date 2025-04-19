//
//  Models.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/10/25.
//

import Foundation
import SwiftUI


struct HairViewKeys: Codable {
    var frontKey: String
    var backKey: String
    var leftKey: String
    var rightKey: String
}

extension HairViewKeys {
    func getJson() -> String {
        var encodedString: String = ""
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let encodePhotos = try jsonEncoder.encode(self)
            
            encodedString = String(data: encodePhotos, encoding: .utf8)!

        } catch {
            print(error.localizedDescription)
        }
        
        return encodedString
    }

}
