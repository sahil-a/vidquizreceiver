//
//  Question.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 4/28/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import Foundation
import AVFoundation

struct Question {
    
    var question: String
    var answers: [(text: String, isCorrect: Bool, number: Int)]
    var start: CMTime!
    var end: CMTime!
    
    func archive() -> [String:AnyObject] {
        var dict: [String: AnyObject] = [:]
        dict["question"] = question
        dict["start"] = Double(CMTimeGetSeconds(start))
        dict["end"] = Double(CMTimeGetSeconds(end))
        var rawanswers: [[String: AnyObject]] = []
        for answer in answers {
            var aDict: [String: AnyObject] = [:]
            aDict["text"] = answer.text
            aDict["isCorrect"] = answer.isCorrect
            aDict["number"] = answer.number
            rawanswers.append(aDict)
        }
        dict["answers"] = rawanswers
        return dict
    }
    
    init(question: String, answers: [(text: String, isCorrect: Bool, number: Int)]) {
        self.question = question
        self.answers = answers
    }
    
    init(archive: [String: AnyObject]) {
        question = archive["question"] as! String
        start = CMTimeMakeWithSeconds(archive["start"] as! Double, 10)
        end = CMTimeMakeWithSeconds(archive["end"] as! Double, 10)
        answers = [(text: String, isCorrect: Bool, number: Int)]()
        let rawanswers: [[String: AnyObject]] = archive["answers"] as! [[String:AnyObject]]
        for answer in rawanswers {
            answers.append((text: answer["text"] as! String, isCorrect: answer["isCorrect"] as! Bool, number: answer["number"] as! Int))
        }
    }
}
