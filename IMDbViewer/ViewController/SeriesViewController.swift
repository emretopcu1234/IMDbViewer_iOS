//
//  SeriesViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import UIKit

class SeriesViewController: UIViewController {

    @IBOutlet weak var generalTableView: UITableView!
    
    let searchController = UISearchController()
    var tempData = [GeneralTableViewCellModel]()
    var collectionCellHeight = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.darkGray
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.hidesBarsOnSwipe = false
        
        generalTableView.dataSource = self
        generalTableView.delegate = self
        let cellNib = UINib(nibName: "GeneralTableViewCell", bundle: nil)
        generalTableView.register(cellNib, forCellReuseIdentifier: "generalTableViewCell")
        generalTableView.backgroundColor = UIColor.black
        generalTableView.separatorColor = UIColor.lightGray
        
        collectionCellHeight = (Int(UIScreen.main.bounds.width) - Int(ViewConstants.spacingBetweenGeneralCells) * (ViewConstants.numberOfItemsInRow + 1)) / ViewConstants.numberOfItemsInRow + 125
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "DarkGray")
        searchController.searchBar.searchTextField.textColor = UIColor.lightGray
    }
    
    func loadData(){    // temporary
        var collection = [GeneralCollectionViewCellModel]()
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMWU4N2FjNzYtNTVkNC00NzQ0LTg0MjAtYTJlMjFhNGUxZDFmXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX128_CR0,3,128,176_AL_.jpg", name: "Once upon a time in hollywood"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMWU4N2FjNzYtNTVkNC00NzQ0LTg0MjAtYTJlMjFhNGUxZDFmXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX128_CR0,3,128,176_AL_.jpg", name: "Inception3"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception4"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception5"))
        tempData.append(GeneralTableViewCellModel(title: "Results", items: collection))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "12 Angry Men"))
        tempData.append(GeneralTableViewCellModel(title: "Top 100", items: collection))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception5"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception5"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception5"))
        collection.append(GeneralCollectionViewCellModel(imageUrl: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6791_AL_.jpg", name: "Inception5"))
        tempData.append(GeneralTableViewCellModel(title: "Top 50", items: collection))
    }
}

extension SeriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO arama sonucları ekrana yansıtılacak
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // TODO eger daha onceden yapılmıs arama varsa, sonucları ekrandan silinecek.
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowNumber = Double(tempData[indexPath.row].items.count) / Double(ViewConstants.numberOfItemsInRow)
        rowNumber = rowNumber.rounded(.up)
        return CGFloat(collectionCellHeight * Int(rowNumber) + 100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "generalTableViewCell") as? GeneralTableViewCell {
            cell.titleLabel.text = tempData[indexPath.row].title
            if tempData[indexPath.row].title == "Results" {
                cell.viewAllButton.isHidden = true
            }
            else {
                cell.viewAllButton.isHidden = false
            }
            cell.generalCollectionViewCellDelegate = self
            let rowArray = tempData[indexPath.row].items
            cell.updateCellWith(row: rowArray)
            cell.backgroundColor = UIColor.black
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.black
    }
}

extension SeriesViewController: GeneralCollectionViewCellDelegate {
    func collectionView(collectionViewCell: GeneralCollectionViewCell?, index: Int, didTapInTableViewCell: GeneralTableViewCell) {
        let title = didTapInTableViewCell.titleLabel.text!
        print("You tapped the cell \(index) in the row of colors \(title)")
    }
}
