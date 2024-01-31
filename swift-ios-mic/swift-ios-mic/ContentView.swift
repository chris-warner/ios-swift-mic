//
//  ContentView.swift
//  swift-ios-mic
//
//  Created by christopher.warner on 1/31/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var micStatus = false;
    @State var micStatusText = "Start Mic";
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .audio)
            }
            
            return isAuthorized
        }
    }


    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
        // Set up the capture session.
    }

    var body: some View {
        VStack {
            Image(systemName: "waveform.path").padding()
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Real Time Mic")
        }
        VStack {
            Button(micStatusText) {
                Task {
                    await startMic();
                }
                
            }
        }
        .padding()
    }
    func startMic() async {
        if (micStatus) {
            print("Mic Stopped")
            micStatus = false;
            micStatusText = "Start Mic"
        } else {
            guard await isAuthorized else { return }
            print("Mic Started")
            micStatus = true;
            micStatusText = "Stop Mic"
        }
    }
}

#Preview {
    ContentView()
}
