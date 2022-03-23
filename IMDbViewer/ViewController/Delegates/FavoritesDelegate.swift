//
//  FavoritesDelegate.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 24.03.2022.
//

import Foundation

protocol FavoritesDelegate {
    func onFavoritesListReceived(favoritesList: [String: MovieOrSerieListItemType])
}
