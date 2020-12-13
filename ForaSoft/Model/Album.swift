//
//  Album.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import Foundation

struct Album: Codable {
    
    let trackCount: Int
    let artistName: String
    let artworkUrl100: String
    let collectionId: Int
    let collectionName: String
    let country: String
    let primaryGenreName: String
    let releaseDate: String
    
}
