//
//  ApiSpecificMovieOrSerieType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 20.03.2022.
//

import Foundation

struct ApiSpecificMovieOrSerieMainType: Codable {
    var title: String
    var image: String
    var releaseDate: String
    var runtimeMins: String?
    var plot: String
    var directors: String
    var writers: String
    var actorList: [ApiActorType]
    var genres: String
    var ratings: ApiRatingsType
    var trailer: ApiTrailerType
    var similars: [ApiMovieOrSerieListItemType]
    var tvSeriesInfo: ApiTvSeriesInfoType?
}

struct ApiActorType: Codable {
    var id: String
    var image: String
    var name: String
}

struct ApiRatingsType: Codable {
    var imDb: String
    var metacritic: String
    var theMovieDb: String
    var rottenTomatoes: String
}

struct ApiTrailerType: Codable {
    var thumbnailUrl: String
}

struct ApiTvSeriesInfoType: Codable {
    var seasons: [String]
}

struct ApiSpecificMovieOrSerieVideoType1: Codable {
    var videoId: String
}

struct ApiSpecificMovieOrSerieVideoType2: Codable {
    var videos: [ApiSpecificMovieOrSerieVideoListItemType]
}

struct ApiSpecificMovieOrSerieVideoListItemType: Codable {
    var url: String
}
