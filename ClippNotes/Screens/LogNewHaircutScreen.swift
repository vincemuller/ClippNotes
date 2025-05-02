//
//  LogNewHaircutSheet.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/18/25.
//

import SwiftUI

struct LogNewHaircutScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showCamera = false
    @State private var hairImages: [HairSection:UIImage] = [:]
    @State private var haircutNotes: String = ""
    @State private var newHaircutSelectedHairSection: HairSection = .all
    @State private var progressViewPresenting: Bool = false
    
    
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
                            
                            LogNewHaircutImageView(showCamera: $showCamera, newHaircutSelectedHairSection: $newHaircutSelectedHairSection, hairImage: $hairImages[.front], section: .front, height: height)
                                .padding(1)
                            
                            LogNewHaircutImageView(showCamera: $showCamera, newHaircutSelectedHairSection: $newHaircutSelectedHairSection, hairImage: $hairImages[.left], section: .left, height: height)
                                .padding(1)
                            
                        }
                        
                        HStack(spacing: 0) {
                            
                            LogNewHaircutImageView(showCamera: $showCamera, newHaircutSelectedHairSection: $newHaircutSelectedHairSection, hairImage: $hairImages[.back], section: .back, height: height)
                                .padding(1)
                            
                            LogNewHaircutImageView(showCamera: $showCamera, newHaircutSelectedHairSection: $newHaircutSelectedHairSection, hairImage: $hairImages[.right], section: .right, height: height)
                                .padding(1)
                            
                        }
                        HStack {
                            SectionTextView(text: "Stylist Notes")
                            Spacer()
                        }
                        .padding(.vertical)
                        LogNewHaircutNotesView(haircutNotes: $haircutNotes)
                    }
                    .padding()
                }
                Button {
                    
                    guard !haircutNotes.isEmpty || hairImages.count > 3 else {
                        print("Validation alert would be triggered here")
                        return
                    }
                    
                    progressViewPresenting = true
                    
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
            .onChange(of: viewModel.haircutThumbnails) { _, _ in
                progressViewPresenting = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .overlay {
            if progressViewPresenting {
                ZStack {
                    Color.black.opacity(0.1)
                    ProgressView()
                        .controlSize(.large)
                }
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
    LogNewHaircutScreen()
}
