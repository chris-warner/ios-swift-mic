import SwiftUI
import AVFoundation
import AudioKit

struct ContentView: View {
    @State private var micStatus = false
    @State private var micStatusText = "Start Mic"
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            
            // Determine if the user previously authorized microphone access.
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
            Image(systemName: "waveform.path")
                .padding()
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Real Time Mic")
        }
        VStack {
            Button(micStatusText) {
                Task {
                    await startMic()
                }
            }
//            Button("Playback") {
//                Task {
//                    await startMic()
//                }
//            }
        }
        .padding()
    }
    
    func startMic() async {
        if micStatus {
            print("Mic Stopped")
            micStatus = false
            micStatusText = "Start Mic"
            audioRecorder?.stop()
        } else {
            guard await isAuthorized else { return }
            print("Mic Started")
            micStatus = true
            micStatusText = "Stop Mic"
            enableBuiltInMic()
        }
    }
    
    private func enableBuiltInMic() {
        // Get the shared audio session.
        let session = AVAudioSession.sharedInstance()
        
        // Find the built-in microphone input.
        guard let availableInputs = session.availableInputs,
              let builtInMicInput = availableInputs.first(where: { $0.portType == .builtInMic }) else {
            print("The device must have a built-in microphone.")
            return
        }
        
        // Make the built-in microphone input the preferred input.
        do {
            try session.setPreferredInput(builtInMicInput)
        } catch {
            print("Unable to set the built-in mic as the preferred input.")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
