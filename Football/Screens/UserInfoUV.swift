//
//  UserInfoUV.swift
//
//
//  Created by Ravi on 24/09/17.
//
//

import UIKit
import Firebase

class UserInfoUV: UIViewController, MyLabelClickDelegate, MDDatePickerDialogDelegate, OnUserSelectDelegate{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backImgView: UIImageView!
    
    @IBOutlet weak var userPicImgView: UIImageView!
    
    @IBOutlet weak var userNameLbl: MyLabel!
    @IBOutlet weak var userMobileLbl: MyLabel!
    @IBOutlet weak var userDetailBGView: UIView!
    
    @IBOutlet weak var submitLbl: MyLabel!
    @IBOutlet weak var addContainerView: GradientView!
    @IBOutlet weak var minusContainerView: GradientView!
    @IBOutlet weak var playedChkBox: BEMCheckBox!
    @IBOutlet weak var submitBtnArea: GradientView!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var myPriceTxtField: MyTextField!
    @IBOutlet weak var dateSelectionView: UIView!
    @IBOutlet weak var selectTransactionDateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateSelectArrowImgView: UIImageView!
    @IBOutlet weak var matchesCountLbl:MyLabel!
    @IBOutlet weak var addBalanceLbl: MyLabel!
    @IBOutlet weak var minusBalanceLbl: MyLabel!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var editProfileView: GradientView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var paymentSelectAreaView: UIView!
    @IBOutlet weak var profileSelectAreaView: UIView!
    @IBOutlet weak var statesSelectAreaView: UIView!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var paymentAreaBottomStrip: UIView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var profileAreaBottomStrip: UIView!
    @IBOutlet weak var statesLbl: UILabel!
    @IBOutlet weak var statesAreaBottomStrip: UIView!
    @IBOutlet weak var editProfileDetailLbl: MyLabel!
    
    
    @IBOutlet weak var menuAreaView: GradientView!
    @IBOutlet weak var menuSearchView: UIView!
    @IBOutlet weak var menuAddView: UIView!
    @IBOutlet weak var menuReportView: UIView!
    @IBOutlet weak var menuAddImgView: UIImageView!
    @IBOutlet weak var menuSearchImgView: UIImageView!
    @IBOutlet weak var menuReportImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var iPlayerId = ""
    
    let submitTapGue = UITapGestureRecognizer()
    let profileAreaTapGue = UITapGestureRecognizer()
    let statesAreaTapGue = UITapGestureRecognizer()
    let paymentAreaTapGue = UITapGestureRecognizer()
    
    var loaderView:UIView!
    
    let selectDateTapGue = UITapGestureRecognizer()
    
    var selectedDate = ""
    var playerDataDict:NSDictionary!
    
