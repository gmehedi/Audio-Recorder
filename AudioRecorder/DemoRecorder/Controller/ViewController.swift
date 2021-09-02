//
//  ViewController.swift
//  DemoRecorder
//
//  Created by Kiran Kumar on 3/15/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate { // KRKNOTES - Looks like protocols and superclasses are part of the same list. Here, I'm inheriting from UIViewController and conforming to two protocols

    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var inputValue: UILabel!
    
    
    var recorderAndPlayer : VoiceRecorderAndPlayer = VoiceRecorderAndPlayer.sharedInstance
    var timer : Timer!
    
    let playImage = UIImage(contentsOfFile:Bundle.main.path(forResource: "play", ofType: "png")!)
    let pauseImage = UIImage(contentsOfFile:Bundle.main.path(forResource: "pause", ofType: "png")!)
    
    let playImageID = "ButtonPlay"
    let pauseImageID = "ButtonPause"
 
    override func viewDidLoad() {
        super.viewDidLoad()

       // playPauseButton.isEnabled = false
        playPauseButton.accessibilityIdentifier = playImageID
      //  stopButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(_recordingDidStart(_:)), name: RecordingDidStartNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_recordingDidFinish(_:)), name: RecordingDidFinishNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_playbackDidStart(_:)), name: PlaybackDidStartNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_playbackDidPause(_:)), name: PlaybackDidPauseNotification, object: recorderAndPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(_playbackDidFinish(_:)), name: PlaybackDidFinishNotification, object: recorderAndPlayer)
        
        var tapGesture: UITapGestureRecognizer {
            let t = UITapGestureRecognizer(target: self, action: #selector(touchDown(_: )))
            t.numberOfTouchesRequired = 1
            return t
        }
        self.recordButton.addGestureRecognizer(tapGesture)
        
        self.recordButton.addTarget(self, action: #selector(touchDown1), for: .touchDown)
        self.recordButton.addTarget(self, action: #selector(touchOut), for: [.touchCancel, .touchUpOutside, .touchDragExit, .touchDragOutside])
    }
    
    //MARK: IBActions
    @IBAction func recordTouchUp(_ sender: Any) {
//        recorderAndPlayer.record()
    }
    
    @available(iOS 13.0, *)
    @IBAction func goButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RecordingListVc") as? RecordingListVc
        vc?.recordingList = recorderAndPlayer.audioList
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func playPauseTouchUp(_ sender: Any) {
        let identifier = playPauseButton.accessibilityIdentifier!
        if (identifier.elementsEqual(playImageID)) {
            recorderAndPlayer.play()
        } else if (identifier.elementsEqual(pauseImageID)) {
            recorderAndPlayer.pausePlayback()
        } else {
            assert(false, "ViewController::playPauseTouchUp -> Unexpected button identifier")
        }
    }
    
    @IBAction func stopTouchUp(_ sender: Any) {
        if (recorderAndPlayer.isRecording()) {
            recorderAndPlayer.stopRecording()
        }
        else if (recorderAndPlayer.isPlaying() || recorderAndPlayer.isPaused()) {
            recorderAndPlayer.stopPlayback()
        }
    }
    
    //MARK: Notification Responders
    @objc func _recordingDidStart(_ notification:Notification) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(_timerUpdate), userInfo: nil, repeats: true)
        timer.tolerance = 0.05
//        playPauseButton.isEnabled = false
//        recordButton.isEnabled = false
//        stopButton.isEnabled = true
    }
    
    @objc func _recordingDidFinish(_ notification:Notification) {
        timer.invalidate()
//        recordButton.isEnabled = true
//        playPauseButton.isEnabled = true
//        stopButton.isEnabled = false
    }
    
    @objc func _playbackDidStart(_ notification:Notification) {
       // recordButton.isEnabled = false
        updateButton(button : playPauseButton, image: pauseImage!, identifer: pauseImageID)
       // stopButton.isEnabled = true
    }
    
    @objc func _playbackDidPause(_ notification:Notification) {
        updateButton(button : playPauseButton, image: playImage!, identifer: playImageID)
    }
    
    @objc func _playbackDidFinish(_ notification:Notification) {
        updateButton(button : playPauseButton, image: playImage!, identifer: playImageID)
       // recordButton.isEnabled = true;
        //stopButton.isEnabled = false
    }
    
    //MARK: - Other
    func updateButton(button : UIButton, image : UIImage, identifer : String) {
        button.setImage(image, for: .normal)
        button.accessibilityIdentifier = identifer
    }
    
    @objc func _timerUpdate() {
        recorderAndPlayer.updateRecordingMeters()
        let levels : [Float] = recorderAndPlayer.getMeterLevel()
        inputValue.text = String(format: "%.2f", levels[0]) + " dB"
    }
    
    @objc func touchDown(_ sender: UITapGestureRecognizer) {
      
        switch sender.state {
        case .began:
            print("ISide111 ")
            break
        case .changed:
            print("OHooo ")
            break
        case .ended:
            print("OutSide ")
            recorderAndPlayer.stopRecording()
            break
        default:
            print("Not match")
        }
    }
    
    @objc func touchDown1() {
        print("ISide ")
        recorderAndPlayer.record()
        print("ISide222 ")
    }
    
    @objc func touchOut() {
        print("OutSide 222222")
    }
}

