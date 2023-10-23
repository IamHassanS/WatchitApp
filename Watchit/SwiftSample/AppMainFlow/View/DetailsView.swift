
//
//  MapFilterView.swift
//  Watchit
//
//  Created by HASSAN on 20/10/21.
//

import Foundation
import UIKit
import GoogleSignIn

extension DetailsView: PopOverVCDelegate {
    
    func didTapRow(_ index: Int, _ isExist: Bool) {
        if index == 0 {
            if  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin) {
                if !isExist {
                    CoreDataManager.shared.toAddMovie(detailVC.movDetail, ImageData: self.imageData)
                    { isSuccess in
                        if isSuccess {
                            self.detailVC.sceneDelegate?.createToastMessage("successfilly added to watchlist ", isFromWishList: true)
                        } else {
                            self.detailVC.sceneDelegate?.createToastMessage("Failed to save", isFromWishList: true)
                        }
                    }
                } else {
                    CoreDataManager.shared.toRemoveMovie(detailVC.movDetail.id) { didRemoved in
                        if didRemoved {
                            self.detailVC.sceneDelegate?.createToastMessage("successfilly removed from watchlist ", isFromWishList: true)
                            
                        } else {
                            self.detailVC.sceneDelegate?.createToastMessage("Failed to remove", isFromWishList: true)
                        }
                    }
                }

            } else {
                let commonAlert = CommonAlert()
                commonAlert.setupAlert(alert: "Watchit", alertDescription: "Login to add TV shows / Movies to your watch list", okAction: "Ok", userImage: imageData)
                commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                    print("Yes action")
                   
                    self.detailVC.sceneDelegate?.setLoginPage()
                   // LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
                  
                }
                commonAlert.addAdditionalCancelAction {
                    self.detailVC.sceneDelegate?.setLoginPage()
                    print("No action")
                  
                }

            }
  
         
        }
        
        else if index == 1 {
            
            let state =  LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
            if state {
                SocialLoginsHandler.shared.doGoogleSignOut()
                LocalStorage.shared.setBool(LocalStorage.LocalValue.isUserLoggedin, value: false)
                LocalStorage.shared.setSting(LocalStorage.LocalValue.userName, text: "")
                LocalStorage.shared.setSting(LocalStorage.LocalValue.userimageURl, text: "")
                self.detailVC?.sceneDelegate?.setLoginPage()
            } else {
                self.detailVC?.sceneDelegate?.setLoginPage()
            }
        }
    }
    
    
}

class DetailsView: BaseView {
    
    enum pageType {
        case show
        case hide
        case notConnected
        case connected
    }
    
    func setPageType(_ type: pageType) {
        switch type {
            
        case .show:
            self.pageType = type
            noConnectionView.isHidden = true
            holderView.isHidden = false
            self.roomListCollectionView.isHidden = false
            cellRegistration()
            toloadData()
            self.removeAddedGesture()
            self.addSwipGesture()
            self.refreshMapMarkers(andFocusItemAt: 0)
        case .hide:
            self.pageType = type
            noConnectionView.isHidden = true
            holderView.isHidden = false
            self.roomListCollectionView.isHidden = true
            self.titleLbl.text = detailVC.movDetail.commonName
            self.descriptionLbl.text = detailVC.movDetail.overview
            
            let path =  detailVC.movDetail.posterPath
            let test = (APIImageUrlString) + "\(path)"
           // backGroundIV.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
            
            
          //  centerImage.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
            do {
            let imgData = try NSData(contentsOf: URL.init(string: test)!, options: NSData.ReadingOptions())
        self.imageData = imgData as Data
                backGroundIV.image = UIImage(data: imageData)
                centerImage.image = UIImage(data: imageData)
    } catch {
        print("")
    }
         
            
            self.popularityLbl.text = "\(detailVC.movDetail.popularity) / 10 • \(detailVC.movDetail.voteCount) Reviews"
            let strArr =  detailVC.movDetail.genresStr
           let str =  strArr.joined(separator:"-")
            self.genreAndyearLbl.text = str
        case .notConnected:
            noConnectionView.isHidden = false
            holderView.isHidden = true
        case .connected:
           // self.setPageType(self.pageType)
            noConnectionView.isHidden = true
            holderView.isHidden = false
           // self.setPageType(self.pageType)
        }

    }
    @IBOutlet weak var noConnectionView: UIView!
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var optionsView: UIView!
    
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var backGroundIV: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var roomListCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var popularityLbl: UILabel!
    
