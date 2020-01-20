//
//  MSConstants.swift
//  MarleySpoon
//
//  Created by rao on 18/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import Contentful
import MBProgressHUD

let contentFullSpaceId = "kk2bw5ojx476"
let contentFullAccessId = "7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c"
let defaultContentTypeClasses: [EntryDecodable.Type] = [MSRecipe.self, MSChef.self, MSTag.self]
let logoImageView = UIImageView(image:UIImage(named: "navBarLogo.png"))

let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

extension UIViewController {
    
    //    - Description: Presents alert view controller
    //    - Parameters: message: String, btnTitleOne: String, btnTitleTwo: String (Can be nil), completionOk: Action Block (Can be nil), cancel: Action Block (Can be nil), title: String? = nil)
    //    - Returns: Void
    func showAlertViewWithBlock(message: String,btnTitleOne: String, btnTitleTwo: String? = "", completionOk: (() -> Void)? = nil, cancel:(() -> Void)? = nil, title: String? = nil) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: btnTitleOne, style: .default, handler: { (alertAction) -> Void in
            if let completionBlock = completionOk {
                completionBlock()
            }
        }))
        
        if !"\(btnTitleTwo ?? "")".isEmpty {
            alertView.addAction(UIAlertAction(title: btnTitleTwo, style: .cancel, handler: { (alertAction) -> Void in
                if let cancelBlock = cancel {
                    cancelBlock()
                }
            }))
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    
    func hideProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
