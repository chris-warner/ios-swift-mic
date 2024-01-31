//
//  ContentView.swift
//  swift-ios-mic
//
//  Created by christopher.warner on 1/31/24.
//

import SwiftUI

struct ContentView: View {
    @State var micStatus = false;
    @State var micStatusText = "Start Mic";

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Real Time Mic")
        }
        VStack {
            Button(micStatusText) {
                startMic();
            }
        }
        .padding()
    }
     func startMic() {
        if (micStatus) {
            print("Mic Stopped")
            micStatus = false;
            micStatusText = "Start Mic"
        } else {
            print("Mic Started")
            micStatus = true;
            micStatusText = "Stop Mic"
        }
    }
}

#Preview {
    ContentView()
}
