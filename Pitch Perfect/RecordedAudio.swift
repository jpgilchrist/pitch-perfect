//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by James Gilchrist on 3/7/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import AVFoundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    //computed variable: returns AVAudioFilf for the NSURL 
    var audioFile: AVAudioFile {
        get {
            return AVAudioFile(forReading: self.filePathURL, error: nil)
        }
    }
}