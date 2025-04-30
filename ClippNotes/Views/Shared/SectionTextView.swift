//
//  SectionTextView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/29/25.
//

import SwiftUI

struct SectionTextView: View {
    
    let text: String
    var fontSize: CGFloat = 20
    var textColor: Color = Color.clippnotesYellow
    
    var body: some View {
        Text(text)
            .font(Font.custom("anta-regular", size: fontSize))
            .foregroundStyle(textColor)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionTextView(text: "Style Notes")
}
