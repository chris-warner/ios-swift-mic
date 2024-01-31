import SwiftUI
import AVFoundation

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
            Button("Playback") {
                Task {
                    await playbackMic()
                }
            }
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
            await setUpCaptureSessionA()
        }
    }

    func setUpCaptureSessionA() async {
        guard await isAuthorized else { return }

        // Set up the capture session.
        let captureSession = AVCaptureSession()
        print(captureSession.inputs)

        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            // Handle absence of audio device
            print("No audio device found.")
            return
        }

        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)

            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)

                // Initialize and start the audio recorder
                let audioURL = FileManager.default.temporaryDirectory.appendingPathComponent("audioRecording.caf")
                audioRecorder = try AVAudioRecorder(url: audioURL, settings: [:])
                audioRecorder?.record()
            } else {
                // Handle failure to add input
                print("Failed to add audio input to capture session.")
            }
        } catch {
            // Handle error
            print("Error setting up audio input: \(error.localizedDescription)")
        }

        // Continue with the rest of your capture session setup...
    }

    func playbackMic() async {
        guard let audioURL = audioRecorder?.url else {
            print("No recorded audio available.")
            return
        }

        do {
            // Initialize and play the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch {
            // Handle error
            print("Error playing recorded audio: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
