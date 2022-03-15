//
//  MovieOrSerieListType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 16.03.2022.
//

import Foundation

struct MovieOrSerieListType: Codable {
    var items: [MovieOrSerieListItemType]
    
    init() {
        items = [MovieOrSerieListItemType]()
    }
}

struct MovieOrSerieListItemType: Codable {
    var id: String
    var title: String
    var image: String
}

