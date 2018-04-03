//
//  ReportsUV.swift
//  Football
//
//  Created by Ravi on 25/09/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class ReportsUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MDDatePickerDialogDelegate, OnUserSelectDelegate  {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backImgArea: UIView!
    @IBOutlet weak var backImgView: UIImageView!
    
    @IBOutlet weak var submitBtnArea: GradientView!
    @IBOutlet weak var fromDateSelectionArea: UIView!
    @IBOutlet weak var toDateSelectionArea: UIView!
    
    @IBOutlet weak var dateSelectionGeneralView: UIView!
    @IBOutlet weak var selectFromDateLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var fromDateSelectArrowImgView: UIImageView!
    
    @IBOutlet weak var menuAreaView: GradientView!
    @IBOutlet weak var menuSearchView: UIView!
    @IBOutlet weak var menuAddView: UIView!
    @IBOutlet weak var menuReportView: UIView!
    @IBOutlet weak var menuAddImgView: UIImageView!
    @IBOutlet weak var menuSearchImgView: UIImageView!
    @IBOutlet weak var menuReportImgView: UIImageView!
    
    @IBOutlet weak var selectToDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var toDateSelectArrowImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var userDataArrList = [NSDictionary]()
    var selectedFromDate = ""
    var selectedToDate = ""
    
    var selectFromDateTapGue = UITapGestureRecognizer()
    var selectToDateTapGue = UITapGestureRecognizer()
    
    var DATE_SELECTION_TYPE = ""
    
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var loaderView:UIView!
    
    let submitTapGue = UITapGestureRecognizer()
    
    var iPlayerId = ""
    var noDataLbl:MyLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "ReportsScreenDesign", uv: self, contentView: contentView))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let closeTapGue = UITapGestureRecognizer()
        closeTapGue.addTarget(self, action: #selector(self.closeCurrentScreen))
        
        backImgArea.isUserInteractionEnabled = true
        backImgArea.addGestureRecognizer(closeTapGue)
        
        headerView.colors = [UIColor.UCAColor.AppThemeColor, UIColor.UCAColor.AppThemeColor]
        headerView.direction = .horizontal
        headerView.locations = [0.40, 1.0]
        
        self.tableView.register(UINib(nibName: "ReportsUserListTVCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "ReportsUserListTVCell")
        self.tableView.tableFooterView = UIView()
        
        GeneralFunctions.setImgTintColor(imgView: fromDateSelectArrowImgView, color: UIColor(hex: 0x1c1c1c))
        GeneralFunctions.setImgTintColor(imgView: toDateSelectArrowImgView, color: UIColor(hex: 0x1c1c1c))
        selectFromDateLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        selectToDateLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        
        submitBtnArea.colors = [UIColor.UCAColor.AppThemeColor, UIColor.UCAColor.AppThemeColor]
        submitBtnArea.direction = .horizontal
        submitBtnArea.locations = [0.70, 0.20]
        Utils.createRoundedView(view: submitBtnArea, borderColor: UIColor.clear, borderWidth: 1, cornerRadius: 8)

        
        self.selectedFromDate = Date().convertDateToYMD()
        fromDateLbl.text = "\(Date().getDayName()), \(Date().getDayNum()) \(Date().getMonthName()) \(Date().getYear())"
        
        
        self.selectedToDate = Date().convertDateToYMD()
        toDateLbl.text = "\(Date().getDayName()), \(Date().getDayNum()) \(Date().getMonthName()) \(Date().getYear())"
        
        self.tableView.isHidden = true
        self.tableView.reloadData()
        
        
        self.submitTapGue.addTarget(self, action: #selector(self.findReport))
        submitBtnArea.isUserInteractionEnabled = true
        self.submitBtnArea.addGestureRecognizer(self.submitTapGue)
        
        selectFromDateTapGue.addTarget(self, action: #selector(self.selectFromDate))
        fromDateSelectionArea.isUserInteractionEnabled = true
        fromDateSelectionArea.addGestureRecognizer(selectFromDateTapGue)
        
        selectToDateTapGue.addTarget(self, action: #selector(self.selectToDate))
        toDateSelectionArea.isUserInteractionEnabled = true
        toDateSelectionArea.addGestureRecognizer(selectToDateTapGue)
        
        
        if(self.iPlayerId != ""){
            self.headerLbl.text = "Player Report"
        }
        
        menuAreaView.colors = [UIColor.white, UIColor.white]
        menuAreaView.direction = .horizontal
        menuAreaView.locations = [0.40, 0.20]
        
        
        GeneralFunctions.setImgTintColor(imgView: menuAddImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuSearchImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuReportImgView, color: UIColor(hex: 0x272727))
        
        let menuSearchTapGue = UITapGestureRecognizer()
        
        menuSearchTapGue.addTarget(self, action: #selector(self.searchUsers))
        
        self.menuSearchImgView.isUserInteractionEnabled = true
        self.menuSearchImgView.addGestureRecognizer(menuSearchTapGue)
        
        
        let menuAddTapGue = UITapGestureRecognizer()
        
        menuAddTapGue.addTarget(self, action: #selector(self.addUser))
        
        self.menuAddImgView.isUserInteractionEnabled = true
        self.menuAddImgView.addGestureRecognizer(menuAddTapGue)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(GeneralFunctions.getValue(key: "PLAYER_INFO_UPDATED") != nil){
            
            if((GeneralFunctions.getValue(key: "PLAYER_INFO_UPDATED") as! String).uppercased() == "YES"){
                findReport()
            }
            GeneralFunctions.removeValue(key: "PLAYER_INFO_UPDATED")
        }
    }
    
    override func closeCurrentScreen() {
        
        if(self.tableView.isHidden == false){
            self.tableView.isHidden = true
            self.dateSelectionGeneralView.isHidden = false
            
            self.isLoadingMore = false
            self.userDataArrList.removeAll()
            self.tableView.reloadData()
            self.nextPage_str = 1
            
            if(self.noDataLbl != nil){
                self.noDataLbl.isHidden = true
            }
            
            return
        }
        super.closeCurrentScreen()
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
    
    
    func findReport(){
        if(self.selectedFromDate != "" && self.selectedToDate != ""){
            self.isLoadingMore = false
            self.userDataArrList.removeAll()
            self.tableView.reloadData()
            self.nextPage_str = 1
            
            self.tableView.isHidden = false
            self.dateSelectionGeneralView.isHidden = true
            
            getListOfPlayers(isLoadingMore: self.isLoadingMore)
        }
    }
    
    
    func selectFromDate(){
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month, .day], from: Date())
//        components.day = 1
//        components.month = 1
//        components.year = 1970
        
//        let date = calendar.date(from: components)
        
        DATE_SELECTION_TYPE = "FROM"
        let mdDateSelection = MDDatePickerDialog()
        mdDateSelection.selectedDate = Date()
        mdDateSelection.maximumDate = Date()
//        mdDateSelection.minimumDate = date!
        mdDateSelection.delegate = self
        mdDateSelection.show()
        
    }

    func selectToDate(){
        DATE_SELECTION_TYPE = "TO"
        let mdDateSelection = MDDatePickerDialog()
        mdDateSelection.selectedDate = Date()
        mdDateSelection.maximumDate = Date()
        mdDateSelection.delegate = self
        mdDateSelection.show()
    }
    
    func datePickerDialogDidSelect(_ date: Date) {
        Utils.printLog(msgData: "Date::Selected::\(date.getDayName())")
        Utils.printLog(msgData: "DateAddByMinte:\(date.addedBy(minutes: 1))")
        Utils.printLog(msgData: "DateAfterConvert:\(date.convertDateToYMD())")
        
        let selectedDate = Utils.convertStringToDate(dateStr: date.convertDateToYMD(), dateFormat: "yyyy-MM-dd")
        
        if(selectedDate > Date()){
            self.generalFunc.setError(uv: self, title: "", content: "Selected date cannot be greter then current date. Please select current date or date before current date.")
        }else{
            Utils.printLog(msgData: "added:\("\(selectedDate.getDayName()), \(selectedDate.getDayNum()) \(selectedDate.getMonthName()) \(selectedDate.getYear())")::::::\(selectedDate)")
            
            if(self.DATE_SELECTION_TYPE == "FROM"){
                if(self.selectedToDate != ""){
                    let toDate = Utils.convertStringToDate(dateStr: self.selectedToDate, dateFormat: "yyyy-MM-dd")
                    
                    if(toDate < selectedDate){
                        self.generalFunc.setError(uv: self, title: "", content: "From date should be smaller then to date.")
                        return
                    }
                }
                
                
                self.selectedFromDate = date.convertDateToYMD()
                fromDateLbl.text = "\(selectedDate.getDayName()), \(selectedDate.getDayNum()) \(selectedDate.getMonthName()) \(selectedDate.getYear())"
            }else{
                if(self.selectedFromDate != ""){
                    let fromDate = Utils.convertStringToDate(dateStr: self.selectedFromDate, dateFormat: "yyyy-MM-dd")
                    
                    if(fromDate > selectedDate){
                        self.generalFunc.setError(uv: self, title: "", content: "To date should be bigger then from date.")
                        return
                    }
                }
                
                self.selectedToDate = date.convertDateToYMD()
                toDateLbl.text = "\(selectedDate.getDayName()), \(selectedDate.getDayNum()) \(selectedDate.getMonthName()) \(selectedDate.getYear())"
            }
        }
        
        
    }

//    func addDataToList(imgName:String, userName: String, userPhone:String){
//        var data = [String:String]()
//        data["UserImage"] = imgName
//        data["UserName"] = userName
//        data["UserPhone"] = userPhone
//        
//        self.userDataArrList += [data as NSDictionary]
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsUserListTVCell", for: indexPath) as! ReportsUserListTVCell
        
        let item = userDataArrList[indexPath.row]
        
        Utils.createRoundedView(view: cell.userPicImgView, borderColor: UIColor.clear, borderWidth: 0)
        
        
//        Utils.createRoundedView(view: cell.statusView, borderColor: UIColor.clear, borderWidth: 0)
        
        cell.balanceLbl.text = Utils.currencySymbol + "\(item.get("balance"))"
        if(GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("balance")) < 0){
            cell.statusImgView.image = UIImage(named: "ic_red")
            cell.balanceLbl.textColor = UIColor(hex: 0xFF3333)
        }else if(GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("balance")) > 0){
            cell.statusImgView.image = UIImage(named: "ic_green")
            cell.balanceLbl.textColor = UIColor(hex: 0x33FF4C)
        }else{
            cell.statusImgView.image = UIImage(named: "ic_blue")
            cell.balanceLbl.textColor = UIColor(hex: 0x33ACFF)
        }
        if(self.iPlayerId != ""){
            cell.numOfMatchesLbl.text = "Match Played: \(item.get("tMatches") == "1" ? "Yes" : "No")"
        }else{
            cell.numOfMatchesLbl.text = "Played matches: " + item.get("tMatches")
        }
        cell.userNameLbl.text = item.get("vName")
        cell.userPhoneLbl.text = item.get("vMobile")
        
        if(self.iPlayerId == ""){
            cell.dateLbl.isHidden = true
            cell.dateLblHeight.constant = 0
        }else{
            cell.dateLbl.isHidden = false
        }
        cell.dateLbl.text = item.get("Date")
        
        cell.userPicImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        cell.selectionStyle = .none;
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDataArrList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(iPlayerId != ""){
            return
        }
        
        let userInfoUv = GeneralFunctions.instantiateViewController(pageName: "UserInfoUV") as! UserInfoUV
        userInfoUv.iPlayerId = userDataArrList[indexPath.row].get("iPlayerId")
        self.present(userInfoUv, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.iPlayerId == ""){
            return 80
        }else{
            return 100
        }
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
    
    func getListOfPlayers(isLoadingMore:Bool){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        if(self.noDataLbl != nil){
            self.noDataLbl.isHidden = true
        }
        
        let parameters = ["type": "getPlayerTransactionHistory", "page": self.nextPage_str.description, "fromDate": self.selectedFromDate, "todate": self.selectedToDate, "iPlayerId": iPlayerId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            Utils.printLog(msgData: "response:::\(response)")
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
                    
                    self.tableView.reloadData()
                    
                }else{
                    if(isLoadingMore == false){
                        if(self.noDataLbl == nil){
                            self.noDataLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: "No data found")
                            self.noDataLbl.isHidden = false
                        }else{
                            self.noDataLbl.isHidden = false
                        }
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                }
                
                //                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                
                
            }else{
                if(isLoadingMore == false && InternetConnection.isConnectedToNetwork() == false){
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
