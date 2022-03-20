//
//  SpecificMovieOrSerieType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 20.03.2022.
//

import Foundation

struct SpecificMovieOrSerieType {
    var title: String
    var releaseDate: String
    var plotInfo: String
    var genres: String
    var director: String
    var writer: String
    var durationOrSeasons: String
    var cast: [ActorListItemType]
    var trailerImageUrl: String
    var trailerVideoUrl: String
    var imdbRating: String
    var metacriticRating: String
    var themoviedbRating: String
    var rottentomatoesRating: String
    var similars: [MovieOrSerieListItemType]
    
    init() {
        title = ""
        releaseDate = ""
        plotInfo = ""
        genres = ""
        director = ""
        writer = ""
        durationOrSeasons = ""
        cast = [ActorListItemType]()
        trailerImageUrl = ""
        trailerVideoUrl = ""
        imdbRating = ""
        metacriticRating = ""
        themoviedbRating = ""
        rottentomatoesRating = ""
        similars = [MovieOrSerieListItemType]()
    }
}
