//
//  LogNewHaircutNotesView.swift
//  ClippNotes
//
//  Created by Vince Muller on 5/1/25.
//

import SwiftUI

struct LogNewHaircutNotesView: View {
    
    @Binding var haircutNotes: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(colors: [Color.clippnotesLightBlue,Color.clippnotesVeryLightBlue, Color.clippnotesLightBlue], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5))
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
            ZStack(alignment: .topLeading) {
                if haircutNotes.isEmpty {
                    Text("Enter notes here...")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.5))
                        .padding()
                }
                
                TextEditor(text: $haircutNotes)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .padding(10)
            }
            .frame(minHeight: 180, alignment: .topLeading)
        }
        .frame(height: 180)
    }
}

#Preview {
    LogNewHaircutNotesView(haircutNotes: .constant(""))
}
