//
//  ApiMovieOrSerieSearchListType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 17.03.2022.
//

import Foundation

struct ApiMovieOrSerieSearchListType: Codable {
    var results: [ApiMovieOrSerieSearchListItemType]
    
    init() {
        results = [ApiMovieOrSerieSearchListItemType]()
    }
}

struct ApiMovieOrSerieSearchListItemType: Codable {
    var id: String
    var title: String
    var image: String
}
