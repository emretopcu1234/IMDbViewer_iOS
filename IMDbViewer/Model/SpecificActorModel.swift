//
//  SpecificActorModel.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 22.03.2022.
//

import Foundation

class SpecificActorModel {
    
    static let shared = SpecificActorModel()
    var specificActorDelegate: SpecificActorDelegate?
    var specificActorHistory = [String: SpecificActorType]()
    
    private init() {
    }
    
    func getSpecificActor(id: String) {
        if let specificActor = specificActorHistory[id]{
            specificActorDelegate?.onSpecificActorReceived(specificActor: specificActor)
            return
        }
        
        var specificActor = SpecificActorType()
        
        let urlString = ModelConstants.BASE_URL + ModelConstants.SPECIFIC_ACTOR_EXT + ModelConstants.IMDB_API_KEY + id
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error == nil {
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(ApiSpecificActorMainType.self, from: data)
                            specificActor.name = decodedData.name
                            specificActor.imageUrl = decodedData.image
                            specificActor.info = decodedData.summary
                            specificActor.birthDate = decodedData.birthDate
                            specificActor.deathDate = decodedData.deathDate ?? "-"
                            specificActor.awards = decodedData.awards
                            var knownForList = [MovieOrSerieListItemType]()
                            for knownFor in decodedData.knownFor {
                                knownForList.append(MovieOrSerieListItemType(id: knownFor.id, title: knownFor.title, image: knownFor.image))
                            }
                            specificActor.knownFor = knownForList
                            specificActorHistory[id] = specificActor
                            specificActorDelegate?.onSpecificActorReceived(specificActor: specificActor)
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
