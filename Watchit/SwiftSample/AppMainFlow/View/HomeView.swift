//
//  HomeView.swift
//  Watchit
//
//  Created by HASSAN on 20/10/23.
//

import Foundation
import UIKit
import SDWebImage




class HomeView: BaseView {
    enum contentType {
        case movies
        case tvShows
    }
    
    
    
    @IBOutlet weak var tableHolderView: UIView!
    
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var contentHolderView: UIView!
    
    @IBOutlet weak var topCollection: UICollectionView!
    
    @IBOutlet weak var collectionHolderView: UIView!
    
    @IBOutlet weak var contenTsScroll: UIScrollView!
    
    @IBOutlet weak var noConnectionVIew: UIView!
    var isLoadingMorePages = false
    @IBOutlet weak var tvShowsLbl: UILabel!
    
    @IBOutlet weak var moviesLbl: UILabel!
    
    @IBOutlet weak var tvShowsDot: UILabel!
    @IBOutlet weak var moviesDot: UILabel!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userThumbIV: UIImageView!
    
    @IBOutlet weak var exploreLbl: UILabel!
    @IBOutlet weak var seeallStack: UIStackView!
    
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var homeVC: HomeVC?
    var contentType: contentType = .movies
    var allList = Alllist()
    var generes = [Genre]()
    var isloading = false
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.homeVC = baseVC as? HomeVC
    
    }
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.homeVC = baseVC as? HomeVC
      //  self.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)


        setupUI()
        cellRegistration()
     
    }
    
    @objc func networkModified(_ notification: NSNotification) {
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
               if let status = dict["Type"] as? String{
                   DispatchQueue.main.async {
                       if status == "No Connection" {
                           self.toSetPageType(.notconnected)
                       } else if !self.isloading{
                           
                           self.toSetPageType(.connected)
                       }

                   }
               }
           }
    }
    
    func cellRegistration() {
        self.homeTableView.register(UINib(nibName: "HomeSectionTVC", bundle: nil), forCellReuseIdentifier: "HomeSectionTVC")
        topCollection.register(UINib(nibName: "WishlistCVC", bundle: nil), forCellWithReuseIdentifier: "WishlistCVC")
    }
    
    func toLoadData() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.reloadData()
    }
    
   func toLoadCollectionData() {
       topCollection.delegate = self
       topCollection.dataSource = self
       topCollection.reloadData()
    }
    
    func toSetPageType(_ isconnected: Connectivity) {
        switch isconnected {
        case .connected:
            self.contenTsScroll.isHidden = false
            self.noConnectionVIew.isHidden = true
            toSetContentType(.movies)
        case .notconnected:
            self.contenTsScroll.isHidden = true
            self.noConnectionVIew.isHidden = false
        case .nowishList:
            break
        }
        
    }
    
    
    func toSetContentType(_ contentType: contentType) {
        switch contentType {

        case .movies:
            self.contentType = .movies
            self.moviesLbl.alpha = 1
            self.tvShowsLbl.alpha = 0.5
            moviesDot.isHidden = false
            tvShowsDot.isHidden = true
            self.homeVC?.toFetchData(page: 1, listType: .movies)
        case .tvShows:
            self.contentType = .tvShows
            self.moviesLbl.alpha = 0.5
            self.tvShowsLbl.alpha = 1
            moviesDot.isHidden = true
            tvShowsDot.isHidden = false
            self.homeVC?.toFetchData(page: 1, listType: .tvshows)
        }
        
    }
    
    func setupUI() {
      //  self.homeVC.navigationController?.navigationBar.tintColor = UIColor.white
        tvShowsLbl.addTap {
            if self.contentType != .tvShows {
                self.toSetContentType(.tvShows)
            }
        }

        moviesLbl.addTap {
            if self.contentType != .movies {
                self.toSetContentType(.movies)
            }

        }
        
        seeallStack.addTap {
            let vc = DetailsVC.initWithStory()
            vc.isSingleSelection = false
            vc.homeListDictArray = self.allList.all.results
            vc.hidesBottomBarWhenPushed = true
            self.homeVC?.navigationController?.pushViewController(vc, animated: true)
        }
        
//        userThumbIV.addTap {
//            print("Tapped -->")
//            let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 5), on: self.userThumbIV)
//           // vc.isExist = doesExist
//            vc.isFromHome = true
//            vc.delegate = self
//            self.homeVC?.navigationController?.present(vc, animated: true)
//        }
        
        if let layout = self.topCollection.collectionViewLayout as? UICollectionViewFlowLayout {

            layout.scrollDirection = .horizontal

        }
        
        
        exploreLbl.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        contentHolderView.layer.cornerRadius = 15
        tableHolderView.layer.cornerRadius = 15
        collectionHolderView.layer.cornerRadius = 15
        topCollection.layer.cornerRadius = 15
        if LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin) {
            userThumbIV.sd_setImage(with: URL(string: LocalStorage.shared.getString(key: .userimageURl)), placeholderImage: UIImage(named:""))
            self.userNameLbl.text = LocalStorage.shared.getString(key: .userName)
        } else {
            userThumbIV.image = UIImage(systemName: "person.circle")
            self.userNameLbl.text = "Hello user"
        }
        
        userThumbIV.layer.cornerRadius =  45 / 2
    }
    
    //Navigate to details page
    func navigateToDetails(_ movie: MoviesArr) {
        let vc = DetailsVC.initWithStory()
        vc.isSingleSelection = true
        vc.movDetail = movie
        vc.hidesBottomBarWhenPushed = true
        self.homeVC?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.allList.all.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeSectionTVC = tableView.dequeueReusableCell(withIdentifier: "HomeSectionTVC", for: indexPath) as! HomeSectionTVC
        let modal =  self.contentType == .movies ? self.allList.movies.results[indexPath.row] : self.allList.tvShows.results[indexPath.row]
        cell.populateCell(movie: modal)
        cell.addTap {
            //Navigate to details page
            self.navigateToDetails(self.contentType == .movies ? self.allList.movies.results[indexPath.row] : self.allList.tvShows.results[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 2.8
    }
    
    
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.allList.all.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        _ = self.allList.all.results[indexPath.item]
        let cell: WishlistCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCVC", for: indexPath) as! WishlistCVC
        cell.populateCell(movie: self.allList.all.results[indexPath.row])
        
        cell.addTap {
            self.navigateToDetails(self.allList.all.results[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem = collectionView.frame.width / 3
        return CGSize(width: widthPerItem, height: collectionView.height)
    
    }
    
    
}


extension HomeView: PopOverVCDelegate {
    
    func didTapRow(_ index: Int, _ isExist: Bool) {
        
        
         if index == 0 {
            
            let state =  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
            if state {
                SocialLoginsHandler.shared.doGoogleSignOut()
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedin, value: false)
                LocalStorage.shared.setSting(LocalStorage.LocalValue.userName, text: "")
                LocalStorage.shared.setSting(LocalStorage.LocalValue.userimageURl, text: "")
                self.homeVC?.sceneDelegate?.setLoginPage()
            } else {
                self.homeVC?.sceneDelegate?.setLoginPage()
            }
        }
    }
    
    
}
