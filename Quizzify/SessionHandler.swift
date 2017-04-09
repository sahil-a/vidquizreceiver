//
//  SessionHandler.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class SessionHandler: NSObject, MCSessionDelegate {
    
    var serverPeer: MCPeerID
    var session: MCSession!
    var delegate: SessionHandlerDelegate?
    static var defaultSessionHandler: SessionHandler!
    var localPeer: Peer!
    var localName: String!
    var displayName: String!
    var multipeerClient: MultipeerClient
    
    init(server: MCPeerID, client: MultipeerClient) {
        self.serverPeer = server
        self.multipeerClient = client
        super.init()
    }
    
    func connect() {
        session = multipeerClient.connectToPeer(serverPeer, name: displayName)
        session.delegate = self
    }
    
    func disconnect() {
        session.disconnect()
    }
    
    @objc func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        if let questionDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String:AnyObject] {
            let question = Question(archive: questionDict)
            delegate?.sessionDidRecieveQuestion(question)
        }
    }
    
    func sendResponse(response: Response) {
        let data = response.archive()
        do {
            try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
        } catch {
            print("Error sending response")
        }
    }
    
    @objc func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case .Connected:
            delegate?.sessionDidConnect()
        case .NotConnected:
            delegate?.sessionDidDisconnect()
        case .Connecting:
            break
        }
    }
    
    @objc func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    @objc func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) { }
    @objc func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) { }
}

protocol SessionHandlerDelegate {
    func sessionDidRecieveQuestion(question: Question)
    func sessionDidConnect()
    func sessionDidDisconnect()
}
