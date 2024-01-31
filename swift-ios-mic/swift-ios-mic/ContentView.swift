//
//  ContentView.swift
//  swift-ios-mic
//
//  Created by christopher.warner on 1/31/24.
//

import SwiftUI

struct ContentView: View {
    @State var micStatus = false;
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Real Time Mic")
        }
        VStack {
            Button("Start Mic") {
                self.startMic();
            }
        }
        .padding()
    }
     func startMic() {
        if (micStatus) {
            print("Mic Stopped")
            micStatus = false;
        } else {
            print("Mic Started")
            micStatus = true;
        }
    }
}

#Preview {
    ContentView()
}
