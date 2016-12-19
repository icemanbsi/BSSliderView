//
//  BSSliderCollectionViewLayout.swift
//  Pods
//
//  Created by Bobby Stenly Irawan on 12/17/16.
//
//

import UIKit

class BSSliderCollectionViewLayout: UICollectionViewFlowLayout {

    var itemAttributes: NSMutableArray = NSMutableArray()
    var contentSize : CGSize = CGSize(width: 0, height: 0)
    var dataLength: Int = 0
    
    override func prepare() {
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        
//        self.contentSize = CGSize(width: CGFloat(self.dataLength) * self.collectionView!.frame.size.width, height: self.collectionView!.frame.size.height)
//        
//        var column : Int = 0    // Current column inside row
        
        var contentWidth : CGFloat = 0.0         // Used to determine the contentSize
        var contentHeight : CGFloat = 0.0        // Used to determine the contentSize
        // Loop through all items and calculate the UICollectionViewLayoutAttributes for each one
        let numberOfItems : Int = self.collectionView!.numberOfItems(inSection: 0)
        self.dataLength = numberOfItems
        //        NSLog("number of items : %i", numberOfItems)
        for index:Int in 0 ..< numberOfItems
        {
            let itemSize: CGSize = CGSize(
                width: self.collectionView!.frame.size.width,
                height: floor(self.collectionView!.frame.size.height))
            
            if itemSize.height > contentHeight {
                contentHeight = itemSize.height
            }
            
            // Create the actual UICollectionViewLayoutAttributes and add it to your array. We'll use this later in layoutAttributesForItemAtIndexPath:
            let indexPath: IndexPath = IndexPath(item: index, section: 0)
            //            NSLog("Index : %i", index)
            let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: contentWidth, y: 0, width: itemSize.width, height: itemSize.height).integral
            self.itemAttributes.add(attributes)
            
            contentWidth = contentWidth + itemSize.width
        }
        
        if self.itemAttributes.count > 0 {
            // Get the last item to calculate the total height of the content
            //            NSLog("item attributes count : %i", self.itemAttributes.count)
            let attributes: UICollectionViewLayoutAttributes = self.itemAttributes.lastObject as! UICollectionViewLayoutAttributes
            contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
        }
        
        if contentWidth == 0 {
            contentWidth = self.collectionView!.frame.size.width;
        }
        
        // Return this in collectionViewContentSize
        self.contentSize = CGSize(width: contentWidth, height: contentHeight);
    }
    
    override var collectionViewContentSize : CGSize
    {
        return self.contentSize
    }
    
    override func layoutAttributesForItem(at indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        if (indexPath as NSIndexPath).row < self.itemAttributes.count {
            return self.itemAttributes.object(at: (indexPath as NSIndexPath).row) as! UICollectionViewLayoutAttributes
        }
        else {
            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.itemAttributes.filtered(using: NSPredicate(block: { (evaluatedObject, _: [String : Any]?) -> Bool in
            return rect.intersects((evaluatedObject as! UICollectionViewLayoutAttributes).frame)
        })) as? [UICollectionViewLayoutAttributes]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }

}
