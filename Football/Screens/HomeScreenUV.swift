//
//  HomeScreenUV.swift
//  Football
//
//  Created by Ravi on 24/09/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenUV: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, OnUserSelectDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topBarView: GradientView!
    @IBOutlet weak var menuAreaView: GradientView!
    @IBOutlet weak var topBarLabel: MyLabel!
    @IBOutlet weak var menuSearchView: UIView!
    @IBOutlet weak var menuAddView: UIView!
    @IBOutlet weak var menuReportView: UIView!
    @IBOutlet weak var menuAddImgView: UIImageView!
    @IBOutlet weak var menuSearchImgView: UIImageView!
    @IBOutlet weak var menuReportImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var userDataArrList = [NSDictionary]()
    
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var loaderView:UIView!
    
    private let minItemSpacing: CGFloat = 20
//    private let itemWidth: CGFloat      = 141
    private let headerHeight: CGFloat   = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.generalFunc.loadView(nibName: "HomeScreenDesign", uv: self))
        
        topBarView.colors = [UIColor.UCAColor.AppThemeColor, UIColor.UCAColor.AppThemeColor]
        topBarView.direction = .horizontal
        topBarView.locations = [0.40, 1.0]
        
        menuAreaView.colors = [UIColor.white, UIColor.white]
        menuAreaView.direction = .horizontal
        menuAreaView.locations = [0.40, 0.20]
        
        let menuSearchTapGue = UITapGestureRecognizer()
        
        menuSearchTapGue.addTarget(self, action: #selector(self.searchUsers))
        
        self.menuSearchImgView.isUserInteractionEnabled = true
        self.menuSearchImgView.addGestureRecognizer(menuSearchTapGue)
        
        
        let menuAddTapGue = UITapGestureRecognizer()
        
        menuAddTapGue.addTarget(self, action: #selector(self.addUser))
        
        self.menuAddImgView.isUserInteractionEnabled = true
        self.menuAddImgView.addGestureRecognizer(menuAddTapGue)
        
        let menuReportsTapGue = UITapGestureRecognizer()
        menuReportsTapGue.addTarget(self, action: #selector(self.openReport))
        
        self.menuReportImgView.isUserInteractionEnabled = true
        self.menuReportImgView.addGestureRecognizer(menuReportsTapGue)
        
//        let customFlowLayout = LeftAlignedCollectionViewFlowLayout()
//        customFlowLayout.itemSize = CGSize(width: 130, height: 185)
//        let width = UIScreen.main.bounds.width
//        customFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        customFlowLayout.itemSize = CGSize(width: 120, height: 180)
//        customFlowLayout.minimumInteritemSpacing = 0
//        customFlowLayout.minimumLineSpacing = 0
//        self.collectionView.collectionViewLayout = customFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "UsersLisCVC", bundle: nil), forCellWithReuseIdentifier: "UsersLisCVC")
        
        GeneralFunctions.setImgTintColor(imgView: menuAddImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuSearchImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuReportImgView, color: UIColor(hex: 0x272727))
        
//        addDataToList(imgName: "player1", userName: "Derrick C. Wells", userPhone: "+1 2585458785")
//        addDataToList(imgName: "player2", userName: "Christopher S. Smith", userPhone: "+1 7452123459")
//        addDataToList(imgName: "player3", userName: "Robert J. Ruiz", userPhone: "+1 4585458547")
//        addDataToList(imgName: "player4", userName: "Thomas P. Shriver", userPhone: "+1 9585254515")
//        addDataToList(imgName: "player5", userName: "Jerry C. Best", userPhone: "+1 6565235485")
//        addDataToList(imgName: "player1", userName: "William M. Jenkins", userPhone: "+1 7585456232")
//        addDataToList(imgName: "player2", userName: "Alan S. McCluskey", userPhone: "+1 4521569852")
//        addDataToList(imgName: "player3", userName: "Alberto A. Robertson", userPhone: "+1 7485632542")
//        addDataToList(imgName: "player4", userName: "Kevin D. Spears", userPhone: "+1 8695321456")
//        addDataToList(imgName: "player5", userName: "Daron L. Evans", userPhone: "+1 7542695851")
        self.isLoadingMore = false
        self.userDataArrList.removeAll()
        self.collectionView.reloadData()
        self.nextPage_str = 1
        
        let width = Application.screenSize.width
        var totalItemInRow = Int(width / 141)
        
        if(totalItemInRow < 2){
            totalItemInRow = 2
        }
        
        let itemWidth = (width / CGFloat(totalItemInRow))
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 60)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.headerReferenceSize = CGSize(width: 0, height: headerHeight)
//        
//        // Find n, where n is the number of item that can fit into the collection view
//        var n: CGFloat = 1
//        let containerWidth = collectionView.bounds.width
//        while true {
//            let nextN = n + 1
//            let totalWidth = (nextN*itemWidth) + (nextN-1)*minItemSpacing
//            if totalWidth > containerWidth {
//                break
//            } else {
//                n = nextN
//            }
//        }
//        
//        // Calculate the section inset for left and right.
//        // Setting this section inset will manipulate the items such that they will all be aligned horizontally center.
//        let inset = max(minItemSpacing, floor( (containerWidth - (n*itemWidth) - (n-1)*minItemSpacing) / 2 ) )
//        layout.sectionInset = UIEdgeInsets(top: minItemSpacing, left: inset, bottom: minItemSpacing, right: inset)
        
        collectionView.collectionViewLayout = layout
        
        
        getListOfPlayers(isLoadingMore: self.isLoadingMore)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let LOAD_PLAYER_LIST_HOME = GeneralFunctions.getValue(key: "LOAD_PLAYER_LIST_HOME")
        if(LOAD_PLAYER_LIST_HOME != nil && (LOAD_PLAYER_LIST_HOME as! String) == "true"){
            self.isLoadingMore = false
            self.userDataArrList.removeAll()
            self.collectionView.reloadData()
            self.nextPage_str = 1
            self.getListOfPlayers(isLoadingMore: false)
            GeneralFunctions.saveValue(key: "LOAD_PLAYER_LIST_HOME", value: "false" as AnyObject)
        }
    }

    func getChildIndex(userId:String) -> Int{
        for i in 0..<self.userDataArrList.count{
        
            if(self.userDataArrList[i].get("UserId") == userId){
                return i
            }
        }
        
        return -1
    }
    
    func searchUsers(){
        let searchUsersUV = GeneralFunctions.instantiateViewController(pageName: "SearchUsersUV") as! SearchUsersUV
        searchUsersUV.userSelectDelegate = self
        self.present(searchUsersUV, animated: true, completion: nil)
    }
    
    func onUserSelectCancel(searchBar: UISearchBar, searchUsersUv: SearchUsersUV) {
        searchUsersUv.closeCurrentScreen()
    }
    
    func onUserSelected(userId: String, dataDict: NSDictionary, searchBar: UISearchBar, searchUsersUv: SearchUsersUV) {
        
        Utils.printLog(msgData: "UserId:\(userId)::UserSelectedData:\(dataDict)")
        searchUsersUv.closeCurrentScreen()
        
        let userInfoUv = GeneralFunctions.instantiateViewController(pageName: "UserInfoUV") as! UserInfoUV
        userInfoUv.iPlayerId = dataDict.get("iPlayerId")
        self.present(userInfoUv, animated: true, completion: nil)
        
    }
    
    func addUser(){
        let addUserUv = GeneralFunctions.instantiateViewController(pageName: "AddUserUV")
         self.present(addUserUv, animated: true, completion: nil)
        
    }
    
    func openReport(){
        let reportsUv = GeneralFunctions.instantiateViewController(pageName: "ReportsUV")
        self.present(reportsUv, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfoUv = GeneralFunctions.instantiateViewController(pageName: "UserInfoUV") as! UserInfoUV
        userInfoUv.iPlayerId = userDataArrList[indexPath.row].get("iPlayerId")
        self.present(userInfoUv, animated: true, completion: nil)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
//        let cellSpacing = flowLayout.minimumInteritemSpacing
//        let cellWidth = flowLayout.itemSize.width
//        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
//        
//        let collectionViewWidth = collectionView.bounds.size.width
//        
//        let totalCellWidth = cellCount * cellWidth
//        let totalCellSpacing = cellSpacing * (cellCount - 1)
//        
//        let totalCellsWidth = totalCellWidth + totalCellSpacing
//        
//        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
//        
//        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDataArrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersLisCVC", for: indexPath) as! UsersLisCVC
        
        let item = userDataArrList[indexPath.row]
        
//        Utils.createRoundedView(view: cell.playerImgView, borderColor: UIColor.clear, borderWidth: 0)
        
        cell.playerNameLbl.text = item.get("vName")
        cell.playerMobileLbl.text = item.get("vMobile")
        
        cell.playerImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
//        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        
        if (maximumOffset - currentOffset <= 15) {
            
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getListOfPlayers(isLoadingMore: isLoadingMore)
            }
        }
    }
    
    func addFooterView(){
//        let loaderView =  self.generalFunc.addMDloader(contentView: self.collectionView, isAddToParent: false)
//        loaderView.backgroundColor = UIColor.clear
//        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
//        self.collectionView.tableFooterView  = loaderView
//        self.collectionView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
//        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//        self.tableView.tableFooterView?.isHidden = true
    }
    
    
    func getListOfPlayers(isLoadingMore:Bool){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        let parameters = ["type": "listOfPlayers", "page": self.nextPage_str.description]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
        
                if(dataDict.get("Action") == "1"){
                    
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0..<msgArr.count{
                        let item = msgArr[i] as! NSDictionary
                        
                        self.userDataArrList += [item]
                    }
                    
                    let NextPage = dataDict.get("NextPage")
                    
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                    self.collectionView.reloadData()
                    
                }else{
                    if(isLoadingMore == false){
                        _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                }
                
                //                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                
                
            }else{
                if(isLoadingMore == false){
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: InternetConnection.isConnectedToNetwork() ? "Some problem occurred." : "No Internet Connection", positiveBtn: "Retry", nagativeBtn: "", completionHandler: { (btnClickedId) in
                        
                        self.getListOfPlayers(isLoadingMore: isLoadingMore)
                        
                    })
                }
            }
            
            self.isLoadingMore = false
            
            self.loaderView.isHidden = true
            
        })
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
         let layoutAttribute = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        
        // First in a row.
        if layoutAttribute?.frame.origin.x == sectionInset.left {
            return layoutAttribute
        }
        
        // We need to align it to the previous item.
        let previousIndexPath = IndexPath(row: indexPath.item - 1, section: indexPath.section)
        guard let previousLayoutAttribute = self.layoutAttributesForItem(at: previousIndexPath) else {
            return layoutAttribute
        }
        
        layoutAttribute?.frame.origin.x = previousLayoutAttribute.frame.maxX + self.minimumInteritemSpacing
        
        return layoutAttribute
    }
}
