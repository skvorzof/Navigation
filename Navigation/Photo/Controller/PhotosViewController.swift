//
//  PhotosViewController.swift
//  Navigation
//
//  Created by mitr on 25.03.2022.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    private var photos = [UIImage]()
    private var userPhotos = Photo().fetchPhotos()
    private var imageProcessor = ImageProcessor()
    private var imagePublisherFacade: ImagePublisherFacade?
    private let offset: CGFloat = 8
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePublisherFacade = ImagePublisherFacade()
        imagePublisherFacade?.addImagesWithTimer(time: 0, repeat: 20, userImages: userPhotos)
        title = "Галерея"
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        imagePublisherFacade?.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imagePublisherFacade?.removeSubscription(for: self)
        imagePublisherFacade?.rechargeImageLibrary()
    }
    
    
    
    private func layout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}



extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoCell.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
}

/*
 userInitiated   =  3.1948089599609375e-05
 userInteractive =  3.2067298889160156e-05
 default         =  3.3020973205566406e-05
 utility         =  3.3020973205566406e-05
 background      =  7.390975952148438e-05
 */
extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        photos = images
        imageProcessor.processImagesOnThread(
            sourceImages: photos,
            filter: .noir,
            qos: .default) { sgImage in
            let startTime = Date()
            self.photos = sgImage.map({UIImage(cgImage: $0!)})
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            print( Date().timeIntervalSince(startTime) )
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - offset * 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        offset
    }
}
