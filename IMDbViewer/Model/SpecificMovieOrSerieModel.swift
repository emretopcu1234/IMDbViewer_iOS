//
//  SpecificMovieOrSerieModel.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 20.03.2022.
//

import Foundation

class SpecificMovieOrSerieModel {
    
    static let shared = SpecificMovieOrSerieModel()
    let favoritesModel: FavoritesModel
    var specificMovieOrSerieDelegate: SpecificMovieOrSerieDelegate?
    var specificMovieOrSerieHistory = [String: SpecificMovieOrSerieType]()
    
    private init() {
        favoritesModel = FavoritesModel.shared
    }
    
    func getSpecificMovieOrSerie(id: String) {
        if let specificMovieOrSerie = specificMovieOrSerieHistory[id]{
            specificMovieOrSerieDelegate?.onSpecificMovieOrSerieReceived(specificMovieOrSerie: specificMovieOrSerie)
            return
        }
        
        var specificMovieOrSerie = SpecificMovieOrSerieType()
        var mainInfoReceived = false
        var videoUrlReceived = false
        
        let urlString1 = ModelConstants.BASE_URL + ModelConstants.SPECIFIC_MOVIE_OR_SERIE_MAIN_EXT1 + ModelConstants.IMDB_API_KEY + "\(id)/" + ModelConstants.SPECIFIC_MOVIE_OR_SERIE_MAIN_EXT2
        if let url1 = URL(string: urlString1) {
            let session1 = URLSession(configuration: .default)
            let task1 = session1.dataTask(with: url1) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ApiSpecificMovieOrSerieMainType.self, from: data)
                            specificMovieOrSerie.title = decodedData.title
                            specificMovieOrSerie.image = decodedData.image
                            specificMovieOrSerie.releaseDate = decodedData.releaseDate
                            specificMovieOrSerie.plotInfo = decodedData.plot
                            specificMovieOrSerie.genres = decodedData.genres
                            specificMovieOrSerie.director = decodedData.directors
                            specificMovieOrSerie.writer = decodedData.writers
                            if let duration = decodedData.runtimeMins {
                                specificMovieOrSerie.duration = duration
                                specificMovieOrSerie.seasons = nil
                            }
                            else if let seasons = decodedData.tvSeriesInfo?.seasons.count {
                                specificMovieOrSerie.seasons = String(seasons)
                                specificMovieOrSerie.duration = nil
                            }
                            var actorList = [ActorListItemType]()
                            for actorr in decodedData.actorList {
                                actorList.append(ActorListItemType(id: actorr.id, name: actorr.name, image: actorr.image))
                            }
                            specificMovieOrSerie.cast = actorList
                            specificMovieOrSerie.trailerImageUrl = decodedData.trailer.thumbnailUrl
                            specificMovieOrSerie.imdbRating = decodedData.ratings.imDb
                            specificMovieOrSerie.metacriticRating = decodedData.ratings.metacritic
                            specificMovieOrSerie.themoviedbRating = decodedData.ratings.theMovieDb
                            specificMovieOrSerie.rottentomatoesRating = decodedData.ratings.rottenTomatoes
                            var similarList = [MovieOrSerieListItemType]()
                            for similarMovieOrSerie in decodedData.similars {
                                similarList.append(MovieOrSerieListItemType(id: similarMovieOrSerie.id, title: similarMovieOrSerie.title, image: similarMovieOrSerie.image))
                            }
                            specificMovieOrSerie.similars = similarList
                            mainInfoReceived = true
                            if videoUrlReceived {
                                specificMovieOrSerieHistory[id] = specificMovieOrSerie
                                specificMovieOrSerieDelegate?.onSpecificMovieOrSerieReceived(specificMovieOrSerie: specificMovieOrSerie)
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            task1.resume()
        }
        
        let urlString2 = ModelConstants.BASE_URL + ModelConstants.SPECIFIC_MOVIE_OR_SERIE_VIDEO_EXT1 + ModelConstants.IMDB_API_KEY + id
        if let url2 = URL(string: urlString2) {
            let session2 = URLSession(configuration: .default)
            let task2 = session2.dataTask(with: url2) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ApiSpecificMovieOrSerieVideoType1.self, from: data)
                            let videoId = decodedData.videoId
                            let urlString3 = ModelConstants.BASE_URL + ModelConstants.SPECIFIC_MOVIE_OR_SERIE_VIDEO_EXT2 + ModelConstants.IMDB_API_KEY + videoId
                            if let url3 = URL(string: urlString3) {
                                let session3 = URLSession(configuration: .default)
                                let task3 = session3.dataTask(with: url3) { [self] data, response, error in
                                    if error == nil {
                                        if let data = data {
                                            let decoder = JSONDecoder()
                                            do {
                                                let decodedData = try decoder.decode(ApiSpecificMovieOrSerieVideoType2.self, from: data)
                                                if decodedData.videos.count > 0 {
                                                    specificMovieOrSerie.trailerVideoUrl = decodedData.videos[decodedData.videos.count - 1].url
                                                }
                                                videoUrlReceived = true
                                                if mainInfoReceived {
                                                    specificMovieOrSerieHistory[id] = specificMovieOrSerie
                                                    specificMovieOrSerieDelegate?.onSpecificMovieOrSerieReceived(specificMovieOrSerie: specificMovieOrSerie)
                                                }
                                            }
                                            catch {
                                                print(error)
                                            }
                                        }
                                    }
                                }
                                task3.resume()
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            task2.resume()
        }
    }
    
    func addToFavorites(id: String) {
        if let specificMovieOrSerie = specificMovieOrSerieHistory[id] {
            let item = MovieOrSerieListItemType(id: id, title: specificMovieOrSerie.title, image: specificMovieOrSerie.image)
            favoritesModel.addToFavorites(item: item)
        }
    }
    
    func removeFromFavorites(id: String) {
        favoritesModel.removeFromFavorites(id: id)
    }
}
