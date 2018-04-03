//
//  Utils.swift
//  DriverApp
//
//  Created by NEW MAC on 03/12/16.
//  Copyright © 2016 BBCS. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static let deviceType = "Ios"
    
    static let currencySymbol = "£"

    static let googleMapLangCodeKey = "GOOGLE_MAP_LNG_CODE"
    static let deviceTokenKey = "DEVICE_TOKEN"
    
    static let appUserType = ""
     static let isUserLogIn = "IsUserLoggedIn"
     static let iMemberId_KEY = "iMemberId"
    
     static let action_str = "Action"
     static let message_str = "message"
    
    static let apnIDNotificationKey = "in.ApnId"
    static let DATABASE_RTL_STR = "rtl";
    
    static let dateFormateInHeaderBar = "EEE, MMM d, yyyy"
    static let dateFormateInList = "dd-MMM-yyyy"
    static let dateFormateTimeOnly = "h:mm a"
    static let dateFormateWithTime = "EEE, MMM dd, yyyy' at 'h:mm a"
    
    
    static let LANGUAGE_CODE_KEY = "LANG_CODE"
    static let LANGUAGE_IS_RTL_KEY = "LANG_IS_RTL"
    static let GOOGLE_MAP_LANGUAGE_CODE_KEY = "GOOGLE_MAP_LANG_CODE"
    
    static let USER_PROFILE_DICT_KEY = "USER_PROFILE_DICT"
    
    
    static let rtlLangTypeKey = "isRTL"
    static let DRIVER_REQ_CODE_PREFIX_KEY = "REQUEST_CODE_"
    
    static let ImageUpload_DESIREDWIDTH:CGFloat = 1024
    static let ImageUpload_DESIREDHEIGHT:CGFloat = 1024
    static let ImageUpload_MINIMUM_WIDTH:CGFloat = 256
    static let ImageUpload_MINIMUM_HEIGHT:CGFloat = 256
    
    static let minPasswordLength = 6
    static let minMobileLength = 3
    
    static var driverMarkersPositionList = [NSDictionary]()
    static var driverMarkerAnimFinished = true
    
    static func applicationVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
   static func applicationBuild() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
   static func versionBuild() -> String {
        
        let version = applicationVersion()
        let build = applicationBuild()
        
        return "v\(version)(\(build))"
    }
    
    static func checkText(textField:UITextField) -> Bool{
        if(getText(textField: textField).trim() == ""){
            return false
        }
        
        return true
    }
    
    static func getText(textField:UITextField) -> String{
        return textField.text!
    }
    
    static func setErrorFields(textField:ErrorTextField, error:String) -> Bool{
        textField.detail = error
        textField.isErrorRevealed = true
        
        
        return false
    }
    
    static func createRoundedView(view:UIView, borderColor:UIColor, borderWidth:CGFloat){
        view.layer.cornerRadius = view.frame.size.width / 2;
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
    static func createRoundedView(view:UIView, borderColor:UIColor, borderWidth:CGFloat, cornerRadius:CGFloat){
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
    
    static func createBoarderedView(view:UIView, borderColor:UIColor, borderWidth:CGFloat){
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
    
    static func printNsData(someNSData:Data){
        let theString:NSString = NSString(data: someNSData, encoding: String.Encoding.utf8.rawValue)!
//        print(theString)
        
        Utils.printLog(msgData: theString.description)
    }
    
    static func showSnakeBar(msg:String, uv:UIViewController){
        
        guard let snackbar = uv.snackbarController?.snackbar else {
            return
        }
        
        snackbar.text = msg
        
        snackbar.rightViews = [UIView()]
        _ = uv.snackbarController?.animate(snackbar: .visible, delay: 1)
        _ = uv.snackbarController?.animate(snackbar: .hidden, delay: 4)
    }
    
    static func showSnakeBar(msg:String, uv:UIViewController, btnTitle:String, delayShow:TimeInterval, delayHide:TimeInterval) -> FlatButton{
        
        var actionButton = FlatButton()
        guard let snackbar = uv.snackbarController?.snackbar else {
            return actionButton
        }
        
        snackbar.text = msg
        
        
        if(btnTitle != ""){
            
            actionButton = FlatButton(title: btnTitle, titleColor: Color.yellow.base)
            actionButton.pulseAnimation = .backing
            actionButton.titleLabel?.font = uv.snackbarController?.snackbar.textLabel.font
            
            snackbar.rightViews = [actionButton]
        }
        _ = uv.snackbarController?.animate(snackbar: .visible, delay: delayShow)
        _ = uv.snackbarController?.animate(snackbar: .hidden, delay: delayHide)
        
        return actionButton
    }
    
//    static func updateMarker(marker:GMSMarker,googleMap:GMSMapView, coordinates: CLLocationCoordinate2D, rotationAngle: Double, duration: Double) {
//        // Keep Rotation Short
////        CATransaction.begin()
////        CATransaction.setAnimationDuration(0.5)
////        marker.rotation = rotationAngle
////        CATransaction.commit()
//        
//        // Movement
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(duration)
//        marker.position = coordinates
//        
//        // Center Map View
//        //        let camera = GMSCameraUpdate.setTarget(coordinates)
//        //        googleMap.animate(with: camera)
//        
//        CATransaction.commit()
//    }
    
        
    static func appLaunchImage() -> UIImage
    {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        
        for imageName in allPngImageNames
        {
            guard imageName.contains("LaunchImage") else { continue }
            
            guard let image = UIImage(named: imageName) else { continue }
            
            // if the image has the same scale AND dimensions as the current device's screen...
            
            if (image.scale == UIScreen.main.scale) && (image.size.equalTo(UIScreen.main.bounds.size))
            {
                return image
            }
        }
        
        switch UIDevice().type {
        case .iPhone4:
            return UIImage(named: "ic_launch@640x960")!
        case .iPhone4S:
            return UIImage(named: "ic_launch@640x960")!
        case .iPhone5:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhone5S:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhone6:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone6plus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhone6S:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone6Splus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhone7:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone7plus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhoneSE:
            return UIImage(named: "ic_launch@640x1136")!
        default:
            return UIImage(named: "ic_launch")!
        }
    }
    
    static func getCurrentDateInAppLocal(dateFormat:String, timeZone:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .gregorian)
        let date = Date()
        formatter.timeZone = TimeZone(identifier: timeZone)
        let dateInGrogrian = formatter.string(from: date)
        
        let appLocalDate = Utils.convertDateGregorianToAppLocale(date: dateInGrogrian, dateFormate: dateFormat)
        
        return appLocalDate
    }
    
    static func convertStringToDate(dateStr:String, dateFormat:String) -> Date{
        let finalFormatter = DateFormatter()
        finalFormatter.dateFormat = dateFormat
        let finalDate = finalFormatter.date(from: dateStr)
        
        return finalDate!
    }
    
    static func convertDateFormateInAppLocal(date:Date, toDateFormate:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = toDateFormate
        
        formatter.locale = Locale(identifier: Configurations.getGoogleMapLngCode())
        
        return formatter.string(from: date)
    }
    
    static func convertDateGregorianToAppLocale(date:String, dateFormate:String) -> Date{
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormate
        formatter.calendar = Calendar(identifier: .gregorian)
        let dateInGrogrian = formatter.date(from: date)
        
        
        formatter.calendar = Calendar(identifier: Configurations.getCalendarIdentifire())
        
        let dateStr = formatter.string(from: dateInGrogrian!)
        
        return Utils.convertStringToDate(dateStr: dateStr, dateFormat: dateFormate)
    }
    
    static func getCurrentDateInGrogrian(dateFormat:String, timeZone:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .gregorian)
        let date = Date()
        formatter.timeZone = TimeZone(identifier: timeZone)
        let dateInGrogrian = formatter.string(from: date)
        
        return convertStringToDate(dateStr: dateInGrogrian, dateFormat: dateFormat)
    }
    
    static func printLog(msgData:String){
        print(msgData)
    }
    
    static func currentTimeMillis() -> Int64{
        let nowDouble = Date().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    static func isMyAppInBackground() -> Bool{
        let state: UIApplicationState = UIApplication.shared.applicationState
        
        if state == UIApplicationState.background {
            return true
        }
        else{
            return false
        }
        //        else if state == UIApplicationState.Active {
        //
        //            return false
        //        }
    }
    
    
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
        
    static func resetAppNotifications(){
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
//    static func convertDateToString(date:Date, dateFormate:String) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormate
//        return dateFormatter.string(from: date)
//    }
//    
//    static func convertStringToDate(date:String, dateFormate:String) -> Date{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormate
//        return dateFormatter.date(from: date)!
//    }
//    
//    static func convertDateToTimeZone(date:String, dateFormate:String, fromTimeZone:String, toTimeZone:String){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormate
//        dateFormatter.timeZone = TimeZone(abbreviation: fromTimeZone)
//        
//        let date = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: toTimeZone)
//        dateFormatter.dateFormat = dateFormate
//        
//        print("BeforeStringDate:\(date)")
//        let dt = dateFormatter.string(from: date!)
//        print("AfterStringDate:\(dt)")
//        
//    }
//    static func localToUTC(date:String, dateFormat:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.calendar = NSCalendar.current
//        dateFormatter.timeZone = TimeZone.current
//        
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        return dateFormatter.string(from: dt!)
//    }
//    
//    static func UTCToLocal(date:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "H:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "h:mm a"
//        
//        return dateFormatter.string(from: dt!)
//    }
    
    static func closeKeyboard(uv:UIViewController?){
        if (Application.window != nil)
        {
            Application.window?.endEditing(true)
        }
        else if(uv != nil)
        {
            uv!.view.endEditing(true)
        }
    }
}
