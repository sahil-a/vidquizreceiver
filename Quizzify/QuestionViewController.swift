//
//  QuestionViewController.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, SessionHandlerDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var one: UIView!
    @IBOutlet weak var two: UIView!
    @IBOutlet weak var three: UIView!
    @IBOutlet weak var four: UIView!
    @IBOutlet weak var submitButton: UIButton!
    var currentQuestion: Question!
    var selected: Int = -1
    var questionArrived = false
    
    override func viewWillDisappear(animated: Bool) {
        SessionHandler.defaultSessionHandler.disconnect()
    }
    
    override func viewWillAppear(animated: Bool) {
        SessionHandler.defaultSessionHandler.delegate = self
    }
    
    func sessionDidConnect() {
        
    }
    
    func sessionDidDisconnect() {
        presentingViewController!.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        submitButton.enabled = false
        questionArrived = false
        SessionHandler.defaultSessionHandler.sendResponse(responseFromUI())
        labelOne.text = "------"
        questionLabel.text = "Waiting for question..."
        labelTwo.text = "------"
        labelThree.text = "------"
        labelFour.text = "------"
        one.backgroundColor = UIColor(colorLiteralRed: 96 / 255, green: 145 / 255, blue: 182 / 255, alpha: 0.67)
        two.backgroundColor = UIColor(colorLiteralRed: 96 / 255, green: 145 / 255, blue: 182 / 255, alpha: 0.67)
        three.backgroundColor = UIColor(colorLiteralRed: 96 / 255, green: 145 / 255, blue: 182 / 255, alpha: 0.67)
        four.backgroundColor = UIColor(colorLiteralRed: 96 / 255, green: 145 / 255, blue: 182 / 255, alpha: 0.67)
        selected = -1
    }
    
    func responseFromUI() -> Response {
        let response = Response(responder: SessionHandler.defaultSessionHandler.localName , choice: selected, question: currentQuestion)
        return response
    }
    
    func sessionDidRecieveQuestion(question: Question) {
        currentQuestion = question
        loadUIForQuestion()
        questionArrived = true
        submitButton.enabled = true
    }
    
    func loadUIForQuestion() {
        questionLabel.text = currentQuestion.question
        labelOne.text = answerForNumber(1, question: currentQuestion).text
        labelTwo.text = answerForNumber(2, question: currentQuestion).text
        labelThree.text = answerForNumber(3, question: currentQuestion).text
        labelFour.text = answerForNumber(4, question: currentQuestion).text
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if questionArrived {
            for t in touches {
                let loc = t.locationInView(self.view)
                one.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                two.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                three.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                four.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                if CGRectContainsPoint(one.frame, loc) {
                    one.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                    selected = 1
                    submitButton.enabled = true
                }
                
                if CGRectContainsPoint(two.frame, loc) {
                    two.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                    selected = 2
                    submitButton.enabled = true
                }
                
                if CGRectContainsPoint(three.frame, loc) {
                    three.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                    selected = 3
                    submitButton.enabled = true
                }
                
                if CGRectContainsPoint(four.frame, loc) {
                    four.backgroundColor = UIColor(colorLiteralRed: 86 / 255, green: 124 / 255, blue: 173 / 255, alpha: 1)
                    selected = 4
                    submitButton.enabled = true
                }
            }
        }
    }
    
    func answerForNumber(number: Int, question: Question) -> (text: String, isCorrect: Bool, number: Int) {
        for answer in question.answers {
            if answer.number == number {
                
                return answer
            }
        }
        return question.answers[0]
    }
}
