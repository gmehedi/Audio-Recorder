//
//  RecordButton.swift
//  DemoRecorder
//
//  Created by M M MEHEDI HASAN on 9/2/21.
//  Copyright © 2021 Kiran Kumar. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    
    var recorderAndPlayer : VoiceRecorderAndPlayer = VoiceRecorderAndPlayer.sharedInstance
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recorderAndPlayer.record()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        recorderAndPlayer.stopRecording()
    }
}
