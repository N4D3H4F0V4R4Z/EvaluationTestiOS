//
//  MainCollectionViewCell.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import UIKit
import SDWebImage

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumArtistLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImage.image = nil
        albumNameLabel.text = nil
        albumArtistLabel.text = nil
    }
    
    func updateCell(album: Album) {
        
        if let imageUrl = URL(string: album.artworkUrl100 ?? "") {
            albumImage.sd_setImage(with: imageUrl, completed: nil)
        }
        
        albumNameLabel.text = album.collectionName
        albumArtistLabel.text = album.artistName
    }
    
}
