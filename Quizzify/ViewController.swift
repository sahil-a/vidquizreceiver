//
//  ViewController.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 4/21/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

    private let multipeerClient = MultipeerClient()

    @IBAction func respond(sender: UIButton) {
        let response = Response(responder: "Sahil", choice: 1, question: multipeerClient.latestQuestion)
        multipeerClient.send(response.archive())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerClient.onStateChange = { state, peerID in
            let client = self.multipeerClient
            switch state {
            case .NotConnected:
                print("Not Connected")
                if let session = client.session where session.connectedPeers.count == 0 {
                    client.browser?.invitePeer(peerID, toSession: session, withContext: nil,
                                               timeout: 30)
                }
            case .Connecting:
                print("Connecting...")
            case .Connected:
                print("Connected")
            }
            dispatch_async(dispatch_get_main_queue()) {
            }
        }

    }

}
