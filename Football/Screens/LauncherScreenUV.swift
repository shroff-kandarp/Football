//
//  LauncherScreenUV.swift
//  DriverApp
//
//  Created by NEW MAC on 04/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class LauncherScreenUV: UIViewController, OnLocationUpdateDelegate {

    @IBOutlet weak var indicatorView: DGActivityIndicatorView!
    @IBOutlet weak var bgImgView: UIImageView!
    let generalFunc = GeneralFunctions()
    
    var getLocation:GetLocation!
    var locationDialog:MTDialog!

    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.addSubview(self.generalFunc.loadView(nibName: "LauncherScreenDesign", uv: self))
        
        GeneralFunctions.removeValue(key: "PLAYER_INFO_UPDATED")
        
//        self.bgImgView.image = UIImage(named: "ic_launch")
        self.bgImgView.image = Utils.appLaunchImage()
        
        indicatorView.type = .ballPulse
        indicatorView.tintColor = UIColor.UCAColor.AppThemeTxtColor
        indicatorView.size = 50
        indicatorView.startAnimating()
        
        continueProcess()
        
    }
//    isOtherButton
    func continueProcess(){
        
        if(InternetConnection.isConnectedToNetwork() == false){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "No Internet Connection", positiveBtn: "Retry", nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.continueProcess()
            })
            
            return
        }
        
        if(Configurations.isUserLoggedIn() == false){
            downloadData()
        }else{
            autoLogin()
        }
    }

    func downloadData(){
        
    }
    
    func appInForground(){
        self.autoLogin()
    }
    
    func addBackgroundObserver(){
        
    }
    
    func autoLogin(){
        
    }
}
