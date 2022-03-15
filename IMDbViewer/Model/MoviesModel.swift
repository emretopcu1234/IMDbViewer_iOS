//
//  MoviesModel.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 16.03.2022.
//

import Foundation

class MoviesModel {
    
    static let shared = MoviesModel()
    var previousSearch: String
    var resultList: [String: MovieOrSerieListType]
    
    private init() {
        previousSearch = ""
        resultList = [String: MovieOrSerieListType]()
    }
    
    func getInitialList() {
        if resultList.count != 2 {
            // TODO delegate aracılığıyla direkt resultlist donulecek.
            return
        }
        else if resultList.count != 3 {
            resultList.removeValue(forKey: "Results")
            // TODO once ilk eleman (search results icin olan) cıkarılacak, oyle resultlist donulecek
            return
        }
        
        let urlString = ModelConstants.BASE_URL + ModelConstants.MOST_POPULAR_MOVIES_EXT + ModelConstants.IMDB_API_KEY
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(MovieOrSerieListType.self, from: data)
                            resultList["Most Popular"] = decodedData
                            let urlString = ModelConstants.BASE_URL + ModelConstants.TOP_250_MOVIES_EXT + ModelConstants.IMDB_API_KEY
                            if let url = URL(string: urlString) {
                                let session = URLSession(configuration: .default)
                                let task = session.dataTask(with: url) { [self] data, response, error in
                                    if error == nil {
                                        if let data = data {
                                            let decoder = JSONDecoder()
                                            do {
                                                let decodedData = try decoder.decode(MovieOrSerieListType.self, from: data)
                                                resultList["Top 250"] = decodedData
                                            }
                                            catch {
                                                print("error")
                                            }
                                        }
                                    }
                                }
                                task.resume()
                            }
                        }
                        catch {
                            print("error")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getMovieList(search: String) {
        
    }
}
