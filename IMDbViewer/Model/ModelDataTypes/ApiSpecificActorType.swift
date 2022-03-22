//
//  ApiSpecificActorType.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 23.03.2022.
//

import Foundation

struct ApiSpecificActorMainType: Codable {
    var name: String
    var image: String
    var summary: String
    var birthDate: String
    var deathDate: String?
    var awards: String
    var knownFor: [ApiKnownForType]
}

struct ApiKnownForType: Codable {
    var id: String
    var title: String
    var image: String
}
