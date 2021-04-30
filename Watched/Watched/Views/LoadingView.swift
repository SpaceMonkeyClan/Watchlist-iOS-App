//
//  LoadingView.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI

/// Custom loading view
struct LoadingView: View {
    
    @Binding var loading: Bool
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            if loading {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                ProgressView("please wait...")
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
