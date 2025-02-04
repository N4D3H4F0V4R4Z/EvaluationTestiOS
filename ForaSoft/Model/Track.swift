//
//  Track.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import Foundation

class Track: NSObject {
    
    var trackName: String? = nil
    var trackNumber: Int? = nil
    
    init(data: [String: AnyObject]?) {
        super.init()
        
        guard let data = data else { return }
        
        trackName = data["trackName"] as? String
        trackNumber = data["trackNumber"] as? Int
    }
}
