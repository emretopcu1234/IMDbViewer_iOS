//
//  MoviesModel.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 16.03.2022.
//

import Foundation

class MoviesModel {
    
    static let shared = MoviesModel()
    var moviesDelegate: MoviesDelegate?
    var movieList: [String: [MovieOrSerieListItemType]]
    
    private init() {
        movieList = [String: [MovieOrSerieListItemType]]()
    }
    
    func getInitialList() {
        if movieList.count == 2 {
            moviesDelegate?.onMovieListReceived(movieList: movieList)
            return
        }
        else if movieList.count == 3 {
            movieList.removeValue(forKey: "Results")
            moviesDelegate?.onMovieListReceived(movieList: movieList)
            return
        }
        
        var mostPopularReceived = false
        var top250Received = false
        
        let urlString1 = ModelConstants.BASE_URL + ModelConstants.MOST_POPULAR_MOVIES_EXT + ModelConstants.IMDB_API_KEY
        if let url1 = URL(string: urlString1) {
            let session1 = URLSession(configuration: .default)
            let task1 = session1.dataTask(with: url1) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ApiMovieOrSerieListType.self, from: data)
                            var list = [MovieOrSerieListItemType]()
                            for item in decodedData.items {
                                list.append(MovieOrSerieListItemType(id: item.id, title: item.title, image: item.image))
                            }
                            movieList["Most Popular"] = list
                            mostPopularReceived = true
                            if top250Received {
                                moviesDelegate?.onMovieListReceived(movieList: movieList)
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
        
        let urlString2 = ModelConstants.BASE_URL + ModelConstants.TOP_250_MOVIES_EXT + ModelConstants.IMDB_API_KEY
        if let url2 = URL(string: urlString2) {
            let session2 = URLSession(configuration: .default)
            let task2 = session2.dataTask(with: url2) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ApiMovieOrSerieListType.self, from: data)
                            var list = [MovieOrSerieListItemType]()
                            for item in decodedData.items {
                                list.append(MovieOrSerieListItemType(id: item.id, title: item.title, image: item.image))
                            }
                            movieList["Top 250"] = list
                            top250Received = true
                            if mostPopularReceived {
                                moviesDelegate?.onMovieListReceived(movieList: movieList)
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
    
    func getMovieList(search: String) {
        movieList.removeValue(forKey: "Results")
        let urlString = ModelConstants.BASE_URL + ModelConstants.SEARCH_MOVIE_EXT + ModelConstants.IMDB_API_KEY + search
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ApiMovieOrSerieSearchListType.self, from: data)
                            var list = [MovieOrSerieListItemType]()
                            for item in decodedData.results {
                                list.append(MovieOrSerieListItemType(id: item.id, title: item.title, image: item.image))
                            }
                            movieList["Results"] = list
                            moviesDelegate?.onMovieListReceived(movieList: movieList)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
