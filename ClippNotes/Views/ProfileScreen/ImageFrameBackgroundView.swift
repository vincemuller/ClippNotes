//
//  ImageFrameBackgroundView.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/29/25.
//

import SwiftUI

struct ImageFrameBackgroundView: View {
    
    let height: CGFloat
    
    var body: some View {
        UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 20, bottomTrailing: 20))
            .fill(LinearGradient(colors: [Color.clippnotesLightBlue,Color.clippnotesDarkBlue], startPoint: .bottom, endPoint: .top))
            .frame(height: height * 0.55)
    }
}

#Preview {
    ImageFrameBackgroundView(height: 763)
}
