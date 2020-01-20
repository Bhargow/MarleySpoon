//
//  MSRecipeListTableViewCell.swift
//  MarleySpoon
//
//  Created by rao on 17/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class MSRecipeListTableViewCell: UITableViewCell {
    
    var recipeViewModel: MSRecipeCellViewModel! {
        didSet {
            setupView()
        }
    }
    
    @IBOutlet var recipeImg : MSDownloadableImageView!
    @IBOutlet var lblTitle : UILabel!

    //    - Description: Sets up tableview cell with all the data from the view model
    //    - Parameters: None
    //    - Returns: Void
    func setupView() {
        lblTitle.text = recipeViewModel.recipe.title
        if let imgUrl = recipeViewModel.recipe.photo {
            recipeImg.imgUrl = imgUrl
        }
    }
}
