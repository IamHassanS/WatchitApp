//
//  WishlistVIew.swift
//  Watchit
//
//  Created by HASSAN on 20/10/23.
//

import Foundation
import UIKit
import CoreData
enum Connectivity {
    case connected
    case notconnected
    case nowishList
}


class WishListVIew: BaseView {
    
    @IBOutlet weak var wishListsHolder: UIView!
    
    @IBOutlet weak var wishlistCollection: UICollectionView!
    @IBOutlet weak var fourthCircle: UIView!
    
    @IBOutlet weak var backHolderView: UIView!
    @IBOutlet weak var thirdCircle: UIView!
    @IBOutlet weak var contentsHolderView: UIView!
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var secondCircle: UIView!
    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var noConnectionView: UIView!
    
    @IBOutlet weak var noWishListview: UIView!
    var selectedID = Int()
    var detailVC: WishListVC!
    var pageType: Connectivity = .connected
    var movieArr : [Film]?
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.detailVC = baseVC as? WishListVC
        //  callApi()
//        CoreDataManager.shared.fetchMovies { films in
//            self.movieArr = films
//        }
        setupUI()
        cellRegistration()
       // initTaps()
      
    }
    
    override func willAppear(baseVC: BaseViewController) {
        CoreDataManager.shared.fetchMovies { films in
            self.movieArr = films
            wishlistCollection.delegate = self
            wishlistCollection.dataSource = self
            wishlistCollection.reloadData()
            if films.isEmpty {
                self.countLbl.text = "+"
                self.toSetPageType(.nowishList)
            } else {
                self.countLbl.text = "+\(films.count)"
                self.toSetPageType(.connected)
                
            }
            
        }
    }
    
    func toloadData() {
        CoreDataManager.shared.fetchMovies { films in
            self.movieArr = films
            wishlistCollection.reloadData()
            if films.isEmpty {
                self.countLbl.text = "+"
                self.toSetPageType(.nowishList)
            } else {
                self.countLbl.text = "+\(films.count)"
                self.toSetPageType(.connected)
                
            }
            
        }
       
    }
    
    
    
    func cellRegistration() {
        wishlistCollection.register(UINib(nibName: "WishlistsCVC", bundle: nil), forCellWithReuseIdentifier: "WishlistsCVC")
    }
    
    func toSetPageType(_ isconnected: Connectivity) {
        switch isconnected {
        case .connected:
            self.wishlistCollection.isHidden = false
            self.noConnectionView.isHidden = true
            self.noWishListview.isHidden = true
        case .notconnected:
            self.wishlistCollection.isHidden = true
            self.noConnectionView.isHidden = false
            self.noWishListview.isHidden = true
        case .nowishList:
            self.noWishListview.isHidden = false
            self.wishlistCollection.isHidden = true
            self.noConnectionView.isHidden = true
        }
        
    }
    
    
    func setupUI() {
        toSetPageType(.connected)
        contentsHolderView.setSpecificCornersForTop(cornerRadius: 12)
        wishListsHolder.setSpecificCorners()
        firstCircle.layer.cornerRadius = firstCircle.frame.size.height / 2
        secondCircle.layer.cornerRadius = secondCircle.frame.size.height / 2
        thirdCircle.layer.cornerRadius = thirdCircle.frame.size.height / 2
        fourthCircle.layer.cornerRadius = fourthCircle.frame.size.height / 2
        backHolderView.layer.cornerRadius = backHolderView.frame.size.height / 2
    }
}


extension WishListVIew : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WishlistsCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistsCVC", for: indexPath) as! WishlistsCVC
       
        cell.populatecell(self.movieArr?[indexPath.row] ?? Film())
        cell.optionsHolderView.addTap {
            let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 5), on: cell.optionsHolderView)
            vc.isFromWishlist = true
            vc.isExist = true
            vc.delegate = self
            self.selectedID = Int(self.movieArr?[indexPath.row].movieID ?? 0)
            self.detailVC.navigationController?.present(vc, animated: true)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 0.9, height: collectionView.frame.size.height / 2)
    }
}


extension WishListVIew : PopOverVCDelegate {
    func didTapRow(_ index: Int, _ isExist: Bool) {
        if index == 0 {
            CoreDataManager.shared.toRemoveMovie(self.selectedID) { didRemoved in
                if didRemoved {
                    self.toloadData()
                    self.detailVC.sceneDelegate?.createToastMessage("successfilly removed from watchlist ", isFromWishList: true)
                    
                } else {
                    self.detailVC.sceneDelegate?.createToastMessage("Failed to remove", isFromWishList: true)
                }
            }

        }
    }
    
    
}
