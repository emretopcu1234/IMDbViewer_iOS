//
//  SeriesViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import UIKit

class SeriesViewController: UIViewController {

    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.darkGray
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationController?.hidesBarsOnSwipe = false
    }

    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "DarkGray")
        searchController.searchBar.searchTextField.textColor = UIColor.lightGray
    }
}

extension SeriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO arama sonucları ekrana yansıtılacak
        performSegue(withIdentifier: "tempSegueId2", sender: self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // TODO eger daha onceden yapılmıs arama varsa, sonucları ekrandan silinecek.
    }
}
