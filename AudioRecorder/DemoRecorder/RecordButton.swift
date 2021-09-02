//
//  RecordButton.swift
//  DemoRecorder
//
//  Created by M M MEHEDI HASAN on 9/2/21.
//  Copyright © 2021 Kiran Kumar. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Begin")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("End")
    }
}
