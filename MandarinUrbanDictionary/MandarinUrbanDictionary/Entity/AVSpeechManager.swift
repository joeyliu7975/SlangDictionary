//
//  AVSpeechManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/25/20.
//

import AVFoundation
import Foundation

protocol AVSpeechDelegate: class {
    func delegation(_ delegate: AVSpeechSynthesizerDelegate?)
}

class AVSpeechManager {
    
    private let voiceSynth = AVSpeechSynthesizer()
    
    weak var delegate: AVSpeechDelegate?
    
    func voiceSynthDelegate(_ controller: AVSpeechSynthesizerDelegate) {
        voiceSynth.delegate = controller
    }
    
    func speak(_ word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        utterance.rate = 0.35

        voiceSynth.speak(utterance)
    }
    
    func speechDidFinish(_ completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
