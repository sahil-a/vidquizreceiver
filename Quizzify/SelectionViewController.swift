//
//  SelectionViewController.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var csv1: ColorSelectionView!
    @IBOutlet weak var csv2: ColorSelectionView!
    @IBOutlet weak var csv3: ColorSelectionView!
    @IBOutlet weak var csv4: ColorSelectionView!
    @IBOutlet weak var csv5: ColorSelectionView!
    @IBOutlet weak var csv6: ColorSelectionView!
    @IBOutlet weak var joinButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    var selected: Int = 0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for t in touches {
            
            let loc = t.locationInView(self.view)
            let csvs = [csv1,csv2,csv3,csv4,csv5,csv6]
            
            for i in 0..<csvs.count {
                let csv = csvs[i]
                if CGRectContainsPoint(csv.frame, loc) {
                    csv.selected = true
                    selected = i
                    for cs in csvs {
                        if csv != cs {
                            cs.selected = false
                        }
                    }
                }
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier!
        if identifier == "join" {
            SessionHandler.defaultSessionHandler.localName = textField.text
            var letter = "r"
            if csv1.selected {
                
                letter = "y"
            } else if csv2.selected {
                
                letter = "p"
            } else if csv3.selected {
                letter = "g"
            } else if csv4.selected {
                letter = "u"
            } else if csv5.selected {
                letter = "r"
            } else if csv6.selected {
                letter = "b"
            }
            
            let initial = textField.text!.substringToIndex(textField.text!.startIndex.advancedBy(1))
            SessionHandler.defaultSessionHandler.localPeer = Peer(displayName: initial+letter)
            SessionHandler.defaultSessionHandler.displayName = initial+letter
            SessionHandler.defaultSessionHandler.connect()
        }
    }
    
    @IBAction func editingChanged(sender: UITextField) {
        if sender.text != "" {
            joinButton.enabled = true
        } else {
            joinButton.enabled = false
        }
    }
    
}
