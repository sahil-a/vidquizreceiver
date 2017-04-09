//
//  VideoCell.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override func drawRect(rect: CGRect) {
        // add the shadow to the base view
        // add the shadow to the base view
        self.backgroundColor = UIColor.clearColor()
        layer.backgroundColor = UIColor.clearColor().CGColor
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.36
        self.layer.shadowRadius = 3.0
        self.clipsToBounds = false
        
        // add the border to subview
        let borderView = UIView()
        borderView.frame = self.bounds
        borderView.layer.cornerRadius = 5
        borderView.layer.masksToBounds = true
        self.addSubview(borderView)

    }
    
    func addPeers(peers: [Peer]) {
        
        for i in 0..<peers.count {
            let peerView = PeerView(frame: CGRectMake(20 + CGFloat(37 * i), title.frame.origin.y + 27, 30, 30), peer: peers[i])
            addSubview(peerView)
        }
    }
}
