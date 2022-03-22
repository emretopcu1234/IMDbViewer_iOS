//
//  SpecificActorViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 12.03.2022.
//

import UIKit

class SpecificActorViewController: UIViewController {
    
    var id: String = ""

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var deathdateLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    @IBOutlet weak var knownforLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewData = [DetailedCollectionViewCellModel]()
    
    let specificActorModel = SpecificActorModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIView()
        
        nameLabel.sizeToFit()
        infoLabel.sizeToFit()
        birthdateLabel.sizeToFit()
        deathdateLabel.sizeToFit()
        awardsLabel.sizeToFit()
        knownforLabel.sizeToFit()
        knownforLabel.attributedText = NSMutableAttributedString(string: "Known For", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22.0)])
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 250)
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellNib = UINib(nibName: "DetailedCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "detailedCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        specificActorModel.specificActorDelegate = self
        specificActorModel.getSpecificActor(id: id)
    }
    
    private func setName(name: String) {
        nameLabel.attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30.0)])
        navigationItem.title = name
    }
    
    private func setImageUrl(imageUrl: String) {
        let url = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
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
    
    private func setKnownFor(knownFor: [MovieOrSerieListItemType]) {
        var data = [DetailedCollectionViewCellModel]()
        for knownFor in knownFor {
            data.append(DetailedCollectionViewCellModel(id: knownFor.id, imageUrl: knownFor.image, name: knownFor.title))
        }
        collectionViewData = data
        collectionView.reloadData()
    }
    
    fileprivate func navigateToSpecificMovieOrSerie(id: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "specificMovieOrSerieViewController") as? SpecificMovieOrSerieViewController
        vc?.id = id
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension SpecificActorViewController: SpecificActorDelegate {
    func onSpecificActorReceived(specificActor: SpecificActorType) {
        DispatchQueue.main.async { [self] in
            setName(name: specificActor.name)
            setImageUrl(imageUrl: specificActor.imageUrl)
            setInfo(info: specificActor.info)
            setBirthdate(birthdate: specificActor.birthDate)
            setDeathdate(deathdate: specificActor.deathDate)
            setAwards(awards: specificActor.awards)
            setKnownFor(knownFor: specificActor.knownFor)
        }
    }
}

extension SpecificActorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.spacingBetweenDetailedCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailedCollectionViewCell", for: indexPath) as? DetailedCollectionViewCell {
            let url = URL(string: collectionViewData[indexPath.row].imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data!)
                }
            }
            cell.nameLabel.text = collectionViewData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToSpecificMovieOrSerie(id: collectionViewData[indexPath.row].id)
    }
}
