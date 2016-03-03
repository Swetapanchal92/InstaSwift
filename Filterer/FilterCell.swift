//
//  FilterCell.swift
//  Filterer
//
//  Created by alberto pasca on 09/02/16.
//  Copyright © 2015 Coursera. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

