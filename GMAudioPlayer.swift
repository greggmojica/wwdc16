//
//  GMAudioPlayer.swift
//  greggMojica
//
//  Created by Gregg Mojica on 5/1/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//


import UIKit
import AVFoundation

class GMAudioPlayer: NSObject {
    let synthesis = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")

    func readAudio(stringText: String) {
        utterance = AVSpeechUtterance(string: stringText)
        utterance.rate = 0.5
        synthesis.speakUtterance(utterance)
    }
}
