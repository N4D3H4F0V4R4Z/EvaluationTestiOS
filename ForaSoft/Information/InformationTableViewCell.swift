//
//  InformationTableViewCell.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    // - UI
    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var trackName: UILabel!
    
    func updateCell(track: Track) {
        trackNumber.text = String(track.trackNumber ?? 00)
        trackName.text = track.trackName
    }

}
