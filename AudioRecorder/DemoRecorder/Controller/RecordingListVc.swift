//
//  RecordingListVc.swift
//  DemoRecorder
//
//  Created by M M MEHEDI HASAN on 9/2/21.
//  Copyright © 2021 Kiran Kumar. All rights reserved.
//

import UIKit
import AVKit

class RecordingListVc: UIViewController {
    
    var recordingList = [URL]()
    
    var index = 0
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func tappedOnPlayButton(_ sender: Any) {
        if recordingList.count == 0 {
            return
        }
        index += 1
        index = index % recordingList.count
        
        let asset = AVAsset(url: self.recordingList[index])
        print("Duration ", asset.duration.seconds)
        let pItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: pItem)
        player?.play()
        
    }
}
