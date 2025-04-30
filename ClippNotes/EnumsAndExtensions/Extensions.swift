//
//  Extensions.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/29/25.
//

import Foundation
import SwiftUI


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
