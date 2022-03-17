//
//  MoviesViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var generalTableView: UITableView!
    
    let searchController = UISearchController()
    var shortMovieData = [GeneralTableViewCellModel]()
    var allMovieData = [GeneralTableViewCellModel]()
    var collectionCellHeight = 0
    
    let moviesModel = MoviesModel.shared
    
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
        
        moviesModel.moviesDelegate = self
        moviesModel.getInitialList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "DarkGray")
        searchController.searchBar.searchTextField.textColor = UIColor.lightGray
    }
}

extension MoviesViewController: MoviesDelegate {
    func onMovieListReceived(movieList: [String: [MovieOrSerieListItemType]]) {
        allMovieData.removeAll()
        shortMovieData.removeAll()
        if movieList["Results"] != nil {
            var resultList = [GeneralCollectionViewCellModel]()
            for movie in movieList["Results"]! {
                resultList.append(GeneralCollectionViewCellModel(imageUrl: movie.image, name: movie.title))
            }
            shortMovieData.append(GeneralTableViewCellModel(title: "Results", items: resultList))
        }
        var mostPopularList = [GeneralCollectionViewCellModel]()
        for movie in movieList["Most Popular"]! {
            mostPopularList.append(GeneralCollectionViewCellModel(imageUrl: movie.image, name: movie.title))
        }
        shortMovieData.append(GeneralTableViewCellModel(title: "Most Popular", items: Array(mostPopularList.prefix(ViewConstants.numberOfListItemsShown))))
        allMovieData.append(GeneralTableViewCellModel(title: "Most Popular", items: mostPopularList))
        var top250List = [GeneralCollectionViewCellModel]()
        for movie in movieList["Top 250"]! {
            top250List.append(GeneralCollectionViewCellModel(imageUrl: movie.image, name: movie.title))
        }
        shortMovieData.append(GeneralTableViewCellModel(title: "Top 250", items: Array(top250List.prefix(ViewConstants.numberOfListItemsShown))))
        allMovieData.append(GeneralTableViewCellModel(title: "Top 250", items: top250List))
        
        DispatchQueue.main.async {
            self.generalTableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.generalTableView.setContentOffset(.zero, animated: true)
        }
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        moviesModel.getMovieList(search: searchController.searchBar.searchTextField.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        moviesModel.getInitialList()
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shortMovieData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowNumber = Double(shortMovieData[indexPath.row].items.count) / Double(ViewConstants.numberOfItemsInRow)
        rowNumber = rowNumber.rounded(.up)
        return CGFloat(collectionCellHeight * Int(rowNumber) + 100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "generalTableViewCell") as? GeneralTableViewCell {
            cell.titleLabel.text = shortMovieData[indexPath.row].title
            if shortMovieData[indexPath.row].title == "Results" {
                cell.viewAllButton.isHidden = true
            }
            else {
                cell.viewAllButton.isHidden = false
            }
            cell.generalTableViewCellDelegate = self
            cell.generalCollectionViewCellDelegate = self
            let cellData = shortMovieData[indexPath.row].items
            cell.updateCellWith(data: cellData)
            cell.backgroundColor = UIColor.black
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.black
    }
}

extension MoviesViewController: GeneralTableViewCellDelegate {
    func viewAllButtonPressed(title: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "allInfoViewController") as? AllInfoViewController
        vc?.title = title
        for data in allMovieData {
            if data.title == title {
                vc?.data = data
                break
            }
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension MoviesViewController: GeneralCollectionViewCellDelegate {
    func collectionView(collectionViewCell: GeneralCollectionViewCell?, index: Int, didTapInTableViewCell: GeneralTableViewCell) {
        let title = didTapInTableViewCell.titleLabel.text!
        print("You tapped the cell \(index) in the row of colors \(title)")
        
    }
}
