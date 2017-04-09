//
//  ViewController.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 4/21/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let multipeerClient = MultipeerClient()
    private var videos: [Video] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeerClient.onStateChange = stateChangeForVideo
    }

    func stateChangeForVideo(state: State, video: Video) {
        if state == .Found {
            videos.append(video)
            collectionView.reloadData()
        } else {
            for i in 0..<videos.count {
                if i < videos.count {
                if videos[i].peerID == video.peerID {
                    videos.removeAtIndex(i)
                    collectionView.reloadData()
                    break
                }
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VideoCell
        let video = videos[indexPath.row]
        cell.title.text = video.name
        cell.addPeers(videos[indexPath.row].peers)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 16, bottom: 25, right: 16)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width - 32, 108)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let video = videos[indexPath.row]
        SessionHandler.defaultSessionHandler = SessionHandler(server: video.peerID, client: multipeerClient)
        performSegueWithIdentifier("details", sender: self)
    }
}

class WhiteTextNavBar: UINavigationBar {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSizeMake(0, 2.3)
        self.layer.masksToBounds = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSizeMake(0, 2.3)
        self.layer.masksToBounds = false
    }
}
