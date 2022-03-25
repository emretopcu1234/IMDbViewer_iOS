//
//  SpecificMovieOrSerieType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 20.03.2022.
//

import Foundation

struct SpecificMovieOrSerieType {
    var isFavorite: Bool
    var title: String
    var image: String
    var releaseDate: String
    var plotInfo: String
    var genres: String
    var director: String
    var writer: String
    var duration: String?
    var seasons: String?
    var cast: [ActorListItemType]
    var trailerImageUrl: String
    var trailerVideoUrl: String
    var imdbRating: String
    var metacriticRating: String
    var themoviedbRating: String
    var rottentomatoesRating: String
    var similars: [MovieOrSerieListItemType]
    
    init() {
        isFavorite = false
        title = ""
        image = ""
        releaseDate = ""
        plotInfo = ""
        genres = ""
        director = ""
        writer = ""
        cast = [ActorListItemType]()
        trailerImageUrl = ""
        trailerVideoUrl = ""
        imdbRating = ""
        metacriticRating = ""
        themoviedbRating = ""
        rottentomatoesRating = ""
        similars = [MovieOrSerieListItemType]()
    }
    
    mutating func setFavorite(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}
