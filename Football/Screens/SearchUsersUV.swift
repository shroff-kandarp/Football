//
//  SearchPlacesUV.swift
//  Football
//
//  Created by Kandarp Shroff on 04/10/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase

protocol OnUserSelectDelegate {
    func onUserSelected(userId:String, dataDict:NSDictionary, searchBar:UISearchBar, searchUsersUv:SearchUsersUV)
    func onUserSelectCancel(searchBar:UISearchBar, searchUsersUv:SearchUsersUV)
}


class SearchUsersUV: UIViewController, UISearchBarDelegate, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var menuAreaView: GradientView!
    @IBOutlet weak var menuSearchView: UIView!
    @IBOutlet weak var menuAddView: UIView!
    @IBOutlet weak var menuReportView: UIView!
    @IBOutlet weak var menuAddImgView: UIImageView!
    @IBOutlet weak var menuSearchImgView: UIImageView!
    @IBOutlet weak var menuReportImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    let searchBar = UISearchBar()
    
    var isScreenLoaded = false
    
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var cntView:UIView!
    
    var cancelLbl:MyLabel!
    
    var dataArrList = [NSDictionary]()
    
    var loaderView:UIView!
    var errorLbl:MyLabel!
    
    var userSelectDelegate:OnUserSelectDelegate?
    
    var searchExeServerTask:ExeServerUrl!
    
    var currentSearchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        let textWidth = ("Cancel").width(withConstrainedHeight: 29, font: UIFont(name: "Roboto-Light", size: 17)!)
        searchBar.frame.size = CGSize(width: Application.screenSize.width - 45 - textWidth, height: 40)
        navItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        
        cancelLbl = MyLabel()
        cancelLbl.font = UIFont(name: "Roboto-Light", size: 17)!
        cancelLbl.text = "Cancel"
        cancelLbl.setClickDelegate(clickDelegate: self)
        cancelLbl.fitText()
        cancelLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        navItem.titleView = UIView()
        navItem.rightBarButtonItem = UIBarButtonItem(customView:cancelLbl)
        
        menuAreaView.colors = [UIColor.white, UIColor.white]
        menuAreaView.direction = .horizontal
        menuAreaView.locations = [0.40, 0.20]
        
        
        GeneralFunctions.setImgTintColor(imgView: menuAddImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuSearchImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuReportImgView, color: UIColor(hex: 0x272727))
        
        let menuAddTapGue = UITapGestureRecognizer()
        
        menuAddTapGue.addTarget(self, action: #selector(self.addUser))
        
        self.menuAddImgView.isUserInteractionEnabled = true
        self.menuAddImgView.addGestureRecognizer(menuAddTapGue)
        
        let menuReportsTapGue = UITapGestureRecognizer()
        menuReportsTapGue.addTarget(self, action: #selector(self.openReport))
        
        self.menuReportImgView.isUserInteractionEnabled = true
        self.menuReportImgView.addGestureRecognizer(menuReportsTapGue)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        
        if(isScreenLoaded == false){
            cntView = self.generalFunc.loadView(nibName: "SearchUsersScreenDesign", uv: self, contentView: contentView)
            
            
            self.contentView.addSubview(cntView)
            self.tableView.bounces = false
            
            isScreenLoaded = true
            
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(UINib(nibName: "UsersListTVCellDesign", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "UsersListTVCell")
            self.tableView.tableFooterView = UIView()
            
        }
        
        searchBar.becomeFirstResponder()
    }
    
    func myLableTapped(sender: MyLabel) {
        if(self.cancelLbl != nil && sender == cancelLbl){
            searchBarCancelButtonClicked(self.searchBar)
        }
    }
    
    
    
    func addUser(){
        let addUserUv = GeneralFunctions.instantiateViewController(pageName: "AddUserUV")
        self.present(addUserUv, animated: true, completion: nil)
        
    }
    
    func openReport(){
        let reportsUv = GeneralFunctions.instantiateViewController(pageName: "ReportsUV")
        self.present(reportsUv, animated: true, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        for(id subview in [yourSearchBar subviews])
        //        {
        //            if ([subview isKindOfClass:[UIButton class]]) {
        //                [subview setEnabled:YES];
        //            }
        //        }
        
        Utils.printLog(msgData: "EndEditing")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Utils.printLog(msgData: "Begin Editing")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        fetchAutoCompleteUsers(searchText: searchText.trim())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.closeCurrentScreen()
        if(self.userSelectDelegate != nil){
            self.userSelectDelegate?.onUserSelectCancel(searchBar: self.searchBar, searchUsersUv: self)
        }
    }
    
    func fetchAutoCompleteUsers(searchText:String){
        
        if(searchText.characters.count < 2){
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            if (searchText == ""){
                
                self.dataArrList.removeAll()
                self.isLoadingMore = false
                self.nextPage_str = 1
                self.isNextPageAvail = false
                self.tableView.reloadData()
            }
            //            changeContentSize(PAGE_HEIGHT: defaultPageHeight)
            
            return
        }
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }
        
        self.currentSearchQuery = searchText
        
        self.dataArrList.removeAll()
        self.isLoadingMore = false
        self.nextPage_str = 1
        self.isNextPageAvail = false
        self.tableView.reloadData()
        
        self.getSearchData(searchQuery: searchText, isLoadingMore:  false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListTVCell", for: indexPath) as! UsersListTVCell
        
        let item = dataArrList[indexPath.row]
        
        Utils.createRoundedView(view: cell.userPicImgView, borderColor: UIColor.clear, borderWidth: 0)
        
        cell.userNameLbl.text = item.get("vName")
        cell.userPhoneLbl.text = item.get("vMobile")
        
        cell.userPicImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        cell.selectionStyle = .none;
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.dataArrList[indexPath.item]
        
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: item.location, selectedAddress: item.address)
        
        if(self.userSelectDelegate != nil){
            self.userSelectDelegate?.onUserSelected(userId: item.get("UserId"), dataDict: item, searchBar: self.searchBar, searchUsersUv: self)
        }
    }
    
    func getSearchData(searchQuery:String, isLoadingMore:Bool){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }
        
        
        if(searchExeServerTask != nil)
        {
            searchExeServerTask.cancel()
            searchExeServerTask = nil
        }
        
        let parameters = ["type":"searchPlayers", "searchQuery": searchQuery]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        searchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(isLoadingMore == false){
                self.dataArrList.removeAll()
            }
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0..<msgArr.count {
                        let item = msgArr[i] as! NSDictionary
                        
                        self.dataArrList += [item]
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
                    
                    self.tableView.reloadData()
                    
                }else{
//                    if(isLoadingMore == false && self.dataArrList.count == 0){
//                        if(self.errorLbl == nil){
//                            self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: dataDict.get("message"))
//                        }else{
//                            self.errorLbl.text = dataDict.get("message")
//                        }
//                        
//                        self.errorLbl.isHidden = false
//                        
//                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
//                    }
                    
                }
                
                //                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                
                
            }else{
//                if(isLoadingMore == false && self.dataArrList.count == 0){
////                    self.generalFunc.setAlertMessage(uv: self, title: "", content: InternetConnection.isConnectedToNetwork() ? "Some problem occurred." : "No Internet Connection", positiveBtn: "Retry", nagativeBtn: "", completionHandler: { (btnClickedId) in
////                        
////                        self.getSearchData(searchQuery: searchQuery, isLoadingMore: isLoadingMore)
////                        
////                    })
//                    
//                    let msg = InternetConnection.isConnectedToNetwork() ? "Server error occurred. Please try again later." : "No Internet Connection"
//                    
//                    if(self.errorLbl == nil){
//                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: msg)
//                    }else{
//                        self.errorLbl.text = msg
//                    }
//                    
//                    self.errorLbl.isHidden = false
//                }
            }
            
            self.isLoadingMore = false
            
            self.loaderView.isHidden = true
            
        })
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        
        if (maximumOffset - currentOffset <= 15) {
            
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getSearchData(searchQuery: currentSearchQuery,isLoadingMore: isLoadingMore)
            }
        }
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor.clear
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }
    
    
}
