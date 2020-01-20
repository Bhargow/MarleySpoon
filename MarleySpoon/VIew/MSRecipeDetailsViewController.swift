//
//  MSRecipeDetailsViewController.swift
//  MarleySpoon
//
//  Created by rao on 19/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class MSRecipeDetailsViewController: UIViewController {

    @IBOutlet var recipeImg : MSDownloadableImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var lblChef : UILabel!
    @IBOutlet var lblTags : UILabel!
    
    var recipeDetailsViewModel: MSRecipeDetailsViewModel!
    
// MARK: View Lifecycle Methods
    override func viewDidLoad() {
        
        self.navigationItem.titleView = logoImageView
        
        let backButton = UIBarButtonItem(image: UIImage(named: "btnBack"), style: .plain, target: self, action: #selector(self.btnBackPressedPressed(_:)))
        backButton.tintColor = UIColor(red: 252.0/255.0, green: 215.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        navigationItem.leftBarButtonItem = backButton
        
        setUpViewContent()
        showProgress()
    }
    
    //    - Description: Sets up view components with all the data from the view model
    //    - Parameters: None
    //    - Returns: Void
    func setUpViewContent() {
        lblTitle.text = recipeDetailsViewModel.recipe.title
        lblDescription.text = recipeDetailsViewModel.recipe.description
        lblChef.text = recipeDetailsViewModel.chefName.isEmpty ? "" : "by \(recipeDetailsViewModel.chefName)"
        lblTags.text = recipeDetailsViewModel.tagsString.isEmpty ? "" : recipeDetailsViewModel.tagsString
        if let imgUrl = recipeDetailsViewModel.recipe.photo {
            recipeImg.imgUrl = imgUrl
        }
    }
    
// MARK: Action Handler Methods
    @objc func btnBackPressedPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: MSViewModel Delegate Methods
extension MSRecipeDetailsViewController: MSViewModelDelegate {
    func shouldRefreshContentViews() {
        DispatchQueue.main.async {
            self.hideProgress()
            self.setUpViewContent()
        }
    }
    
    func shouldShowError(error: String) {
        DispatchQueue.main.async {
        self.hideProgress()
        !error.isEmpty ? self.showAlertViewWithBlock(message: error, btnTitleOne: "Ok") : print("")
        }
    }
}
