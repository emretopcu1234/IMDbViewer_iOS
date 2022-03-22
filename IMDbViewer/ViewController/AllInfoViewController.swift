//
//  AllInfoViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 14.03.2022.
//

import UIKit

class AllInfoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController()
    var cellWidth = 0
    var data: GeneralTableViewCellModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIView()
        navigationController?.hidesBarsOnSwipe = false
        
        cellWidth = (Int(UIScreen.main.bounds.width) - Int(ViewConstants.spacingBetweenGeneralCells) * (ViewConstants.numberOfItemsInRow + 1)) / ViewConstants.numberOfItemsInRow
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 100)
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellNib = UINib(nibName: "GeneralCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "generalCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = data?.title
    }
    
    fileprivate func navigateToSpecificMovieOrSerie(id: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "specificMovieOrSerieViewController") as? SpecificMovieOrSerieViewController
        vc?.id = id
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension AllInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.items.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.spacingBetweenGeneralCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalCollectionViewCell", for: indexPath) as? GeneralCollectionViewCell {
            let url = URL(string: data?.items[indexPath.row].imageUrl ?? "")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
            }
            cell.imageView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth)
            cell.nameLabel.text = data?.items[indexPath.row].name ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionView", for: indexPath) as! HeaderCollectionView
            header.headerLabel.text = data?.title
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ViewConstants.spacingBetweenGeneralCells, bottom: ViewConstants.spacingBetweenGeneralCells, right: ViewConstants.spacingBetweenGeneralCells)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToSpecificMovieOrSerie(id: data?.items[indexPath.row].id ?? "")
    }
}
