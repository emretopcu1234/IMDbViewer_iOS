//
//  GeneralCollectionViewCell.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import UIKit

protocol GeneralCollectionViewCellDelegate: AnyObject {
    func collectionView(collectionViewCell: GeneralCollectionViewCell?, index: Int, didTapInTableViewCell: GeneralTableViewCell)
}

class GeneralCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
