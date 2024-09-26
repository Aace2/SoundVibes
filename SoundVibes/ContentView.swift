//
//  ContentView.swift
//  SoundVibes
//
//  Created by TheForce on 9/25/24.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var speakerImage = Image("speaker01")
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("speaker01")
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "bass02")
                    animateImage = false //will immediately shrink using .scaleEffect to 90% of size
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5)) {
                        animateImage = true
                    }
                }
                
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    do {
                        if let data = try await selectedPhoto?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                speakerImage = Image(uiImage: uiImage)
                            }
                        }
                    } catch {
                        print("😡 ERROR: loading failed \(error.localizedDescription)")
                    }
                }
            }
        }
        .padding()
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audio player")
        }
    }
    
}

#Preview {
    ContentView()
}
