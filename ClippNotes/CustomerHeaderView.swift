//
//  CustomerHeaderView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/28/25.
//

import SwiftUI

struct CustomerHeaderView: View {
    let customerName: String
    let days: Int
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 5) {
                Text(customerName)
                    .font(Font.custom("anta-regular", size: 25))
                    .foregroundStyle(Color.white)
                    .padding(.leading, 20)
                Text("Last haircut: \(days.description) days ago")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.clippnotesYellow.opacity(0.5))
                    .padding(.leading, 20)
            }
            Spacer()
        }
    }
}

#Preview {
    CustomerHeaderView(customerName: "Sara Muller", days: 50)
}