    @IBOutlet weak var genreAndyearLbl: UILabel!
    
    @IBOutlet weak var backHolderView : UIView!
    let network: ReachabilityManager = ReachabilityManager.sharedInstance
    var detailVC: DetailsVC!
    
   var homeListDictArray = [MoviesArr]()
   // var currentPage = 2
   // var staysPage = 2
    var movieArr : [Film]?
    var indices = [IndexPath]()
var imageData = Data()
    var currentIndex : Int = 0

    var arrIndex = Int()
    var pageType: pageType = .connected
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.detailVC = baseVC as? DetailsVC
      //  callApi()
//        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)

     
    }
    
    
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        self.detailVC = baseVC as? DetailsVC
        
//        ReachabilityManager.isUnreachable { _ in            self.networkModified(false)
//        }
//
//        ReachabilityManager.isReachable { _ in    self.networkModified(true)
//
//        }
        
        self.homeListDictArray = detailVC.homeListDictArray
        setupUI()
        initTaps()
        NotificationCenter.default.addObserver(self, selector: #selector(networkModified(_:)) , name: NSNotification.Name("connectionChanged"), object: nil)

        
        
      let connectivity =  LocalStorage.shared.getString(key: .connectivity)
        if connectivity == "No Connection" {
                setPageType(.notConnected)
        } else {
                if detailVC.isSingleSelection {
                    setPageType(.hide)
                } else {
                    setPageType(.show)
                }
        }
        

        
        CoreDataManager.shared.fetchMovies { films in
            self.movieArr = films
        }
        

    }
    
    @objc func networkModified(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
               if let status = dict["Type"] as? String{
                   // do something with your image
                   DispatchQueue.main.async {
                       if status == "No Connection" {
                           self.setPageType(.notConnected)
                       } else {
                           self.setPageType(.connected)
                       }

                   }
               }
           }
    }
    
    func initTaps() {
        backHolderView.addTap {
            self.detailVC.navigationController?.popViewController(animated: true)
            
        }
        
        optionsView.addTap {
            var doesExist = Bool()
            CoreDataManager.shared.toCheckExistance(self.detailVC.movDetail.id) { isExists in
                if isExists {
                    doesExist = true
                } else {
                    doesExist = false
                }
            }
            
            print("Tapped -->")
            let vc = PopOverVC.initWithStory(preferredFrame: CGSize(width: self.width / 3, height: self.height / 5), on: self.optionsView)
            vc.isExist = doesExist
            vc.delegate = self
            self.detailVC.navigationController?.present(vc, animated: true)
        }
    }


    
    
    func addSwipGesture() {
        if homeListDictArray.count >= 2 {
            
            let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeinRight))
 
                swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            
            roomListCollectionView.addGestureRecognizer(swipeRight)
            let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeinLeft))
      
                swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            
            roomListCollectionView.addGestureRecognizer(swipeLeft)
        }
    }
    
    // MARK: - Handle Left Swipe GestureRecognizer
    @objc func handleSwipeinLeft(recognizer: UISwipeGestureRecognizer) {
        if currentIndex >= homeListDictArray.count - 1 {
            return
            
        } else  if currentIndex == homeListDictArray.count - 1 {
            currentIndex = homeListDictArray.count - 1
            let index = IndexPath(item: currentIndex, section: 0)
            roomListCollectionView.scrollToItem(at: index, at: .left, animated: true)
            self.refreshMapMarkers(andFocusItemAt: currentIndex)
        }
        
        if currentIndex >= homeListDictArray.count - 2 {
            currentIndex += 1
            let index = IndexPath(item: currentIndex, section: 0)
            roomListCollectionView.scrollToItem(at: index, at: .left, animated: true)
            self.refreshMapMarkers(andFocusItemAt: currentIndex)
        } else {
            currentIndex += 1
            roomListCollectionView.isScrollEnabled = true
            let index = IndexPath(item: currentIndex, section: 0)
            roomListCollectionView.scrollToItem(at: index, at: .left, animated: true)
            roomListCollectionView.isScrollEnabled = false
            self.refreshMapMarkers(andFocusItemAt: currentIndex)
        }
        

    }
    
    @objc func handleSwipeinRight(recognizer: UISwipeGestureRecognizer) {
        if currentIndex == 0 {
            return
        }
        if currentIndex >= homeListDictArray.count - 1 {
            currentIndex -= 1
        } else {
            currentIndex -= 1
            roomListCollectionView.isScrollEnabled = true
            
            roomListCollectionView.setContentOffset(CGPoint(x: (currentIndex==1) ? 175 : 180 * currentIndex,y :0), animated: true)
            roomListCollectionView.isScrollEnabled = false
        }
        
        
        roomListCollectionView.isScrollEnabled = true
        let index = IndexPath(item: currentIndex, section: 0)
        roomListCollectionView.scrollToItem(at: index, at: .left, animated: true)
        roomListCollectionView.isScrollEnabled = false
        DispatchQueue.main.async { [self] in
            self.refreshMapMarkers(andFocusItemAt: currentIndex)
        }
        
        
    }
    
    
    func makeCollectionScroll(_ tag: Int32)
    {

        roomListCollectionView.reloadData()

    }
    
    
    func refreshMapMarkers(andFocusItemAt markerIndex : Int) {
        
        self.titleLbl.text = self.homeListDictArray[markerIndex].commonName
        self.descriptionLbl.text = self.homeListDictArray[markerIndex].overview
        
        let path =  self.homeListDictArray[markerIndex].posterPath
        let test = (APIImageUrlString) + "\(path)"
       // backGroundIV.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
        
        
      //  centerImage.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
        do {
        let imgData = try NSData(contentsOf: URL.init(string: test)!, options: NSData.ReadingOptions())
    self.imageData = imgData as Data
            backGroundIV.image = UIImage(data: imageData)
            centerImage.image = UIImage(data: imageData)
} catch {
    print("")
}
        self.popularityLbl.text = "\(self.homeListDictArray[markerIndex].popularity) / 10 • \(self.homeListDictArray[markerIndex].voteCount) Reviews"
        let strArr =  self.homeListDictArray[markerIndex].genresStr
       let str =  strArr.joined(separator:"-")
        self.genreAndyearLbl.text = str
        
        arrIndex = markerIndex
    }
    
    func removeAddedGesture() {
        roomListCollectionView.gestureRecognizers?.removeAll()
    }

    func cellRegistration() {
        roomListCollectionView.register(UINib(nibName: "DetailsCVC", bundle: nil), forCellWithReuseIdentifier: "DetailsCVC")
    }
    func setupUI() {
        
//        if detailVC.isSingleSelection {
//            setPageType(.hide)
//        } else {
//            setPageType(.show)
//        }
        centerImage.layer.cornerRadius = 12
        if let layout = self.roomListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        self.backHolderView.elevate(4)
        self.backHolderView.layer.cornerRadius = backHolderView.height / 2
        roomListCollectionView.showsHorizontalScrollIndicator = false

    }
    func toloadData() {
        roomListCollectionView.delegate = self
        roomListCollectionView.dataSource = self
        roomListCollectionView.reloadData()
    }

    
}


extension DetailsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeListDictArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetailsCVC = roomListCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCVC", for: indexPath) as! DetailsCVC
        cell.populatecell(self.homeListDictArray[indexPath.row])
        cell.elevate(4)
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 1.2, height: collectionView.height)
    }
    
    
}


