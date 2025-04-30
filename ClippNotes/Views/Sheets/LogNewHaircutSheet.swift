//
//  LogNewHaircutSheet.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/18/25.
//

import SwiftUI

struct LogNewHaircutSheet: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showCamera = false
    @State private var hairImages: [HairSection:UIImage] = [:]
    @State private var haircutNotes: String = ""
    @State private var newHaircutSelectedHairSection: HairSection = .all
    
    
    let height: CGFloat = 793
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
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
                            .padding(1)
                            
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
                            .padding(1)
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
                            .padding(1)
                            
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
                            .padding(1)
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
                        .frame(height: 180)
                    }
                    .padding()
                }
                Button {
                    Task {
                        await viewModel.createHaircut(notes: haircutNotes, hairImages: hairImages)
                        await viewModel.fetchHaircutsForSelectedCustomer()
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
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView { image in
                hairImages[newHaircutSelectedHairSection] = image
            }
            .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }.foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    LogNewHaircutSheet()
}
