//
//  VoiceRecorderAndPlayer.swift
//  DemoRecorder
//
//  Created by Kiran Kumar on 3/17/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

let RecordingDidStartNotification = Notification.Name("RecordingDidStart")
let RecordingDidFinishNotification = Notification.Name("RecordingDidFinish")
let PlaybackDidStartNotification = Notification.Name("PlaybackDidStart")
let PlaybackDidPauseNotification = Notification.Name("PlaybackDidPause")
let PlaybackDidFinishNotification = Notification.Name("PlaybackDidFinish")

class VoiceRecorderAndPlayer : NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    private var _soundRecorder : AVAudioRecorder?
    private var _soundPlayer : AVAudioPlayer?
    private var _audioSession = AVAudioSession.sharedInstance()
    private var _filename = "audioFile"
    private var _playbackVolume : Float = 1.0
    private var _isPaused : Bool = false
    var audioList = [URL]()
    static let sharedInstance = VoiceRecorderAndPlayer()
    
    private override init() {
        
        super.init()
       // setUpRecorder()
        
        do {
            try _audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try _audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {}
    }
    
    private func setUpRecorder() {
        let newUrl = _filename + String(audioList.count) + ".aac"
        let audioFilename = getFullPath(forFilename: newUrl)
        self.audioList.append(audioFilename)
        let recordSettings = [AVFormatIDKey : kAudioFormatMPEG4AAC,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.0]
            as [String : Any]
        
        do {
            _soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSettings)
            _soundRecorder?.delegate = self
            _soundRecorder?.prepareToRecord()
            _soundRecorder?.isMeteringEnabled = true
        } catch {
            print(error)
        }
    }
    
    private func setUpPlayer() {
        if self.audioList.count == 0 {
            return
        }
        let audioFilename = self.audioList[self.audioList.count - 1]
        
        do {
            _soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            _soundPlayer?.delegate = self
            _soundPlayer?.prepareToPlay()
            _soundPlayer?.volume = _playbackVolume
        } catch {
            print(error)
        }
    }
    
    //MARK: Recording
    func record() {
        self.setUpRecorder()
        _soundRecorder?.record()
        NotificationCenter.default.post(name: RecordingDidStartNotification, object: self)
    }
    
    func stopRecording() {
        _soundRecorder?.stop()
    }
    
    func isRecording() -> Bool {
        return _soundRecorder?.isRecording ?? false
    }
    
    func updateRecordingMeters() {
        _soundRecorder?.updateMeters()
    }
    
    //MARK: Playback
    func play() {
        _soundPlayer?.play()
        _isPaused = false
        NotificationCenter.default.post(name: PlaybackDidStartNotification, object: self)
    }
    
    func pausePlayback() {
        _soundPlayer?.pause()
        _isPaused = true
        NotificationCenter.default.post(name: PlaybackDidPauseNotification, object: self)
    }
    
    func isPaused() -> Bool {
        return _isPaused
    }
    
    func stopPlayback() {
        _soundPlayer?.stop()
        _soundPlayer?.currentTime = 0
        _isPaused = false
        NotificationCenter.default.post(name: PlaybackDidFinishNotification, object: self)
    }
    
    func isPlaying() -> Bool {
        return _soundPlayer?.isPlaying ?? false
    }

    //MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        setUpPlayer()
        NotificationCenter.default.post(name: RecordingDidFinishNotification, object: self)
    }
    
    //MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        _isPaused = false
        NotificationCenter.default.post(name: PlaybackDidFinishNotification, object: self)
    }
    
    //MARK: - Utilities
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFullPath(forFilename : String) -> URL{
        let audioFullFilename = getDocumentDirectory().appendingPathComponent(forFilename)
        return audioFullFilename
    }
    
    func getMeterLevel() -> [Float] {
        var dbArray : [Float] = []
        let settings = _soundRecorder?.settings
        let numChannels : Int = settings?[AVNumberOfChannelsKey] as! Int
        for ch in 0...numChannels-1 {
            dbArray.append(_soundRecorder?.averagePower(forChannel: ch) ?? 0)
        }
        return dbArray
    }
}
