//
//  ViewDataTypes.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 5.03.2022.
//

import Foundation

struct GeneralTableViewCellModel {
    var title: String
    var items: [GeneralCollectionViewCellModel]
}

struct GeneralCollectionViewCellModel {
    var imageUrl: String
    var name: String
}

struct DetailedCollectionViewCellModel {
    var imageUrl: String
    var name: String
}

