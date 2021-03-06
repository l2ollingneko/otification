//
//  ActionsTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/17/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class FriendActionsTableViewCell: UITableViewCell, iCarouselDataSource, iCarouselDelegate{
    
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedImageView = UIImageView()
    
    var selectedActionIndex: Int = 0
    var isFriendAction: Bool = false
    
    var delegate: ActionsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundView = nil
        self.backgroundColor = UIColor.clearColor()
        
        self.carousel.dataSource = self
        self.carousel.delegate = self
        
        self.carousel.backgroundColor = UIColor.clearColor()
        self.carousel.type = .Linear
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initSelectedImageView() {
        let size = CGSizeMake(Otification.calculatedWidthFromRatio(269.0), Otification.calculatedHeightFromRatio(282.0))
        self.selectedImageView.frame = CGRectMake((Otification.rWidth - size.width) / 2.0, self.carousel.frame.origin.y, size.width, size.height)
        self.selectedImageView.image = UIImage(named: "selected_action")
        
        self.contentView.addSubview(self.selectedImageView)
        self.contentView.sendSubviewToBack(self.selectedImageView)
    }
    
    // MARK: - icarousel
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return Otification.friendAlarmActions.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var actionView: ActionView
        
        let action: Action = Otification.friendAlarmActions[index]
        
        if (view == nil) {
            // 269, 342
            let cellSize = CGSizeMake(Otification.calculatedWidthFromRatio(269.0), Otification.calculatedWidthFromRatio(342.0))
            actionView = ActionView(frame: CGRectMake(0.0, 0.0, cellSize.width, cellSize.height))
            actionView.backgroundColor = UIColor.clearColor()
        
            let size = CGSizeMake(Otification.calculatedWidthFromRatio(241.0), Otification.calculatedWidthFromRatio(241.0))
            actionView.actionImageView = UIImageView(frame: CGRectMake(Otification.calculatedWidthFromRatio(14.0), Otification.calculatedWidthFromRatio(14.0), size.width, size.height))
            actionView.actionImageView.backgroundColor = UIColor.clearColor()
            actionView.actionImageView.tag = 1
            
            let labelSize = CGRectMake(0.0, Otification.calculatedHeightFromRatio(283.0), Otification.calculatedWidthFromRatio(280.0), Otification.calculatedHeightFromRatio(70.0))
            actionView.actionLabel = THLabel()
            actionView.actionLabel.frame = labelSize
            actionView.actionLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_MEDIUM, size: Otification.calculatedHeightFromRatio(66.0))
            actionView.actionLabel.textAlignment = .Center
            actionView.actionLabel.backgroundColor = UIColor.clearColor()
            actionView.actionLabel.textColor = UIColor.blackColor()
            actionView.actionLabel.tag = 2
            
            actionView.addSubview(actionView.actionImageView)
            actionView.addSubview(actionView.actionLabel)
        } else {
            actionView = view as! ActionView
        }
        
        actionView.actionImageView.image = action.image
        actionView.actionImageView.tag = index + 10
        actionView.actionLabel.text = action.actionName
        actionView.actionLabel.tag = index + 1
        
        return actionView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 1.3
        }
        if (option == .Wrap) {
            return CGFloat(true)
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        // TODO: - show name
        self.selectedActionIndex = carousel.currentItemIndex
        
        let action: Action = Otification.friendAlarmActions[self.selectedActionIndex]
        
        self.delegate?.didSelectAction(action)
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        self.selectedImageView.alpha = 0.0
        UIView.animateWithDuration(0.2, animations: {
            self.selectedImageView.alpha = 0.0
            self.selectedImageView.alpha = 1.0
        })
        
        let label = carousel.contentView.viewWithTag(carousel.currentItemIndex + 1) as! THLabel
        dispatch_async(dispatch_get_main_queue(), {
            var frame = label.frame
            frame.origin.y = frame.origin.y
            label.frame = frame
            label.strokeColor = UIColor.whiteColor()
            label.strokeSize = 1.5
            label.setNeedsDisplay()
        })
        
        let imageView = carousel.contentView.viewWithTag(carousel.currentItemIndex + 10) as! UIImageView
        dispatch_async(dispatch_get_main_queue(), {
            imageView.image = Otification.friendAlarmActions[carousel.currentItemIndex].activeImage
            imageView.setNeedsDisplay()
        })
    }
    
    func carouselDidScroll(carousel: iCarousel) {
        UIView.animateWithDuration(0.05, animations: {
            if (self.selectedImageView.alpha == 1.0) {
                self.selectedImageView.alpha = 1.0
            }
            let imageView = carousel.contentView.viewWithTag(carousel.currentItemIndex + 10) as! UIImageView
            imageView.image = Otification.friendAlarmActions[carousel.currentItemIndex].image
            self.selectedImageView.alpha = 0.0
        })
        if let view = carousel.contentView.viewWithTag(carousel.currentItemIndex + 1) {
            let label = view as! THLabel
            var frame = label.frame
            frame.origin.y = Otification.calculatedHeightFromRatio(283.0)
            label.frame = frame
            label.strokeColor = UIColor.clearColor()
            label.setNeedsDisplay()
        }
    }
    
    func carouselDidEndDecelerating(carousel: iCarousel) {
    }
    
}
