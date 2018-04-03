//
//  AddUserUV.swift
//  Football
//
//  Created by Ravi on 22/09/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit
import Firebase

class AddUserUV: UIViewController, MyBtnClickDelegate, OnUserSelectDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bgView: GradientView!
    @IBOutlet weak var closeImgView: UIImageView!
    @IBOutlet weak var editImgView: UIImageView!
    @IBOutlet weak var editImgViewArea: UIView!
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var profilePicArea: UIView!
    @IBOutlet weak var mobileTxtField: MyTextField!
    @IBOutlet weak var nameTxtField: MyTextField!
    @IBOutlet weak var submitBtn: MyButton!
    
    @IBOutlet weak var menuAreaView: GradientView!
    @IBOutlet weak var menuSearchView: UIView!
    @IBOutlet weak var menuAddView: UIView!
    @IBOutlet weak var menuReportView: UIView!
    @IBOutlet weak var menuAddImgView: UIImageView!
    @IBOutlet weak var menuSearchImgView: UIImageView!
    @IBOutlet weak var menuReportImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var openImgSelection:OpenImageSelectionOption!
    let photoImgTapGue = UITapGestureRecognizer()
    
    var loadingDialog:NBMaterialLoadingDialog!
    
    var selectedImage:UIImage!
    
    var iPlayerId = ""
    var userDataDict:NSDictionary!
    
    var cntView:UIView!
    
    var isPageSet = false
    
    override func viewDidLayoutSubviews() {
        if(isPageSet == false){
            
            if(cntView != nil){
                cntView.frame = self.contentView.frame
                
            }
            isPageSet = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "AddUserScreenDesign", uv: self)
//        cntView.frame.size = CGSize(width: Application.screenSize.width, height: Application.screenSize.height - 60)
        self.contentView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        
        menuAreaView.colors = [UIColor.white, UIColor.white]
        menuAreaView.direction = .horizontal
        menuAreaView.locations = [0.40, 0.20]
        
        
        GeneralFunctions.setImgTintColor(imgView: menuAddImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuSearchImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: menuReportImgView, color: UIColor(hex: 0x272727))
        
        Utils.createRoundedView(view: profilePicArea, borderColor: UIColor.UCAColor.AppThemeTxtColor_1, borderWidth: 4)
        Utils.createRoundedView(view: profilePicImgView, borderColor: UIColor.UCAColor.AppThemeColor_1, borderWidth: 1)
        Utils.createRoundedView(view: editImgViewArea, borderColor: UIColor.UCAColor.AppThemeColor_1, borderWidth: 2)
        
        GeneralFunctions.setImgTintColor(imgView: editImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
        GeneralFunctions.setImgTintColor(imgView: closeImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
        
        Utils.createRoundedView(view: editImgViewArea, borderColor: UIColor.clear, borderWidth: 0)
        editImgViewArea.backgroundColor = UIColor.UCAColor.AppThemeColor_1.lighter(by: 2)
        nameTxtField.setPlaceHolder(placeHolder: "Enter Name")
        mobileTxtField.setPlaceHolder(placeHolder: "Enter mobile no.")
        submitBtn.setButtonTitle(buttonTitle: "Add Player")
        Utils.createRoundedView(view: submitBtn, borderColor: UIColor.UCAColor.AppThemeTxtColor_1, borderWidth: 2, cornerRadius: 10)
        
        nameTxtField.changeAllColor(color: UIColor.white)
        mobileTxtField.changeAllColor(color: UIColor.white)
        
        mobileTxtField.getTextField()!.keyboardType = .numberPad
        
        closeImgView.isUserInteractionEnabled = true
        
        let closeTapGue = UITapGestureRecognizer()
        closeTapGue.addTarget(self, action: #selector(self.closeCurrentScreen))
        
        closeImgView.addGestureRecognizer(closeTapGue)
        
        
        bgView.colors = [UIColor.UCAColor.AppThemeColor.lighter(by: 12)!, UIColor.UCAColor.AppThemeColor.lighter(by: 8)!]
        bgView.mode = .linear
        bgView.direction = .vertical
        bgView.locations = [0.91, 0.45]
        
        submitBtn.clickDelegate = self
        
        photoImgTapGue.addTarget(self, action: #selector(self.photoImgTapped))
        profilePicArea.isUserInteractionEnabled = true
        profilePicArea.addGestureRecognizer(photoImgTapGue)
        profilePicImgView.image = UIImage(named: "ic_no_pic_user")
        
        if(self.userDataDict != nil){
            self.nameTxtField.setText(text: userDataDict.get("vName"))
            self.mobileTxtField.setText(text: userDataDict.get("vMobile"))
            
            
            self.profilePicImgView.sd_setImage(with: URL(string: userDataDict.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
            })
        }
        
        if(self.iPlayerId != ""){
            self.submitBtn.setButtonTitle(buttonTitle: "Update Player")
        }
        
        let menuSearchTapGue = UITapGestureRecognizer()
        
        menuSearchTapGue.addTarget(self, action: #selector(self.searchUsers))
        
        self.menuSearchImgView.isUserInteractionEnabled = true
        self.menuSearchImgView.addGestureRecognizer(menuSearchTapGue)
        
        
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

    func photoImgTapped(){
        
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.isPhotoChoose = true
        
        self.openImgSelection.setImageSelectionHandler { (isImageSelected) in
            if(isImageSelected){
                self.selectedImage = self.openImgSelection.selectedImage.cropTo(size: CGSize(width: Utils.ImageUpload_DESIREDWIDTH, height: Utils.ImageUpload_DESIREDHEIGHT)).resize(toWidth: Utils.ImageUpload_DESIREDWIDTH)
                self.profilePicImgView.image = self.selectedImage
            }
        }
        self.openImgSelection.show { (isImageUpload) in
            if(isImageUpload == true){
                
                
            }
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitBtn){
            
            DispatchQueue.main.async() {
                self.checkValues()
            }
        }
    }

    func checkValues(){
       let required_str = "Required"
        let mobileInvalid = "Invalid mobile no."
        let nameError = "Please enter player name"
        let mobileError = "Please enter player mobile number."
        
        let nameEntered = Utils.checkText(textField: self.nameTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.nameTxtField.getTextField()!, error: nameError)
        
        var mobileEntered = Utils.checkText(textField: self.mobileTxtField.getTextField()!) ? (Utils.getText(textField: self.mobileTxtField.getTextField()!).characters.count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: mobileInvalid)) : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: mobileError)
        mobileEntered = true
        if (nameEntered == false || mobileEntered == false) {
            return;
        }
        
        self.registerUserToServer()
        
    }
    
    func registerUserToServer(){
        let parameters = ["type":"addPlayer","vName": Utils.getText(textField: nameTxtField.getTextField()!), "vMobile": Utils.getText(textField: mobileTxtField.getTextField()!), "tBalance": "0", "tMatches": "0", "iPlayerId": iPlayerId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        
        if(self.selectedImage != nil){
            exeWebServerUrl.uploadImage(image: self.selectedImage, completionHandler: { (response) in
                
                Utils.printLog(msgData: "responseImgUpload::\(response)")
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.iPlayerId == "" ? "Player has been added" : "Player information has been updated.", positiveBtn: "OK", nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if(self.iPlayerId != ""){
                                GeneralFunctions.saveValue(key: "LOAD_PLAYER_DETAILS", value: "true" as AnyObject)
                            }
                            GeneralFunctions.saveValue(key: "LOAD_PLAYER_LIST_HOME", value: "true" as AnyObject)
                            self.closeCurrentScreen()
                            
                        })
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
        }else{
            
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                Utils.printLog(msgData: "responseAdd::\(response)")
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.iPlayerId == "" ? "Player has been added" : "Player information has been updated.", positiveBtn: "OK", nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if(self.iPlayerId != ""){
                                GeneralFunctions.saveValue(key: "LOAD_PLAYER_DETAILS", value: "true" as AnyObject)
                            }
                            
                            GeneralFunctions.saveValue(key: "LOAD_PLAYER_LIST_HOME", value: "true" as AnyObject)
                            self.closeCurrentScreen()
                            
                        })
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
