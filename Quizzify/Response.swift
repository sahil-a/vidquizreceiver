//
//  Response.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import Foundation

struct Response {
    
    var responder: String
    var choice: Int
    var question: Question
    
    func archive() -> NSData {
        var dict: [String: AnyObject] = [:]
        dict["responder"] = responder
        dict["choice"] = choice
        dict["question"] = question.archive()
        return NSKeyedArchiver.archivedDataWithRootObject(dict)
    }
    
    init(responder: String, choice: Int, question: Question) {
        self.responder = responder
        self.choice = choice
        self.question = question
    }
    
    init(archive: NSData) {
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(archive) as! [String:AnyObject]
        responder = dict["responder"] as! String
        choice = dict["choice"] as! Int
        question = Question(archive: dict["question"] as! [String: AnyObject])
    }
}
