//
//  SpecificActorViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 12.03.2022.
//

import UIKit

class SpecificActorViewController: UIViewController {
    
    var id: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var deathdateLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    @IBOutlet weak var knownforLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tempData = [DetailedCollectionViewCellModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIView()
        
        titleLabel.sizeToFit()
        infoLabel.sizeToFit()
        birthdateLabel.sizeToFit()
        deathdateLabel.sizeToFit()
        awardsLabel.sizeToFit()
        knownforLabel.sizeToFit()
        knownforLabel.attributedText = NSMutableAttributedString(string: "Known For", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        
        // temporary start
        setTitle(title: "Something Very Nice Actor")
        setInfo(info: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        setBirthdate(birthdate: "1972-07-03")
        setDeathdate(deathdate: "-")
        setAwards(awards: "Won 1 Oscar. Another 9 wins & 146 nominations.")
        // temporary end
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 250)
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellNib = UINib(nibName: "DetailedCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "detailedCollectionViewCell")
        
        loadData()
        
    }
    
    private func setTitle(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30.0)])
        navigationItem.title = title
    }

    private func setInfo(info: String) {
        infoLabel.text = info
    }
    
    private func setBirthdate(birthdate: String) {
        let attributedBirthdateText = NSMutableAttributedString(string: "Birth Date: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: birthdate)
        attributedBirthdateText.append(text)
        birthdateLabel.attributedText = attributedBirthdateText
    }
    
    private func setDeathdate(deathdate: String) {
        let attributedDeathdateText = NSMutableAttributedString(string: "Death Date: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: deathdate)
        attributedDeathdateText.append(text)
        deathdateLabel.attributedText = attributedDeathdateText
    }
    
    private func setAwards(awards: String) {
        let attributedAwardsText = NSMutableAttributedString(string: "Awards: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        let text = NSMutableAttributedString(string: awards)
        attributedAwardsText.append(text)
        awardsLabel.attributedText = attributedAwardsText
    }

    func loadData() {
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Slvesterr Soetngngttttt"))
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMWU4N2FjNzYtNTVkNC00NzQ0LTg0MjAtYTJlMjFhNGUxZDFmXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX128_CR0,3,128,176_AL_.jpg", name: "12 Angry Men"))
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMWU4N2FjNzYtNTVkNC00NzQ0LTg0MjAtYTJlMjFhNGUxZDFmXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX128_CR0,3,128,176_AL_.jpg", name: "12 Angry Men"))
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "12 Angry Men"))
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "12 Angry Men"))
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Slvesterr Soetngngttttt"))
//        tempData.append(DetailedCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMWU4N2FjNzYtNTVkNC00NzQ0LTg0MjAtYTJlMjFhNGUxZDFmXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX128_CR0,3,128,176_AL_.jpg", name: "12 Angry Men"))
    }
}

extension SpecificActorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.spacingBetweenDetailedCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailedCollectionViewCell", for: indexPath) as? DetailedCollectionViewCell {
            let url = URL(string: tempData[indexPath.row].imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
            }
            cell.nameLabel.text = tempData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = tempData[indexPath.row].name
        print("You tapped the item \(name)")
        print("known for collection view tapped")
    }
}
