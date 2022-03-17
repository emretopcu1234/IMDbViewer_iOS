//
//  MoviesDelegate.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 17.03.2022.
//

import Foundation

protocol MoviesDelegate {
    func onMovieListReceived(movieList: [String: [MovieOrSerieListItemType]])
}