    var cntView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 710
    let transHistoryTapGue = UITapGestureRecognizer()

    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.cntView != nil){
            self.changePageHeight(PAGE_HEIGHT: PAGE_HEIGHT)
        }
        
        let LOAD_PLAYER_DETAILS = GeneralFunctions.getValue(key: "LOAD_PLAYER_DETAILS")
        if(LOAD_PLAYER_DETAILS != nil && (LOAD_PLAYER_DETAILS as! String) == "true"){
            getPlayerData()
            GeneralFunctions.saveValue(key: "LOAD_PLAYER_DETAILS", value: "false" as AnyObject)
        }
    }
    
    func changePageHeight(PAGE_HEIGHT:CGFloat){
        
        var PAGE_HEIGHT_TEMP = PAGE_HEIGHT
        
        if(PAGE_HEIGHT_TEMP < self.scrollView.frame.size.height){
            PAGE_HEIGHT_TEMP = self.scrollView.frame.size.height
        }
        
        self.PAGE_HEIGHT = PAGE_HEIGHT_TEMP
        self.cntView.frame.size = CGSize(width: self.cntView.frame.size.width, height: PAGE_HEIGHT_TEMP)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: PAGE_HEIGHT_TEMP)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "UserProfileDetailScreenDesign", uv: self, contentView: scrollView)
        
        self.scrollView.addSubview(cntView)
        
        priceTxtField.isHidden = true
        
        
        self.scrollView.bounces = false
        
        self.scrollView.backgroundColor = UIColor(hex: 0xECECEC)
        
        self.userDetailBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.userDetailBGView.opacity = 0.74
        
        //        dateSelectionView.colors = [UIColor.UCAColor.AppThemeColor_1.lighter(by: 8)!, UIColor.UCAColor.AppThemeColor.lighter(by: 5)!]
        //        dateSelectionView.mode = .linear
        //        dateSelectionView.direction = .horizontal
        //        dateSelectionView.locations = [0.91, 0.45]
        
        let closeTapGue = UITapGestureRecognizer()
        closeTapGue.addTarget(self, action: #selector(self.closeCurrentScreen))
        
        backImgView.isUserInteractionEnabled = true
        backImgView.addGestureRecognizer(closeTapGue)
        
        GeneralFunctions.setImgTintColor(imgView: backImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: dateSelectArrowImgView, color: UIColor(hex: 0x1c1c1c))
        
        backImgView.backgroundColor = UIColor.white
        
        Utils.createRoundedView(view: backImgView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: addContainerView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: minusContainerView, borderColor: UIColor.clear, borderWidth: 0)
        
        
        let userProfileImgTapGue = UITapGestureRecognizer()
        userProfileImgTapGue.addTarget(self, action: #selector(self.profilePicTapped))
        
        self.editProfileView.isUserInteractionEnabled = true
        self.editProfileView.addGestureRecognizer(userProfileImgTapGue)
        
        
        selectTransactionDateLbl.textColor = UIColor.UCAColor.AppThemeColor_Dark
        
        addContainerView.colors = [UIColor.UCAColor.AppThemeColor_Dark, UIColor.UCAColor.AppThemeColor_Dark]
        addContainerView.direction = .horizontal
        addContainerView.locations = [0.70, 0.20]
        
        minusContainerView.colors = [UIColor.UCAColor.AppThemeColor_Dark, UIColor.UCAColor.AppThemeColor_Dark]
        minusContainerView.direction = .horizontal
        minusContainerView.locations = [0.70, 0.20]
        
        
        submitBtnArea.colors = [UIColor.UCAColor.AppThemeColor_Dark, UIColor.UCAColor.AppThemeColor_Dark]
        submitBtnArea.direction = .horizontal
        submitBtnArea.locations = [0.70, 0.20]
        
        editProfileView.colors = [UIColor.UCAColor.AppThemeColor_Dark, UIColor.UCAColor.AppThemeColor_Dark]
        editProfileView.direction = .horizontal
        editProfileView.locations = [0.70, 0.20]
        
        self.submitLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.editProfileDetailLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        Utils.createRoundedView(view: submitBtnArea, borderColor: UIColor.clear, borderWidth: 1, cornerRadius: 8)
        Utils.createRoundedView(view: editProfileView, borderColor: UIColor.clear, borderWidth: 1, cornerRadius: 8)
        
        self.playedChkBox.boxType = .square
        self.playedChkBox.offAnimationType = .bounce
        self.playedChkBox.onAnimationType = .bounce
        self.playedChkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        self.playedChkBox.onFillColor = UIColor.UCAColor.AppThemeColor
        self.playedChkBox.onTintColor = UIColor.UCAColor.AppThemeColor
        self.playedChkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
        
        
        priceTxtField.keyboardType = .decimalPad
        myPriceTxtField.bgColor = UIColor.white
        myPriceTxtField.getTextField()!.keyboardType = .decimalPad
        myPriceTxtField.getTextField()!.placeholderAnimation = .hidden
        
        myPriceTxtField.defaultTextAlignment = NSTextAlignment.center
        myPriceTxtField.configDivider(isDividerEnabled: false)
        
        self.addBalanceLbl.setClickDelegate(clickDelegate: self)
        self.minusBalanceLbl.setClickDelegate(clickDelegate: self)
        
        self.submitTapGue.addTarget(self, action: #selector(self.sumitUpdate))
        self.submitBtnArea.isUserInteractionEnabled = true
        self.submitBtnArea.addGestureRecognizer(submitTapGue)
        
        self.selectedDate = Date().convertDateToYMD()
        dateLbl.text = "\(Date().getDayName()), \(Date().getDayNum()) \(Date().getMonthName()) \(Date().getYear())"
        
        selectDateTapGue.addTarget(self, action: #selector(self.selectDate))
        dateSelectionView.isUserInteractionEnabled = true
        dateSelectionView.addGestureRecognizer(selectDateTapGue)
        
        transHistoryTapGue.addTarget(self, action: #selector(self.showTransactionHistory))
        self.statesSelectAreaView.isUserInteractionEnabled = true
//        self.statesSelectAreaView.addGestureRecognizer(self.transHistoryTapGue)
        
        setUserData()
        
        self.contentView.isHidden = true
        getPlayerData()
        
        profileAreaTapGue.addTarget(self, action: #selector(self.profileAreaTapped))
        self.profileSelectAreaView.isUserInteractionEnabled = true
//        self.profileSelectAreaView.addGestureRecognizer(self.profileAreaTapGue)
        
        self.paymentAreaTapGue.addTarget(self, action: #selector(self.paymentAreaTapped))
        self.paymentSelectAreaView.isUserInteractionEnabled = true
//        self.paymentSelectAreaView.addGestureRecognizer(self.paymentAreaTapGue)
        
        
        self.statesAreaTapGue.addTarget(self, action: #selector(self.statesAreaTapped))
        self.statesSelectAreaView.isUserInteractionEnabled = true
//        self.statesSelectAreaView.addGestureRecognizer(self.statesAreaTapGue)
        
        
        
        self.paymentSelectAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor
         self.profileSelectAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor
         self.statesSelectAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        
        
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
        
        let menuReportsTapGue = UITapGestureRecognizer()
        menuReportsTapGue.addTarget(self, action: #selector(self.openReport))
        
        self.menuReportImgView.isUserInteractionEnabled = true
        self.menuReportImgView.addGestureRecognizer(menuReportsTapGue)
        
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
    
    func openReport(){
        let reportsUv = GeneralFunctions.instantiateViewController(pageName: "ReportsUV")
        self.present(reportsUv, animated: true, completion: nil)
    }
    
    
    func addUser(){
        let addUserUv = GeneralFunctions.instantiateViewController(pageName: "AddUserUV")
        self.present(addUserUv, animated: true, completion: nil)
        
    }
    
    func profileAreaTapped(){
        self.paymentAreaBottomStrip.isHidden = true
        self.paymentLbl.textColor = UIColor(hex: 0xB0B0B0)
        self.statesAreaBottomStrip.isHidden = true
        self.statesLbl.textColor = UIColor(hex: 0xB0B0B0)
        
        
        self.profileAreaBottomStrip.isHidden = false
        self.profileLbl.textColor = UIColor(hex: 0xFFFFFF)
        
        self.paymentView.isHidden = true
        self.profileView.isHidden = false
        
        
        self.changePageHeight(PAGE_HEIGHT: 615)
    }
    
    func paymentAreaTapped(){
        
        self.paymentAreaBottomStrip.isHidden = false
        self.paymentLbl.textColor = UIColor(hex: 0xFFFFFF)
        self.statesAreaBottomStrip.isHidden = true
        self.statesLbl.textColor = UIColor(hex: 0xB0B0B0)
        
        
        self.profileAreaBottomStrip.isHidden = true
        self.profileLbl.textColor = UIColor(hex: 0xB0B0B0)
        
        self.profileView.isHidden = true
        self.paymentView.isHidden = false
        
        self.changePageHeight(PAGE_HEIGHT: 710)
    }
    
    func statesAreaTapped(){
        showTransactionHistory()
    }
    
    func profilePicTapped(){
        let addUserUv = GeneralFunctions.instantiateViewController(pageName: "AddUserUV") as! AddUserUV
        addUserUv.iPlayerId = self.iPlayerId
        addUserUv.userDataDict = playerDataDict
        self.present(addUserUv, animated: true, completion: nil)
    }
    
    func showTransactionHistory(){
        let reportsUv = GeneralFunctions.instantiateViewController(pageName: "ReportsUV") as! ReportsUV
        reportsUv.iPlayerId = self.iPlayerId
        self.present(reportsUv, animated: true, completion: nil)
    }
    
    func selectDate(){
        
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
            self.generalFunc.setError(uv: self, title: "", content: "Selected date cannot be greter then current date. Please select dcurrent date or date before current date.")
        }else{
            self.selectedDate = date.convertDateToYMD()
            Utils.printLog(msgData: "added:\("\(selectedDate.getDayName()), \(selectedDate.getDayNum()) \(selectedDate.getMonthName()) \(selectedDate.getYear())")::::::\(selectedDate)")
            dateLbl.text = "\(selectedDate.getDayName()), \(selectedDate.getDayNum()) \(selectedDate.getMonthName()) \(selectedDate.getYear())"
            
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.addBalanceLbl){
            incValue()
        }else if(sender == self.minusBalanceLbl){
            minusValue()
        }
    }
    
    func sumitUpdate(){
        
        self.generalFunc.setAlertMessage(uv: self, title: "", content: "Are you sure, you want to update player information for selected date?", positiveBtn: "Yes", nagativeBtn: "Cancel", completionHandler: { (btnClickedId) in
            if(btnClickedId == 0){
                self.updatePlayerData()
            }
        })
        
        //        if(self.userDataDict != nil){
        //            var balanceDataDic = [String:Any]()
        //            balanceDataDic["UserBalance"] = Utils.getText(textField: self.myPriceTxtField.getTextField()!)
        //
        //            if(loadingDialog == nil){
        //                loadingDialog = GeneralFunctions.showLoader(containerView: self.view)
        //            }else{
        //                loadingDialog.show(self, sender: nil)
        //            }
        //
        //            Database.database().reference().child("users").child("\(userDataDict.get("UserId"))").updateChildValues(balanceDataDic) { (error, reference) in
        //
        //                self.generalFunc.setAlertMessage(uv: self, title: "", content: "Information has been updated", positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
        //
        //                    self.closeCurrentScreen()
        //
        //                })
        //
        //                self.loadingDialog.hideDialog()
        //            }
        //        }
    }
    
    
    func setUserData(){
        if(playerDataDict == nil){
            currentBalance.text = Utils.currencySymbol + "0"
            self.matchesCountLbl.text = "--"
            priceTxtField.text = "0"
            myPriceTxtField.setText(text: "0")
            userPicImgView.image = UIImage(named: "ic_no_pic_user")
            userNameLbl.text = "--"
            return
        }
        userNameLbl.text = playerDataDict.get("vName")
        userMobileLbl.text = playerDataDict.get("vMobile") == "" ? "Mobile: --" : playerDataDict.get("vMobile")
        self.matchesCountLbl.text = playerDataDict.get("tMatches")
        userPicImgView.sd_setImage(with: URL(string: playerDataDict.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            if(error == nil){
                self.userPicImgView.contentMode = .scaleAspectFill
            }
        })
        
        currentBalance.text = Utils.currencySymbol + "\(playerDataDict.get("tBalance"))"
        priceTxtField.text = "3.50"
        myPriceTxtField.setText(text: "3.50")
    }
    
    func incValue(){
        myPriceTxtField.setText(text: "\(GeneralFunctions.parseDouble(origValue: 0.0, data: Utils.getText(textField: myPriceTxtField.getTextField()!)) + 1.0)")
    }
    
    func minusValue(){
        myPriceTxtField.setText(text: "\(GeneralFunctions.parseDouble(origValue: 0.0, data: Utils.getText(textField: myPriceTxtField.getTextField()!)) - 1.0)")
    }
    
    func getPlayerData(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        
        self.contentView.isHidden = true
        
        let parameters = ["type":"getPlayerData", "iPlayerId": self.iPlayerId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let msgDict = dataDict.getObj("message")
                    
                    self.playerDataDict = msgDict
                    self.setUserData()
                    self.contentView.isHidden = false
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
                self.generalFunc.setAlertMessage(uv: self, title: "", content: InternetConnection.isConnectedToNetwork() ? "Some problem occurred." : "No Internet Connection", positiveBtn: "Retry", nagativeBtn: "", completionHandler: { (btnClickedId) in
                    
                    self.getPlayerData()
                    
                })
            }
            
            self.loaderView.isHidden = true
        })
    }
    
    
    func updatePlayerData(){
        
        let parameters = ["type":"updatePlayerInformation", "iPlayerId": self.iPlayerId, "adjustedBalance": Utils.getText(textField: self.myPriceTxtField.getTextField()!), "matchPlayed": self.playedChkBox.on ? "Yes" : "No", "selctedDate": self.selectedDate, "vTimeZone": DateFormatter().timeZone.identifier]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            Utils.printLog(msgData: "response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: "PLAYER_INFO_UPDATED", value: "Yes" as AnyObject)
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: dataDict.get("message"), positiveBtn: "Ok", nagativeBtn: "", completionHandler: { (btnClickedId) in
                        self.closeCurrentScreen()
                    })
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
                self.generalFunc.setAlertMessage(uv: self, title: "", content: InternetConnection.isConnectedToNetwork() ? "Some problem occurred." : "No Internet Connection", positiveBtn: "Ok", nagativeBtn: "", completionHandler: { (btnClickedId) in
                    
                })
            }
            
        })
    }
}
