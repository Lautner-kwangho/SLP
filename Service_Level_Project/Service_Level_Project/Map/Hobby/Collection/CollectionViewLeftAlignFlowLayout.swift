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
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = 5.0
        var maxY: CGFloat = -1.0
        
        attributes?.forEach {
            guard $0.representedElementCategory == .cell else { return }
            
            if $0.frame.origin.y >= maxY {
                leftMargin = 5.0
            }
            $0.frame.origin.x = leftMargin
            leftMargin += $0.frame.width + cellSpacing
            maxY = max($0.frame.maxY, maxY)
        }
        
        return attributes
    }
}
