//
//  ContentView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/8/25.
//

import SwiftUI
import Amplify


enum HairSection: Identifiable, CaseIterable {
    case front, back, all, left, right
    var id: Self { self }
    var label: String {
        switch self {
        case .front:
            return "FRONT"
        case .back:
            return "BACK"
        case .all:
            return "ALL"
        case .left:
            return "LEFT"
        case .right:
            return "RIGHT"
        }
    }
}

let columns: [GridItem] = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())
                            ]



struct ProfileScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var selectedCustomer: Client = Client(name: "")
    @State private var selectedHairSection: HairSection = .all
    @State private var isDragging: Bool = false
    
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    
    @State private var newHairCutSheetIsPresenting: Bool = true

    @State var hairImages: [HairSection:UIImage] = [:]
    @State var haircutNotes: String = ""
    @State var newHaircutSelectedHairSection: HairSection = .all
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Color.clippnotesDarkBlue
                    .ignoresSafeArea()
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
                                    HStack {
                                        VStack (alignment: .leading, spacing: 5) {
                                            Text(viewModel.selectedCustomer.name)
                                                .font(Font.custom("anta-regular", size: 25))
                                                .foregroundStyle(Color.white)
                                                .padding(.leading, 20)
                                            Text("Last haircut: 90 days ago")
                                                .font(.system(size: 14))
                                                .foregroundStyle(Color.clippnotesYellow.opacity(0.5))
                                                .padding(.leading, 20)
                                        }
                                        Spacer()
                                    }
                                    TabView(selection: $selectedHairSection) {
                                        
                                        ZStack {
                                            if let frontImage = viewModel.imageDataTest?.front {
                                                AsyncImage(url: frontImage) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                    case .failure:
                                                        Text("Failed to load image.")
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Color.gray
                                                    .overlay(Text("Loading..."))
                                            }
                                        }
                                        .frame(height: geometryReader.size.height * 0.42)
                                        .clipped()
                                        .mask(RoundedRectangle(cornerRadius: 20))
                                        .padding(.horizontal)
                                        .tag(HairSection.front)
                                        
                                        ZStack {
                                            if let backImage = viewModel.imageDataTest?.back {
                                                AsyncImage(url: backImage) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                    case .failure:
                                                        Text("Failed to load image.")
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Color.gray
                                                    .overlay(Text("Loading..."))
                                            }
                                        }
                                        .frame(height: geometryReader.size.height * 0.42)
                                        .clipped()
                                        .mask(RoundedRectangle(cornerRadius: 20))
                                        .padding(.horizontal)
                                        .tag(HairSection.back)
                                        
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                ZStack {
                                                    if let frontImage = viewModel.imageDataTest?.front {
                                                        AsyncImage(url: frontImage) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ProgressView()
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                            case .failure:
                                                                Text("Failed to load image.")
                                                            @unknown default:
                                                                EmptyView()
                                                            }
                                                        }
                                                    } else {
                                                        Color.gray
                                                            .overlay(Text("Loading..."))
                                                    }
                                                }
                                                .frame(height: geometryReader.size.height * 0.21)
                                                .clipped()
                                                .mask {
                                                    UnevenRoundedRectangle(topLeadingRadius: 20)
                                                }
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        selectedHairSection = .front
                                                    }
                                                }
                                                
                                                ZStack {
                                                    if let leftImage = viewModel.imageDataTest?.left {
                                                        AsyncImage(url: leftImage) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ProgressView()
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                            case .failure:
                                                                Text("Failed to load image.")
                                                            @unknown default:
                                                                EmptyView()
                                                            }
                                                        }
                                                    } else {
                                                        Color.gray
                                                            .overlay(Text("Loading..."))
                                                    }
                                                }
                                                .frame(height: geometryReader.size.height * 0.21)
                                                .clipped()
                                                .mask {
                                                    UnevenRoundedRectangle(topTrailingRadius: 20)
                                                }
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        selectedHairSection = .left
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing: 0) {
                                                ZStack {
                                                    if let backImage = viewModel.imageDataTest?.back {
                                                        AsyncImage(url: backImage) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ProgressView()
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                            case .failure:
                                                                Text("Failed to load image.")
                                                            @unknown default:
                                                                EmptyView()
                                                            }
                                                        }
                                                    } else {
                                                        Color.gray
                                                            .overlay(Text("Loading..."))
                                                    }
                                                }
                                                .frame(height: geometryReader.size.height * 0.21)
                                                .clipped()
                                                .mask {
                                                    UnevenRoundedRectangle(bottomLeadingRadius: 20)
                                                }
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        selectedHairSection = .back
                                                    }
                                                }
                                                
                                                ZStack {
                                                    if let rightImage = viewModel.imageDataTest?.right {
                                                        AsyncImage(url: rightImage) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ProgressView()
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                            case .failure:
                                                                Text("Failed to load image.")
                                                            @unknown default:
                                                                EmptyView()
                                                            }
                                                        }
                                                    } else {
                                                        Color.gray
                                                            .overlay(Text("Loading..."))
                                                    }
                                                }
                                                .frame(height: geometryReader.size.height * 0.21)
                                                .clipped()
                                                .mask {
                                                    UnevenRoundedRectangle(bottomTrailingRadius: 20)
                                                }
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        selectedHairSection = .right
                                                    }
                                                }
                                            }
                                        }
                                        .tag(HairSection.all)
                                        .padding(.horizontal)
                                        
                                        ZStack {
                                            if let leftImage = viewModel.imageDataTest?.left {
                                                AsyncImage(url: leftImage) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                    case .failure(let error):
                                                        Text("Failed to load image. \(error.localizedDescription)")
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Color.gray
                                                    .overlay(Text("Loading..."))
                                            }
                                        }
                                        .frame(height: geometryReader.size.height * 0.42)
                                        .clipped()
                                        .mask(RoundedRectangle(cornerRadius: 20))
                                        .padding(.horizontal)
                                        .tag(HairSection.left)
                                        
                                        ZStack {
                                            if let rightImage = viewModel.imageDataTest?.right {
                                                AsyncImage(url: rightImage) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                    case .failure:
                                                        Text("Failed to load image.")
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Color.gray
                                                    .overlay(Text("Loading..."))
                                            }
                                        }
                                        .frame(height: geometryReader.size.height * 0.42)
                                        .clipped()
                                        .mask(RoundedRectangle(cornerRadius: 20))
                                        .padding(.horizontal)
                                        .tag(HairSection.right)
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
                                                    HistoryCellView(haircut: haircut)
                                                        .onTapGesture {
                                                            viewModel.selectedHaircut = haircut
                                                            selectedHairSection = .all
                                                            viewModel.imageDataTest = nil
                                                            Task {
                                                                try await viewModel.fetchImageURLs()
                                                            }
                                                        }
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(height: 250)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $newHairCutSheetIsPresenting) {
            
            let height: CGFloat = 793
            
            ZStack {
                Color.clippnotesDarkBlue
            ScrollView {
                    VStack (spacing: 0) {
                        Text("Log New Haircut")
                            .font(Font.custom("anta-regular", size: 25))
                            .foregroundStyle(Color.clippnotesYellow)
                            .padding(.vertical)
                        HStack(spacing: 0) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.clippnotesLightBlue)
                                    .clipped()
                                    .mask {
                                        UnevenRoundedRectangle(topLeadingRadius: 20)
                                    }
                                Button {
                                    showCamera = true
                                    newHaircutSelectedHairSection = .front
                                } label: {
                                    if let frontImage = hairImages[HairSection.front] {
                                        Image(uiImage: frontImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: height * 0.21)
                                            .mask {
                                                UnevenRoundedRectangle(topLeadingRadius: 20)
                                            }
                                    } else {
                                        VStack {
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                            Text("Front")
                                                .font(Font.custom("anta-regular", size: 20))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                        }
                                    }
                                }
                            }
                            .frame(height: height * 0.21)
                            .padding(2)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.clippnotesLightBlue)
                                    .clipped()
                                    .mask {
                                        UnevenRoundedRectangle(topTrailingRadius: 20)
                                    }
                                Button {
                                    showCamera = true
                                    newHaircutSelectedHairSection = .left
                                } label: {
                                    if let leftImage = hairImages[HairSection.left] {
                                        Image(uiImage: leftImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: height * 0.21)
                                            .mask {
                                                UnevenRoundedRectangle(topTrailingRadius: 20)
                                            }
                                    } else {
                                        VStack {
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                            Text("Left")
                                                .font(Font.custom("anta-regular", size: 20))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                        }
                                    }
                                }
                            }
                            .frame(height: height * 0.21)
                            .padding(2)
                        }
                        HStack(spacing: 0) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.clippnotesLightBlue)
                                    .clipped()
                                    .mask {
                                        UnevenRoundedRectangle(bottomLeadingRadius: 20)
                                    }
                                Button {
                                    showCamera = true
                                    newHaircutSelectedHairSection = .back
                                } label: {
                                    if let backImage = hairImages[HairSection.back] {
                                        Image(uiImage: backImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: height * 0.21)
                                            .mask {
                                                UnevenRoundedRectangle(bottomLeadingRadius: 20)
                                            }
                                    } else {
                                        VStack {
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                            Text("Back")
                                                .font(Font.custom("anta-regular", size: 20))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                        }
                                    }
                                }
                            }
                            .frame(height: height * 0.21)
                            .padding(2)
                            
                            ZStack {
                                Rectangle()
                                    .fill(Color.clippnotesLightBlue)
                                    .clipped()
                                    .mask {
                                        UnevenRoundedRectangle(bottomTrailingRadius: 20)
                                    }
                                Button {
                                    showCamera = true
                                    newHaircutSelectedHairSection = .right
                                } label: {
                                    if let rightImage = hairImages[HairSection.right] {
                                        Image(uiImage: rightImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: height * 0.21)
                                            .mask {
                                                UnevenRoundedRectangle(bottomTrailingRadius: 20)
                                            }
                                    } else {
                                        VStack {
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                            Text("Right")
                                                .font(Font.custom("anta-regular", size: 20))
                                                .foregroundStyle(Color.white.opacity(0.3))
                                        }
                                    }
                                }
                            }
                            .frame(height: height * 0.21)
                            .padding(2)
                        }
                        HStack {
                            Text("Stylist Notes")
                                .font(Font.custom("anta-regular", size: 20))
                                .foregroundStyle(Color.clippnotesYellow)
                            Spacer()
                        }
                        .padding(.vertical)
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
                        .frame(height: 200)
                        Button {
                            Task {
                                await viewModel.createHaircut(notes: haircutNotes, hairImages: hairImages)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green)
                                    .frame(height: 50)
                                Text("Save Haircut")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding(.top, 30)
                        
                    }
                    .padding()
                }
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showCamera) {
                CameraView { image in
                    hairImages[newHaircutSelectedHairSection] = image
                }
                .ignoresSafeArea()
            }
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


//VStack {
//    if let image = capturedImage {
//        Image(uiImage: image)
//            .resizable()
//            .scaledToFit()
//            .onAppear {
//                print(image)
//            }
//    }
//    
//    Button("Take Photo") {
//        showCamera = true
//    }
//    .sheet(isPresented: $showCamera) {
//        CameraView { image in
//            self.capturedImage = image
//        }
//    }
//}
