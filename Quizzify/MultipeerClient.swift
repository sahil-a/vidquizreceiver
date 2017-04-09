//
//  MultipeerClient.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 4/29/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import Foundation
import MultipeerConnectivity

typealias stateChange = ((state: State, video: Video) -> ())?

enum State {
    case Found, Lost
}

struct Peer {
    var letter: String
    var color: UIColor
    
    init(displayName: String) {
        letter = displayName.substringToIndex(displayName.startIndex.successor())
        let colorString = displayName.substringFromIndex(displayName.startIndex.successor())
        switch colorString {
        case "r":
            color = UIColor(colorLiteralRed: 233 / 255, green: 99 / 255, blue: 99 / 255, alpha: 1)
        case "g":
            color = UIColor(colorLiteralRed: 92 / 255, green: 217 / 255, blue: 170 / 255, alpha: 1)
        case "b":
            color = UIColor(colorLiteralRed: 99 / 255, green: 187 / 255, blue: 233 / 255, alpha: 1)
        case "y":
            color = UIColor(colorLiteralRed: 229 / 255, green: 208 / 255, blue: 150 / 255, alpha: 1)
        case "p":
            color = UIColor(colorLiteralRed: 216 / 255, green: 111 / 255, blue: 173 / 255, alpha: 1)
        case "u":
            color = UIColor(colorLiteralRed: 174 / 255, green: 150 / 255, blue: 229 / 255, alpha: 1)
            
        default:
            color = UIColor.whiteColor()
        }
    }
}


struct Video {
    var name: String
    var peers: [Peer]
    var peerID: MCPeerID
}

final class MultipeerClient: NSObject, MCNearbyServiceBrowserDelegate {
    
    // MARK: Properties
    
    var localPeerID = MCPeerID(displayName: "?r")
    let browser: MCNearbyServiceBrowser?
    var onStateChange: stateChange?
    var videos: [Video] = []
    
    
    
    // MARK: Init
    override init() {
        browser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: "quizzify")
        super.init()
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    func connectToPeer(peerID: MCPeerID, name: String) -> MCSession {
        
        let session = MCSession(peer: localPeerID)
        
        browser!.invitePeer(peerID, toSession: session, withContext: NSKeyedArchiver.archivedDataWithRootObject(name), timeout: 10)
        return session
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo
        info: [String : String]?) {
        
        let name = info!["name"]!
        var connectedPeers = info!["connected"]!
        var peers: [Peer] = []
        var counter = 0
        while counter < connectedPeers.characters.count {
            let dn = connectedPeers.substringToIndex(connectedPeers.startIndex.advancedBy(2))
            peers.append(Peer(displayName: dn))
            connectedPeers = connectedPeers.substringFromIndex(connectedPeers.startIndex.advancedBy(2))
            counter += 1
        }
        
        videos.append(Video(name: name, peers: peers, peerID: peerID))
        onStateChange??(state: .Found, video: videos.last!)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for i in 0..<videos.count {
            if i < videos.count {
            if videos[i].peerID == peerID {
                
                onStateChange??(state: .Lost, video: videos[i])
                videos.removeAtIndex(i)
                break
            }
            }
        }
    }
    

}

