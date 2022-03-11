//
//  FavoritesViewController.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var count = 0
    
    
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
    
    @IBAction func clicked(_ sender: UIButton) {
        count += 1
        label.text = "Text \(count)"
    }
}

extension FavoritesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO arama sonucları ekrana yansıtılacak
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // TODO eger daha onceden yapılmıs arama varsa, sonucları ekrandan silinecek.
    }
}
