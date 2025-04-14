//
//  HistoryCellView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/13/25.
//

import SwiftUI

struct HistoryCellView: View {
    
    @State var haircut: Haircut
    @State var selected: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image("frontImage")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text("April 5, 2025")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                    Text("Stylist: Jamie Mcmain")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Text("“Tapered fade with hard part…”")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding(10)
            Rectangle()
                .fill(.white.opacity(0.3))
                .frame(height: 1)
        }
    }
}

#Preview {
    HistoryCellView(haircut: Haircut(date: Date(), customerID: UUID(), notesByView: [:], photosByView: [:]))
}
