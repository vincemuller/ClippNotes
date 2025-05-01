//
//  LargeImageTabView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/28/25.
//

import SwiftUI

struct LargeImageTabView: View {
    
    let downloadedImage: UIImage?
    let height: CGFloat
    let hairSection: HairSection
    
    var body: some View {
        ZStack {
            if let image = downloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(height: height * 0.42)
            } else {
                ProgressView()
                    .overlay(Text("Loading..."))
                    .frame(height: height * 0.42)
            }
        }
        .frame(height: height * 0.42)
        .clipped()
        .mask(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
        .tag(hairSection)
    }
}

#Preview {
    LargeImageTabView(downloadedImage: UIImage(), height: 200, hairSection: HairSection.front)
}
