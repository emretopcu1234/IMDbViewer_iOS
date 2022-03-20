//
//  SeriesDelegate.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 20.03.2022.
//

import Foundation

protocol SeriesDelegate {
    func onSerieListReceived(serieList: [String: [MovieOrSerieListItemType]])
}
