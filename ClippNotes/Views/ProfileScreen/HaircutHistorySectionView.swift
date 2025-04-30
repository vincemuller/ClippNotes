//
//  HaircutHistorySectionView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/29/25.
//

import SwiftUI

struct HaircutHistorySectionView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Binding var selectedHairSection: HairSection
    @Binding var newHairCutSheetIsPresenting: Bool
    
    let height: CGFloat
    
    var body: some View {
        HStack {
            SectionTextView(text: "Haircuts")
            Spacer()
            Button {
                newHairCutSheetIsPresenting = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.green)
            }
            .padding(.trailing, 25)
            .offset(y: 3)
        }
        .padding(.top, 10)
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(colors: [Color.clippnotesLightBlue, Color.clippnotesVeryLightBlue, Color.clippnotesLightBlue], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5))
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
            
            ScrollView {
                VStack (spacing: 0) {
                    ForEach(viewModel.selectedCustomerHaircuts, id: \.id) { haircut in
                        ZStack {
                            haircut.id == viewModel.selectedHaircut.id ?
                            Color.clippnotesVeryLightBlue : Color.clear
                            VStack {
                                HistoryCellView(haircut: haircut, imageURL: viewModel.haircutThumbnails[haircut.id])
                                    .onTapGesture {
                                        viewModel.selectedHaircut = haircut
                                        selectedHairSection = .all
                                        Task {
                                            try await viewModel.fetchHaircutImagesForSelectedHaircut()
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .frame(height: height * 0.327)
            .mask {
                RoundedRectangle(cornerRadius: 12)
                    .padding(0.5)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    var viewModel = ViewModel()
    
    HaircutHistorySectionView(selectedHairSection: .constant(.all), newHairCutSheetIsPresenting: .constant(false), height: 763.0)
        .environmentObject(viewModel)
}
