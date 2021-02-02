//
//  YDDVideoPlayer.swift
//  YDDExercise
//
//  Created by ydd on 2021/2/1.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation
import AVFoundation


@objcMembers class YDDVideoPlayer: UIView {
    
    private var proObserver: Any?
    private var hasObser = false
    private var lastLoadTime: Double = 0
    
    var curUrl = ""
    var playerProgressBlock: ((_ progress: Double, _ duration: Double)->Void)?
    var loadStatueBlock: ((_ finished: Bool) -> Void)?
    var videoMode: AVLayerVideoGravity = .resizeAspectFill {
        didSet {
            self.playerLayer.videoGravity = videoMode
        }
    }
    
    var mute: Bool = true {
        didSet {
            player.isMuted = mute
        }
    }
    
    var isPlaying: Bool = false
    var isLoop: Bool = true
    
    lazy var player: AVPlayer = {
        let player = AVPlayer.init()
        
        return player
    }()
    
    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: self.player)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(self.playerLayer)
        
    }
    
    deinit {
        removeObserVer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.playerLayer.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play(_ videoUrl: String) -> Bool {
        
        var url: URL? = nil
        if videoUrl.hasPrefix("http") || videoUrl.hasPrefix("https") {
            let tmpUrl = URL(string: videoUrl)
            url = KTVHTTPCache.proxyURL(withOriginalURL: tmpUrl)
            if url == nil {
                url = tmpUrl
            }
        } else {
            url = URL(fileURLWithPath: videoUrl)
        }
        guard let playUrl = url else {
            return false
        }
        destory()
        
        
        
        self.curUrl = videoUrl
        
        let playItem = AVPlayerItem.init(url: playUrl)
        self.player.replaceCurrentItem(with: playItem)
        addObserVer()
        self.loadStatueBlock?(false)
        hidPlayLayer(true)
        return true
    }
    
    func play() {
        self.player.play()
        self.isPlaying = true
    }
    
    func pause() {
        self.player.pause()
        self.isPlaying = false
    }
    
    func destory() {
        pause()
        removeObserVer()
    }
    
    private func addObserVer() {
        
        guard let curItem = self.player.currentItem else {
            return
        }
        self.hasObser = true
        curItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        curItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        proObserver = self.player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let self = self else {
                return
            }
            let curTime = CMTimeGetSeconds(time)
            var totalTime: Double = 0
            if let curTime = self.player.currentItem {
               totalTime = CMTimeGetSeconds(curTime.duration)
            }
            if totalTime > 0 {
                self.playerProgressBlock?(curTime / totalTime, totalTime)
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    @objc func didPlayFinished(_ notify: Notification) {
        if self.isLoop {
            self.player.seek(to: CMTime.zero)
            play()
        }
    }
    
    private func removeObserVer() {
        guard let curItem = self.player.currentItem else {
            return
        }
        
        if !hasObser {
            return
        }
        hasObser = false
        curItem.removeObserver(self, forKeyPath: "status", context: nil)
        curItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        if let observer = proObserver {
            player.removeTimeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func cacheProgress() -> Double {
        guard let curItem = self.player.currentItem else {
            return 0
        }
        guard let value = curItem.loadedTimeRanges.first else {
            return 0
        }
        
        let time = value.timeRangeValue
        
        let start = CMTimeGetSeconds(time.start)
        let duration = CMTimeGetSeconds(time.duration)
        return start + duration
    }
    
    private func hidPlayLayer(_ hidden: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.isHidden = hidden
        CATransaction.commit()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard (object as? AVPlayerItem) != nil else {
            return
        }
        
        if keyPath == "status" {
            guard let dic = change else {
                return
            }
            
            guard let newValue = dic[NSKeyValueChangeKey.newKey] else {
                return
            }
            
            let statue = newValue as? Int ?? 0
            if AVPlayerItem.Status(rawValue: statue) == AVPlayerItem.Status.readyToPlay {
                play()
                hidPlayLayer(false)
                self.loadStatueBlock?(true)
            } else {
                SwiftLog("播放失败 url: \(curUrl)")
            }
            
        } else if keyPath == "loadedTimeRanges" {
            let loadProgress = cacheProgress()
            SwiftLog("缓存进度 ：\(loadProgress)")
            let playTime = CMTimeGetSeconds(player.currentTime())
            if playTime == lastLoadTime {
                SwiftLog("播放卡顿")
            }
            
            lastLoadTime = playTime
            
        }
    }
}
