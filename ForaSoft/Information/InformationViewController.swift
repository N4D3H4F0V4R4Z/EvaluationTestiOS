//
//  InformationViewController.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album!
    var image: UIImage!
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .black
        self.title = album.artistName
        self.navigationController?.navigationBar.tintColor = .systemPink
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabels ()
        loadTracks()
    }
    
    func updateLabels() {
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        informationLabel.text = "\(album.primaryGenreName ?? "")⋅\(album.country ?? "")⋅\(album.releaseDate ?? "")"
        albumImage.image = image
    }
    
    func loadTracks() {
        DataService.shared.getAlbumTracks(collectionId: album.collectionId ?? 00) { (requestedTracks) in
            self.tracks = requestedTracks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView methods

extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InformationTableViewCell", for: indexPath) as? InformationTableViewCell {
            cell.updateCell(track: tracks[indexPath.row])
            cell.backgroundColor = .black
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: -
// MARK: - Configure

private extension InformationViewController {
    
    func configure() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
    }
    
}
