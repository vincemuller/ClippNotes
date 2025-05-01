//
//  GridImageTabView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/28/25.
//

import SwiftUI

struct GridImageTabView: View {
    
    @Binding var selectedHairSection: HairSection
    
    let haircutImages: HaircutUIImages?
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ZStack {
                    if let frontImage = haircutImages?.front {
                        Image(uiImage: frontImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(height: height * 0.21)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.clippnotesLightBlue)
                                .clipped()
                                .mask {
                                    UnevenRoundedRectangle(topLeadingRadius: 20)
                                }
                            ProgressView()
                        }
                    }
                }
                .frame(height: height * 0.21)
                .clipped()
                .padding(1)
                .mask {
                    UnevenRoundedRectangle(topLeadingRadius: 20)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedHairSection = .front
                    }
                }
                
                ZStack {
                    if let leftImage = haircutImages?.left {
                        Image(uiImage: leftImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(height: height * 0.21)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.clippnotesLightBlue)
                                .clipped()
                                .mask {
                                    UnevenRoundedRectangle(topTrailingRadius: 20)
                                }
                            ProgressView()
                        }
                    }
                }
                .frame(height: height * 0.21)
                .clipped()
                .padding(1)
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
                    if let backImage = haircutImages?.back {
                        Image(uiImage: backImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(height: height * 0.21)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.clippnotesLightBlue)
                                .clipped()
                                .mask {
                                    UnevenRoundedRectangle(bottomLeadingRadius: 20)
                                }
                            ProgressView()
                        }
                    }
                }
                .frame(height: height * 0.21)
                .clipped()
                .padding(1)
                .mask {
                    UnevenRoundedRectangle(bottomLeadingRadius: 20)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedHairSection = .back
                    }
                }
                
                ZStack {
                    if let rightImage = haircutImages?.right {
                        Image(uiImage: rightImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(height: height * 0.21)
                    } else {
                        ZStack {
                            Rectangle()
                                .fill(Color.clippnotesLightBlue)
                                .clipped()
                                .mask {
                                    UnevenRoundedRectangle(bottomTrailingRadius: 20)
                                }
                            ProgressView()
                        }
                    }
                }
                .frame(height: height * 0.21)
                .clipped()
                .padding(1)
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
    }
}

#Preview {
    GridImageTabView(selectedHairSection: .constant(HairSection.all), haircutImages: HaircutUIImages(), height: 393)
}
