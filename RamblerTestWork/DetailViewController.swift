//
//  File.swift
//  RamblerTestWork
//
//  Created by Влад Калаев on 27/06/2019.
//  Copyright © 2019 Влад Калаев. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    
    var detailComment: Comment!
    var detailContent = [Comment]()
    var index = 0

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var textTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        index = detailContent.index(where: { $0.title == detailComment.title })!
        
        uiUpdate()

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
    }
    
     // MARK: UI update
    
    func uiUpdate() {
        
        textTitle.text = detailComment.title
        
        img.sd_setImage(with: URL(string: detailComment.img ), placeholderImage: #imageLiteral(resourceName: "noimage"),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
        })
        
    }
    
    // MARK: Helpers
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        index = index + 1
        
        if index >= detailContent.count {
            index = 0
        }
        
        detailComment = detailContent[index]
        
        uiUpdate()
    }
  
}

