//
//  ContentView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/8/25.
//

import SwiftUI

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
    
    @State private var customer = Customer(name: "Sara Muller")
    @State private var selectedHairSection: HairSection = .all
    @State private var isDragging: Bool = false

    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Color.clippnotesDarkBlue
                    .ignoresSafeArea()
                VStack (spacing: 20) {
                    Text("ClippNotes")
                        .font(Font.custom("anta-regular", size: 16))
                        .foregroundStyle(Color.clippnotesYellow)
                    ScrollView {
                        VStack (spacing: 20) {
                            ZStack (alignment: .top) {
                                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20))
                                    .fill(LinearGradient(colors: [Color.clippnotesLightBlue,Color.clippnotesDarkBlue], startPoint: .bottom, endPoint: .top))
                                    .frame(height: 445)
                                VStack (spacing: 15) {
                                    HStack {
                                        VStack (alignment: .leading, spacing: 5) {
                                            Text(customer.name)
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
                                    switch selectedHairSection {
                                    case .front:
                                        Image("frontImage")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: geometryReader.size.height * 0.42)
                                            .scaleEffect(isDragging ? 0.95 : 1.0)
                                            .clipped()
                                            .mask {
                                                RoundedRectangle(cornerRadius: 20)
                                            }
                                            .padding(.horizontal)
                                            .gesture(
                                                DragGesture(minimumDistance: 20)
                                                    .onChanged { _ in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = true
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = false
                                                        }
                                                        if value.translation.width < -50 {
                                                            withAnimation {
                                                                selectedHairSection = nextHairSection(from: selectedHairSection)
                                                            }
                                                        } else if value.translation.width > 50 {
                                                            withAnimation {
                                                                selectedHairSection = previousHairSection(from: selectedHairSection)
                                                            }
                                                        }
                                                    }
                                            )
                                        
                                    case .back:
                                        Image("backImage")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: geometryReader.size.height * 0.42)
                                            .scaleEffect(isDragging ? 0.95 : 1.0)
                                            .clipped()
                                            .mask {
                                                RoundedRectangle(cornerRadius: 20)
                                            }
                                            .padding(.horizontal)
                                            .gesture(
                                                DragGesture(minimumDistance: 20)
                                                    .onChanged { _ in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = true
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = false
                                                        }
                                                        if value.translation.width < -50 {
                                                            withAnimation {
                                                                selectedHairSection = nextHairSection(from: selectedHairSection)
                                                            }
                                                        } else if value.translation.width > 50 {
                                                            withAnimation {
                                                                selectedHairSection = previousHairSection(from: selectedHairSection)
                                                            }
                                                        }
                                                    }
                                            )
                                        
                                    case .left:
                                        Image("leftSideImage")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: geometryReader.size.height * 0.42)
                                            .scaleEffect(isDragging ? 0.95 : 1.0)
                                            .clipped()
                                            .mask {
                                                RoundedRectangle(cornerRadius: 20)
                                            }
                                            .padding(.horizontal)
                                            .gesture(
                                                DragGesture(minimumDistance: 20)
                                                    .onChanged { _ in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = true
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = false
                                                        }
                                                        if value.translation.width < -50 {
                                                            withAnimation {
                                                                selectedHairSection = nextHairSection(from: selectedHairSection)
                                                            }
                                                        } else if value.translation.width > 50 {
                                                            withAnimation {
                                                                selectedHairSection = previousHairSection(from: selectedHairSection)
                                                            }
                                                        }
                                                    }
                                            )
                                        
                                    case .right:
                                        Image("rightSideImage")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: geometryReader.size.height * 0.42)
                                            .scaleEffect(isDragging ? 0.95 : 1.0)
                                            .clipped()
                                            .mask {
                                                RoundedRectangle(cornerRadius: 20)
                                            }
                                            .padding(.horizontal)
                                            .gesture(
                                                DragGesture(minimumDistance: 20)
                                                    .onChanged { _ in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = true
                                                        }
                                                    }
                                                    .onEnded { value in
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            isDragging = false
                                                        }
                                                        if value.translation.width < -50 {
                                                            withAnimation {
                                                                selectedHairSection = nextHairSection(from: selectedHairSection)
                                                            }
                                                        } else if value.translation.width > 50 {
                                                            withAnimation {
                                                                selectedHairSection = previousHairSection(from: selectedHairSection)
                                                            }
                                                        }
                                                    }
                                            )
                                        
                                    case .all:
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                Image("frontImage")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: geometryReader.size.height * 0.21)
                                                    .clipped()
                                                    .mask {
                                                        UnevenRoundedRectangle(topLeadingRadius: 20)
                                                    }
                                                    .onTapGesture(count: 2) {
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            selectedHairSection = .front
                                                        }
                                                    }
                                                Image("leftSideImage")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: geometryReader.size.height * 0.21)
                                                    .clipped()
                                                    .mask {
                                                        UnevenRoundedRectangle(topTrailingRadius: 20)
                                                    }
                                                    .onTapGesture(count: 2) {
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            selectedHairSection = .left
                                                        }
                                                    }
                                            }
                                            HStack(spacing: 0) {
                                                Image("backImage")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: geometryReader.size.height * 0.21)
                                                    .clipped()
                                                    .mask {
                                                        UnevenRoundedRectangle(bottomLeadingRadius: 20)
                                                    }
                                                    .onTapGesture(count: 2) {
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            selectedHairSection = .back
                                                        }
                                                    }
                                                
                                                Image("rightSideImage")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: geometryReader.size.height * 0.21)
                                                    .clipped()
                                                    .mask {
                                                        UnevenRoundedRectangle(bottomTrailingRadius: 20)
                                                    }
                                                    .onTapGesture(count: 2) {
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            selectedHairSection = .right
                                                        }
                                                    }
                                            }
                                        }
                                        .padding(.horizontal)
                                        .gesture(
                                            DragGesture(minimumDistance: 20)
                                                .onChanged { _ in
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        isDragging = true
                                                    }
                                                }
                                                .onEnded { value in
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        isDragging = false
                                                    }
                                                    if value.translation.width < -50 {
                                                        withAnimation {
                                                            selectedHairSection = nextHairSection(from: selectedHairSection)
                                                        }
                                                    } else if value.translation.width > 50 {
                                                        withAnimation {
                                                            selectedHairSection = previousHairSection(from: selectedHairSection)
                                                        }
                                                    }
                                                }
                                        )
                                    }
                                    
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
                                }
                                .frame(maxWidth: .infinity)
                            }
                            Text("\(selectedHairSection.label.capitalized) Notes")
                                .font(Font.custom("anta-regular", size: 20))
                                .foregroundStyle(Color.clippnotesYellow)
                                .padding(.leading, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(colors: [Color.clippnotesLightBlue,Color.clippnotesVeryLightBlue, Color.clippnotesLightBlue], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.5))
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    .padding(.horizontal)
                                Text(customer.haircuts[0].notesByView[selectedHairSection.label] ?? "")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                            }
                            .frame(height: geometryReader.size.height * 0.25)
                            Text("Haircuts")
                                .font(Font.custom("anta-regular", size: 20))
                                .foregroundStyle(Color.clippnotesYellow)
                                .padding(.leading, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                    }
                }
            }
        }
    }
    
    func nextHairSection(from current: HairSection) -> HairSection {
        let all = HairSection.allCases
        guard let index = all.firstIndex(of: current) else { return .all }
        return all[(index + 1) % all.count]
    }

    func previousHairSection(from current: HairSection) -> HairSection {
        let all = HairSection.allCases
        guard let index = all.firstIndex(of: current) else { return .all }
        return all[(index - 1 + all.count) % all.count]
    }
}

#Preview {
    ProfileScreen()
}
