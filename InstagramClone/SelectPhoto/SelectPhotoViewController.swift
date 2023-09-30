//
//  SelectPhotoViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 24.09.2023.
//

import UIKit
import Photos

class SelectPhotoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var headerCell: SelectedImageHeaderCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SelectedImageHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        setupNavBarController()
        fetchPhoto()
    }
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?

    private func fetchPhoto(){
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let targetSize = CGSize(width: 200, height: 200)
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let requestManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                requestManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: requestOptions) { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.images[indexPath.item]
        self.selectedImage = image
        collectionView.reloadData()
        
        let idxPath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: idxPath, at: .top, animated: true)
    }
    
    private func setupNavBarController(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(dismissCurrentViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Поделиться", style: .plain, target: self, action: #selector(handleToSharePage))
    }
    
    @objc private func dismissCurrentViewController(){
        dismiss(animated: true)
    }
    
    @objc private func handleToSharePage(){
        let shareViewController = SharePhotoViewController()
        shareViewController.selectedImage = headerCell?.selectImage.image
        navigationController?.pushViewController(shareViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    }
}

// MARK - cells for ViewController
extension SelectPhotoViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SelectPhotoCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK - header (suplementary view)
extension SelectPhotoViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SelectedImageHeaderCell
        
        self.headerCell = cell
        
        if let selectedImage = selectedImage {
            if let idxOfSelectedImage = self.images.firstIndex(of: selectedImage){
                let assetOfSelectedImage = self.assets[idxOfSelectedImage]
                let imgManager = PHImageManager.default()
                let targetSize = CGSize(width: 800, height: 800)
                let managerOptions = PHImageRequestOptions()
                managerOptions.isSynchronous = true
            
                imgManager.requestImage(for: assetOfSelectedImage, targetSize: targetSize, contentMode: .aspectFill, options: managerOptions) { image, info in
                    cell.selectImage.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = view.frame.width
        return CGSize(width: size, height: size)
    }
}
