// LoadingView.swift created by Loudbook on 6/27/24.

import SwiftUI

struct LoadingView: View {
    let reason: String
    
    var body: some View {
        ProgressView()
            .scaleEffect(2)
        Text("Loading " + reason + "...")
            .font(.title2)
            .padding(.top, 20)
    }
}

#Preview {
    LoadingView(reason: "stuff")
}
