//
//  HairSectionSelectorView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/29/25.
//

import SwiftUI

struct HairSectionSelectorView: View {
    
    @Binding var selectedHairSection: HairSection
    
    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible()),
                                       GridItem(.flexible()),
                                       GridItem(.flexible()),
                                       GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(HairSection.allCases, id: \.self) {section in
                Button {
                    selectedHairSection = section
                } label: {
                    VStack {
                        Text(section.label)
                            .font(Font.custom("anta-regular", size: 14))
                            .foregroundStyle(Color.white.opacity(section == selectedHairSection ? 1 : 0.3))
                        Rectangle()
                            .fill((selectedHairSection != section) ? Color.clear : Color.white)
                            .frame(height: 1)
                            .padding(.horizontal, 5)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    HairSectionSelectorView(selectedHairSection: .constant(.all))
}
