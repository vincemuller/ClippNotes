//
//  HistoryCellView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/13/25.
//

import SwiftUI
import Amplify

struct HistoryCellView: View {
    
    @State var haircut: Haircut
    
    var body: some View {
        VStack {
            HStack {
                Image("frontImage")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text("\(haircut.date?.iso8601FormattedString(format: .short) ?? "")")
                        .font(.system(size: 10))
                        .foregroundStyle(.white)
                    Text("Stylist: \(haircut.stylist ?? "")")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                    Text(haircut.notes ?? "")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .frame(height: 30, alignment: .topLeading)
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
    HistoryCellView(haircut: Haircut(date: Temporal.DateTime.now(), stylist: "Stacy Brookes", photosByView: "", notes: "", customerID: ""))
}
