//
//  ViewController.swift
//  DemoRecorder
//
//  Created by Kiran Kumar on 3/15/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var inputValue: UILabel!
    var isPlaying = false
    
    var recorderAndPlayer : VoiceRecorderAndPlayer = VoiceRecorderAndPlayer.sharedInstance
    var timer : Timer!
 
 
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(_recordingDidStart(_:)), name: RecordingDidStartNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_recordingDidFinish(_:)), name: RecordingDidFinishNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_playbackDidStart(_:)), name: PlaybackDidStartNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_playbackDidPause(_:)), name: PlaybackDidPauseNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_playbackDidFinish(_:)), name: PlaybackDidFinishNotification, object: recorderAndPlayer)
    }
    
    
    @available(iOS 13.0, *)
    @IBAction func goButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RecordingListVc") as? RecordingListVc
        vc?.recordingList = recorderAndPlayer.audioList
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func playPauseTouchUp(_ sender: Any) {
        if self.isPlaying {
            self.isPlaying = false
            self.recorderAndPlayer.pausePlayback()
        }else{
            self.isPlaying = true
            self.recorderAndPlayer.play()
        }
    }
    
    //MARK: Notification Responders
    @objc func _recordingDidStart(_ notification:Notification) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(_timerUpdate), userInfo: nil, repeats: true)
        timer.tolerance = 0.05
    }
    
    @objc func _recordingDidFinish(_ notification:Notification) {
        timer.invalidate()
    }
    
    @objc func _playbackDidStart(_ notification:Notification) {
        print("playbackDidStart")
    }
    
    @objc func _playbackDidPause(_ notification:Notification) {
        print("playbackDidPause")
    }
    
    @objc func _playbackDidFinish(_ notification:Notification) {
        print("playbackDidFinish")
    }
    
    @objc func _timerUpdate() {
        recorderAndPlayer.updateRecordingMeters()
        let levels : [Float] = recorderAndPlayer.getMeterLevel()
        inputValue.text = String(format: "%.2f", levels[0]) + " dB"
    }
}

