//
//  MultipeerClient.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 4/29/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import Foundation
import MultipeerConnectivity

typealias stateChange = ((state: MCSessionState, peerID: MCPeerID) -> ())?

struct Peer {
    var name: String
}

final class MultipeerClient: NSObject, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    // MARK: Properties
    
    let localPeerID = MCPeerID(displayName: "?r")
    let browser: MCNearbyServiceBrowser?
    private(set) var session: MCSession?
    private(set) var state = MCSessionState.NotConnected
    var onStateChange: stateChange?
    var discoveredPeers: [MCPeerID] = []
    var latestQuestion: Question!
    
    // MARK: Init
    
    override init() {
        browser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: "quizzify")
        super.init()
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    // MARK: Send
    
    func send(data: NSData) {
        guard let session = session else { return }
        do {
            try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
        } catch {}
    }
    
    func sendString(string: NSString) {
        if let stringData = string.dataUsingEncoding(NSUTF8StringEncoding) {
            send(stringData)
        }
    }
    
    // MARK: MCNearbyServiceBrowserDelegate
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo
        info: [String : String]?) {
        
        discoveredPeers.append(peerID)
        
        // for now
        if session == nil {
            session = MCSession(peer: localPeerID)
            session?.delegate = self
        }
        browser.invitePeer(peerID, toSession: session!, withContext: nil, timeout: 30)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for i in 0..<discoveredPeers.count {
            if i < discoveredPeers.count {
            if discoveredPeers[i] == peerID {
                discoveredPeers.removeAtIndex(i)
                break
            }
            }
        }
    }
    
    // MARK: MCSessionDelegate
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        self.state = state
        onStateChange??(state: state, peerID: peerID)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        if let questionDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String:AnyObject] {
            let question = Question(archive: questionDict)
            print(question)
            latestQuestion = question
        }
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
}

