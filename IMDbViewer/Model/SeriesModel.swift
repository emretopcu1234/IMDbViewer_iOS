//
//  SeriesModel.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 16.03.2022.
//

import Foundation

class SeriesModel {
    
    static let shared = SeriesModel()
    var seriesDelegate: SeriesDelegate?
    var serieList: [String: [MovieOrSerieListItemType]]
    
    private init() {
        serieList = [String: [MovieOrSerieListItemType]]()
    }
    
    func getInitialList() {
        if serieList.count == 2 {
            seriesDelegate?.onSerieListReceived(serieList: serieList)
            return
        }
        else if serieList.count == 3 {
            serieList.removeValue(forKey: "Results")
            seriesDelegate?.onSerieListReceived(serieList: serieList)
            return
        }
        
        var mostPopularReceived = false
        var top250Received = false
        
        let urlString1 = ModelConstants.BASE_URL + ModelConstants.MOST_POPULAR_SERIES_EXT + ModelConstants.IMDB_API_KEY
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
                            serieList["Most Popular"] = list
                            mostPopularReceived = true
                            if top250Received {
                                seriesDelegate?.onSerieListReceived(serieList: serieList)
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
        
        let urlString2 = ModelConstants.BASE_URL + ModelConstants.TOP_250_SERIES_EXT + ModelConstants.IMDB_API_KEY
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
                            serieList["Top 250"] = list
                            top250Received = true
                            if mostPopularReceived {
                                seriesDelegate?.onSerieListReceived(serieList: serieList)
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
    
    func getSerieList(search: String) {
        serieList.removeValue(forKey: "Results")
        let urlString = ModelConstants.BASE_URL + ModelConstants.SEARCH_SERIE_EXT + ModelConstants.IMDB_API_KEY + search
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
                            serieList["Results"] = list
                            seriesDelegate?.onSerieListReceived(serieList: serieList)
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
