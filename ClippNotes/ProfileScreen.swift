//
//  ContentView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/8/25.
//

import SwiftUI
import Amplify


let columns: [GridItem] = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())
                            ]



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
                                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20))
                                    .fill(LinearGradient(colors: [Color.clippnotesLightBlue,Color.clippnotesDarkBlue], startPoint: .bottom, endPoint: .top))
                                    .frame(height: 420)
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
                                                        .fill(                                            (selectedHairSection != section) ? Color.clear : Color.white)
                                                        .frame(height: 1)
                                                        .padding(.horizontal, 5)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            HStack {
                                Text("Style Notes")
                                    .font(Font.custom("anta-regular", size: 20))
                                    .foregroundStyle(Color.clippnotesYellow)
                                    .padding(.leading, 20)
                                Spacer()
                                Button {
                                    print("edit notes function")
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
                                
                                Text(viewModel.selectedHaircut.notes ?? "")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                    .frame(width: 320, height: geometryReader.size.height * 0.20, alignment: .topLeading)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    .transition(.opacity)
                            }
                            .frame(height: geometryReader.size.height * 0.25)
                            HStack {
                                Text("Haircuts")
                                    .font(Font.custom("anta-regular", size: 20))
                                    .foregroundStyle(Color.clippnotesYellow)
                                    .padding(.leading, 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
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
                                .frame(height: 250)
                                .mask {
                                    RoundedRectangle(cornerRadius: 12)
                                        .padding(0.5)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                print("Width: \(geometryReader.size.width.description)")
                print("Height: \(geometryReader.size.height.description)")
            }
        }
        .sheet(isPresented: $newHairCutSheetIsPresenting) {
            LogNewHaircutSheet()
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
