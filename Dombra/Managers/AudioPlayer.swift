//
//  AudioPlayer.swift
//  Dombra
//
//  Created by Metah on 3/1/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioPlayer {
    // MARK:- Properties
    static var backgroundAudioPlayer: AVAudioPlayer = {
        let player = AVAudioPlayer()
        player.numberOfLoops = -1
        return player
    }()
    static var metronomeAudioPlayer: AVAudioPlayer = {
        let player = AVAudioPlayer()
        player.numberOfLoops = -1
        return player
    }()
    static var firstStringPlayer = AVAudioPlayer()
    static var secondStringPlayer = AVAudioPlayer()
    static var audioQueue = DispatchQueue.global(qos: .userInteractive)
    
    
    // MARK:- Background Audio
    static func turnOnBackgroundMusic() {
        let url = setupPaths(name: "Qosalqa", ext: "mp3")
        initPlayers(player: &backgroundAudioPlayer, url: url)
        backgroundAudioPlayer.play()
    }
    
    // MARK:- The Dombra Strings
    static func playFirstStringNote(_ index: Int) {
        firstStringPlayer.stop()
        let url = setupPaths(name: "u\(index)", ext: "m4a")
        initPlayers(player: &firstStringPlayer, url: url)
        firstStringPlayer.play()
    }
    
    static func playSecondStringNote(_ index: Int) {
        secondStringPlayer.stop() 
        let url = setupPaths(name: "d\(index)", ext: "m4a")
        initPlayers(player: &secondStringPlayer, url: url)
        secondStringPlayer.play()
    }
    
    static func playMetronomeBeat() {
        let url = setupPaths(name: "beat", ext: "mp3")
        initPlayers(player: &metronomeAudioPlayer, url: url)
        metronomeAudioPlayer.play()
    }
    
    // MARK:- Players' Setup    
    private static func setupPaths(name: String, ext: String) -> URL {
        let filePath = Bundle.main.path(forResource: name, ofType: ext)
        let url = URL.init(fileURLWithPath: filePath!)
        return url
    }
    
    private static func initPlayers(player: inout AVAudioPlayer, url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            return
        }
    }
}

