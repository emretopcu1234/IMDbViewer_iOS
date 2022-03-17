//
//  ApiMovieOrSerieListType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 17.03.2022.
//

import Foundation

struct ApiMovieOrSerieListType: Codable {
    var items: [ApiMovieOrSerieListItemType]
    
    init() {
        items = [ApiMovieOrSerieListItemType]()
    }
}

struct ApiMovieOrSerieListItemType: Codable {
    var id: String
    var title: String
    var image: String
}
