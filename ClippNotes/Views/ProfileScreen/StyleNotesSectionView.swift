//
//  StyleNotesSectionView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/29/25.
//

import SwiftUI

struct StyleNotesSectionView: View {
    
    var selectedHaircutNotes: String
    
    let height: CGFloat
    let width: CGFloat
    
    var body: some View {
        HStack {
            SectionTextView(text: "Style Notes")
            Spacer()
            Button {
                print("Edit Notes Function Goes Here")
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.white.opacity(0.5))
            }
            .padding(.trailing, 25)
            .offset(y: 3)
        }
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(colors: [Color.clippnotesLightBlue,Color.clippnotesVeryLightBlue, Color.clippnotesLightBlue], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5))
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                .padding(.horizontal)
            
            Text(selectedHaircutNotes)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: width * 0.82, height: height * 0.20, alignment: .topLeading)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .transition(.opacity)
        }
        .frame(height: height * 0.25)
    }
}

#Preview {
    StyleNotesSectionView(selectedHaircutNotes: "Short trim on top and 2.5 clippers on the side", height: 763, width: 390)
}
