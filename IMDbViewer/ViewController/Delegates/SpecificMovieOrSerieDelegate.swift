//
//  SpecificMovieOrSerieDelegate.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 20.03.2022.
//

import Foundation

protocol SpecificMovieOrSerieDelegate {
    func onSpecificMovieOrSerieReceived(specificMovieOrSerie: SpecificMovieOrSerieType)
}
