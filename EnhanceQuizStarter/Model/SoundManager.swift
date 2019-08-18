//
//  SoundManager.swift
//  EnhanceQuizStarter
//
//  Created by Jörg Klausewitz on 15.08.19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager{
    
    var audioPlayer: AVAudioPlayer?
    
    init(){
        self.audioPlayer = AVAudioPlayer()
    }
    
 
    public func play(_ soundName: String) {
        
        guard let path = Bundle.main.path(forResource: soundName + ".wav", ofType: nil) else {
            print("Path to resource is nil. Can't process.")
            return
        }
 
        let url = URL(fileURLWithPath: path)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
        } catch {
            print("Couldn't load file")
        }
    }
    
   
    
    public func stop(){
        self.audioPlayer?.stop()
    }

    
}
