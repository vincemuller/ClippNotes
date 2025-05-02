//
//  LogNewHaircutImageView.swift
//  ClippNotes
//
//  Created by Vince Muller on 5/1/25.
//

import SwiftUI

struct LogNewHaircutImageView: View {
    
    @Binding var showCamera: Bool
    @Binding var newHaircutSelectedHairSection: HairSection
    @Binding var hairImage: UIImage?
    
    let section: HairSection
    let height: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clippnotesLightBlue)
                .clipped()
                .mask {
                    switch section {
                    case .front:
                        UnevenRoundedRectangle(topLeadingRadius: 20)
                    case .back:
                        UnevenRoundedRectangle(bottomLeadingRadius: 20)
                    case .left:
                        UnevenRoundedRectangle(topTrailingRadius: 20)
                    case .right:
                        UnevenRoundedRectangle(bottomTrailingRadius: 20)
                    default:
                        EmptyView()
                    }
                }
            Button {
                showCamera = true
                newHaircutSelectedHairSection = section
            } label: {
                if let image = hairImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: height * 0.21)
                        .mask {
                            switch section {
                            case .front:
                                UnevenRoundedRectangle(topLeadingRadius: 20)
                            case .back:
                                UnevenRoundedRectangle(bottomLeadingRadius: 20)
                            case .left:
                                UnevenRoundedRectangle(topTrailingRadius: 20)
                            case .right:
                                UnevenRoundedRectangle(bottomTrailingRadius: 20)
                            default:
                                EmptyView()
                            }

                        }
                } else {
                    VStack {
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.white.opacity(0.3))
                        Text(section.label)
                            .font(Font.custom("anta-regular", size: 20))
                            .foregroundStyle(Color.white.opacity(0.3))
                    }
                }
            }
        }
        .frame(height: height * 0.21)
    }
}

#Preview {
    LogNewHaircutImageView(showCamera: .constant(false), newHaircutSelectedHairSection: .constant(.left), hairImage: .constant(.none), section: .front, height: 763)
}
