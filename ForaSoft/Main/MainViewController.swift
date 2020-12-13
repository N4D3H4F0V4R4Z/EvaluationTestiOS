//
//  MainViewController.swift
//  ForaSoft
//
//  Created by Наджафов Араз on 13.12.2020.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startSearchButton: UIButton!
    @IBOutlet weak var searchBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var startSearchButtonConstraint: NSLayoutConstraint!
    
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        view.backgroundColor = .black
        
        activityIndicator.isHidden = true
        navigationItem.hidesSearchBarWhenScrolling = true
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Artists, Songs, Lyrics and More", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func startSearchButton(_ sender: Any) {
        startSearchButton.isHidden = true
        animationSearchBar()
    }
}

// MARK: - CollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell {
            cell.updateCell(album: albums[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
}

// MARK: - CollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        if let viewController = UIStoryboard(name: "Information", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as? InformationViewController {
            if let navigator = navigationController {
                viewController.album = album
                if let cell = collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell {
                    viewController.image = cell.albumImage.image
                }
                navigator.pushViewController(viewController, animated: true)
            }
        }
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - CollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 15, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
    }
}

// MARK: - SearchBar methods

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil || searchBar.text != "" {
            self.getAlbumsAction()
            DataService.shared.getAlbums(searchBar.text!) { (requestedAlbums) in
                self.albums = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
                DispatchQueue.main.async {
                    let resultCount = requestedAlbums.count
                    if resultCount == 0 {
                        let archiveMenu = UIAlertController(title: nil, message: "Not found", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        
                        archiveMenu.addAction(cancelAction)
                        
                        self.present(archiveMenu, animated: true, completion: nil)
                    }
                    self.getAlbumsActionStop()
                    self.collectionView.reloadData()
                }
            }
        } else if searchBar.text == nil || searchBar.text == "" {
            self.collectionView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func configure() {
        configureCollectionView()
        configureSearchBar()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundColor = .black
        searchBar.tintColor = .white
    }
    
    func getAlbumsAction() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func getAlbumsActionStop() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func animationSearchBar() {
        searchBarConstraint.constant = -1
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }
        )}
    
}
