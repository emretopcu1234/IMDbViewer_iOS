//
//  SpecificActorType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 22.03.2022.
//

import Foundation

struct SpecificActorType {
    var name: String
    var imageUrl: String
    var info: String
    var birthDate: String
    var deathDate: String
    var awards: String
    var knownFor: [MovieOrSerieListItemType]
    
    init() {
        name = ""
        imageUrl = ""
        info = ""
        birthDate = ""
        deathDate = ""
        awards = ""
        knownFor = [MovieOrSerieListItemType]()
    }
}
