//
//  ContentView.swift
//  SoundVibes
//
//  Created by TheForce on 9/25/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    
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
            
            Button {
                //TODO: Button Action
            } label: {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
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
