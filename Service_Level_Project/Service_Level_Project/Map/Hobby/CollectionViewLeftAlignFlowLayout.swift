//
//  CollectionViewLeftAlignFlowLayout.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    
    let cellSpacing: CGFloat = 10
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach {
            if $0.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            $0.frame.origin.x = leftMargin
            leftMargin += $0.frame.width + cellSpacing
            maxY = max($0.frame.maxY, maxY)
        }
        
        return attributes
    }
}
