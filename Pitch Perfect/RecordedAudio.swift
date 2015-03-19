//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by James Gilchrist on 3/7/15.
//  Copyright (c) 2015 James Gilchrist. All rights reserved.
//

import Foundation
import AVFoundation

class RecordedAudio {
    
    var filePathURL: NSURL!
    var title: String!
    
    init(title: String, path: NSURL) {
        self.title = title;
        self.filePathURL = path;
    }
    
    //computed variable: returns AVAudioFile for the NSURL
    var audioFile: AVAudioFile {
        get {
            return AVAudioFile(forReading: self.filePathURL, error: nil)
        }
    }
}