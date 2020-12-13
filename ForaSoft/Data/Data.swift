//
//  Data.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import Foundation
import UIKit

let baseURL = "https://itunes.apple.com/search?term={search_query}&limit=25"
let songURL = "https://itunes.apple.com/lookup?entity=song&id="

class DataService {
    
    static let shared = DataService()
    
    func getRequest(path: String?, closure: ((Data?)->())?) {
        
        guard let path = path, let url = URL(string: path) else {
            closure?(nil)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            closure?(data)
        }.resume()
    }
    
    func getAlbums(_ searchRequest: String, complition: @escaping ([Album])->()) {
        let searchString = searchRequest.replacingOccurrences(of: " ", with: "+")
        let urlString = baseURL.replacingOccurrences(of: "{search_query}", with: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        getRequest(path: urlString) { data in
            let results = data?.decoded(Result.self)?.results ?? []
            complition(results)
        }
    }
    
    func getAlbumTracks(collectionId: Int, complition: @escaping ([Track]) -> ()) {
        
        var tracks = [Track]()
        let path = "\(songURL)\(collectionId)"
        
        getRequest(path: path) { (data) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let trackResults = json["results"] as? NSArray {
                        for song in trackResults {
                            if trackResults.index(of: song) != 0 {
                                if let songInfo = song as? [String: AnyObject] {
                                    let track = Track(data: songInfo)
                                    tracks.append(track)
                                }
                            }
                        }
                        complition(tracks)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
