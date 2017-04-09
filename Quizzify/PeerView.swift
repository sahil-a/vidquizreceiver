//
//  PeerView.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit

class PeerView: UIView {

    init(frame: CGRect, peer: Peer) {
        super.init(frame: frame)
        self.backgroundColor = peer.color
        let label = UILabel(frame: self.bounds)
        label.text = peer.letter
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightBold)
        label.textAlignment = .Center
        
        self.addSubview(label)
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
