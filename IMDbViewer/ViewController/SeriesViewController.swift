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
    var shortSerieData = [GeneralTableViewCellModel]()
    var allSerieData = [GeneralTableViewCellModel]()
    var collectionCellHeight = 0
    
    let seriesModel = SeriesModel.shared
    
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
        
        seriesModel.seriesDelegate = self
        seriesModel.getInitialList()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "DarkGray")
        searchController.searchBar.searchTextField.textColor = UIColor.lightGray
    }
}

extension SeriesViewController: SeriesDelegate {
    func onSerieListReceived(serieList: [String: [MovieOrSerieListItemType]]) {
        allSerieData.removeAll()
        shortSerieData.removeAll()
        if serieList["Results"] != nil {
            var resultList = [GeneralCollectionViewCellModel]()
            for serie in serieList["Results"]! {
                resultList.append(GeneralCollectionViewCellModel(id: serie.id, imageUrl: serie.image, name: serie.title))
            }
            shortSerieData.append(GeneralTableViewCellModel(title: "Results", items: resultList))
        }
        var mostPopularList = [GeneralCollectionViewCellModel]()
        for serie in serieList["Most Popular"]! {
            mostPopularList.append(GeneralCollectionViewCellModel(id: serie.id, imageUrl: serie.image, name: serie.title))
        }
        shortSerieData.append(GeneralTableViewCellModel(title: "Most Popular", items: Array(mostPopularList.prefix(ViewConstants.numberOfListItemsShown))))
        allSerieData.append(GeneralTableViewCellModel(title: "Most Popular", items: mostPopularList))
        var top250List = [GeneralCollectionViewCellModel]()
        for serie in serieList["Top 250"]! {
            top250List.append(GeneralCollectionViewCellModel(id: serie.id, imageUrl: serie.image, name: serie.title))
        }
        shortSerieData.append(GeneralTableViewCellModel(title: "Top 250", items: Array(top250List.prefix(ViewConstants.numberOfListItemsShown))))
        allSerieData.append(GeneralTableViewCellModel(title: "Top 250", items: top250List))
        
        DispatchQueue.main.async {
            self.generalTableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.generalTableView.setContentOffset(.zero, animated: true)
        }
    }
}

extension SeriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        seriesModel.getSerieList(search: searchController.searchBar.searchTextField.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        seriesModel.getInitialList()
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shortSerieData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowNumber = Double(shortSerieData[indexPath.row].items.count) / Double(ViewConstants.numberOfItemsInRow)
        rowNumber = rowNumber.rounded(.up)
        return CGFloat(collectionCellHeight * Int(rowNumber) + 100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "generalTableViewCell") as? GeneralTableViewCell {
            cell.titleLabel.text = shortSerieData[indexPath.row].title
            if shortSerieData[indexPath.row].title == "Results" {
                cell.viewAllButton.isHidden = true
            }
            else {
                cell.viewAllButton.isHidden = false
            }
            cell.generalTableViewCellDelegate = self
            cell.generalCollectionViewCellDelegate = self
            let cellData = shortSerieData[indexPath.row].items
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

extension SeriesViewController: GeneralTableViewCellDelegate {
    func viewAllButtonPressed(title: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "allInfoViewController") as? AllInfoViewController
        vc?.title = title
        for data in allSerieData {
            if data.title == title {
                vc?.data = data
                break
            }
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension SeriesViewController: GeneralCollectionViewCellDelegate {
    func collectionView(collectionViewCell: GeneralCollectionViewCell?, index: Int, didTapInTableViewCell: GeneralTableViewCell) {
        let title = didTapInTableViewCell.titleLabel.text!
        for data in shortSerieData {
            if data.title == title {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "specificMovieOrSerieViewController") as? SpecificMovieOrSerieViewController
                vc?.id = data.items[index].id
                navigationController?.pushViewController(vc!, animated: true)
                break
            }
        }
    }
}
