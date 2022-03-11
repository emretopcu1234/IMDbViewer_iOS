//
//  GeneralTableViewCell.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var generalCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton: UIButton!
    
    weak var generalCollectionViewCellDelegate: GeneralCollectionViewCellDelegate?
    var tempData = [GeneralCollectionViewCellModel]()
    var cellWidth = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellWidth = (Int(UIScreen.main.bounds.width) - Int(ViewConstants.spacingBetweenGeneralCells) * (ViewConstants.numberOfItemsInRow + 1)) / ViewConstants.numberOfItemsInRow
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 100)
        generalCollectionView.collectionViewLayout = flowLayout
        generalCollectionView.isScrollEnabled = false
        generalCollectionView.dataSource = self
        generalCollectionView.delegate = self
        let cellNib = UINib(nibName: "GeneralCollectionViewCell", bundle: nil)
        generalCollectionView.register(cellNib, forCellWithReuseIdentifier: "generalCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

extension GeneralTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func updateCellWith(row: [GeneralCollectionViewCellModel]) {
        tempData = row
        generalCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.spacingBetweenGeneralCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalCollectionViewCell", for: indexPath) as? GeneralCollectionViewCell {
            let url = URL(string: tempData[indexPath.row].imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
            }
            cell.imageView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth)
            cell.nameLabel.text = tempData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GeneralCollectionViewCell
        generalCollectionViewCellDelegate?.collectionView(collectionViewCell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ViewConstants.spacingBetweenGeneralCells, bottom: 0, right: ViewConstants.spacingBetweenGeneralCells)
    }
}
