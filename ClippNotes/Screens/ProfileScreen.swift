//
//  ContentView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/8/25.
//

import SwiftUI
import Amplify



struct ProfileScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var selectedHairSection: HairSection = .all
    @State private var isDragging: Bool = false
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var newHairCutSheetIsPresenting: Bool = false
    
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                BackgroundView()
                VStack (spacing: 15) {
                    Text("ClippNotes")
                        .font(Font.custom("anta-regular", size: 16))
                        .foregroundStyle(Color.clippnotesYellow)
                    ScrollView {
                        VStack (spacing: 20) {
                            ZStack (alignment: .top) {
                                
                                ImageFrameBackgroundView(height: geometryReader.size.height)
                                
                                VStack {
                                    
                                    CustomerHeaderView(customerName: viewModel.selectedCustomer.name, days: viewModel.daysSinceLastHaircut)
                                    
                                    TabView(selection: $selectedHairSection) {
                                        
                                        LargeImageTabView(downloadedImage: viewModel.haircutUIImages?.front, height: geometryReader.size.height, hairSection: HairSection.front)
                                        
                                        LargeImageTabView(downloadedImage: viewModel.haircutUIImages?.back, height: geometryReader.size.height, hairSection: HairSection.back)
                                        
                                        GridImageTabView(selectedHairSection: $selectedHairSection, haircutImages: viewModel.haircutUIImages, height: geometryReader.size.height)
                                        
                                        LargeImageTabView(downloadedImage: viewModel.haircutUIImages?.left, height: geometryReader.size.height, hairSection: HairSection.left)
                                        
                                        LargeImageTabView(downloadedImage: viewModel.haircutUIImages?.right, height: geometryReader.size.height, hairSection: HairSection.right)
                                    }
                                    .id(viewModel.selectedHaircut.id)
                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    .animation(.easeInOut(duration: 0.3), value: selectedHairSection)
                                    
                                    HairSectionSelectorView(selectedHairSection: $selectedHairSection)
                                    
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            StyleNotesSectionView(selectedHaircutNotes: viewModel.selectedHaircut.notes ?? "", height: geometryReader.size.height, width: geometryReader.size.width)
                            
                            HaircutHistorySectionView(selectedHairSection: $selectedHairSection, newHairCutSheetIsPresenting: $newHairCutSheetIsPresenting, height: geometryReader.size.height)
                            
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $newHairCutSheetIsPresenting) {
            LogNewHaircutScreen()
        }
    }
    
    private func nextHairSection(from current: HairSection) -> HairSection {
        let all = HairSection.allCases
        guard let index = all.firstIndex(of: current) else { return .all }
        return all[(index + 1) % all.count]
    }

    private func previousHairSection(from current: HairSection) -> HairSection {
        let all = HairSection.allCases
        guard let index = all.firstIndex(of: current) else { return .all }
        return all[(index - 1 + all.count) % all.count]
    }

}

#Preview {
    var viewModel = ViewModel()
    
    ProfileScreen()
        .environmentObject(viewModel)
}
