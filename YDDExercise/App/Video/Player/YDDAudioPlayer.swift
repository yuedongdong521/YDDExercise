//
//  YDDAudioPlayer.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/11.
//  Copyright © 2021 ydd. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

func playerAudioServices(name: String) {
    guard let path = Bundle.main.path(forResource: name, ofType: "") else {
        return
    }
    
    let url = URL(fileURLWithPath: path) as CFURL
    
    var soundId :SystemSoundID = 0
    
    AudioServicesCreateSystemSoundID(url, &soundId)
    AudioServicesPlaySystemSoundWithCompletion(soundId) {
        AudioServicesDisposeSystemSoundID(soundId)
    }
//    AudioServicesPlayAlertSoundWithCompletion(soundId) {
//        AudioServicesDisposeSystemSoundID(soundId)
//    }
}


class YDDAudioLocalPlayer: NSObject {
    /// 
    var audioLocalPlayer: AVAudioPlayer?
    
    func player(local url: String) -> Bool {
        
        destory()
        
        var playUrl: URL? = nil
        if url.hasPrefix("http") || url.hasPrefix("https") {
            SwiftLog("AVAudioPlayer 不支持在线播放")
            return false
        } else {
            playUrl = URL(fileURLWithPath: url)
        }
        
        guard let url = playUrl else {
            return false
        }
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: AVAudioSession.Mode.moviePlayback, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            } else {
                // Fallback on earlier versions
                try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            }
        } catch let err {
            SwiftLog("音频 Category 设置失败 err : \(err)")
        }
        
        
//        KTVHTTPCache.proxyURL(withOriginalURL: url)
        audioLocalPlayer = try? AVAudioPlayer(contentsOf: url)
        
        guard let player = audioLocalPlayer else {
            return false
        }
        player.delegate = self
        player.numberOfLoops = 0
        player.volume = 1
        player.rate = 1
        player.prepareToPlay()
        player.play()

        return true
    }
    
    func destory() {
        if let player = audioLocalPlayer {
            if player.isPlaying {
                player.stop()
            }
            audioLocalPlayer = nil
        }
    }
}

extension YDDAudioLocalPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        SwiftLog("播放完成 success ： \(flag)")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let err = error {
            SwiftLog("播放出错 err : \(err)")
        }
    }
}


