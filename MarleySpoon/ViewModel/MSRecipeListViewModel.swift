//
//  MSRecipeListViewModel.swift
//  MarleySpoon
//
//  Created by rao on 18/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

protocol MSViewModelDelegate {
    func shouldRefreshContentViews()
    func shouldShowError(error: String)
}

class MSRecipeListViewModel: NSObject {
    var recipes: [MSRecipe] {
        didSet {
            delegate?.shouldRefreshContentViews()
        }
    }
    var delegate: MSViewModelDelegate?
    let recipesProvider: MSRecipesProvider
    
    init(recipes: [MSRecipe] = [], delegate: MSViewModelDelegate? = nil, recipesProvider: MSRecipesProvider = MSRecipesProvider()) {
        self.recipes = recipes
        self.delegate = delegate
        self.recipesProvider = recipesProvider
    }
    
    //    - Description: Get recipes from content provider and sets data to recipes which will tirgger the delegate's shouldRefreshContentViews method
    //    - Parameters: None
    //    - Returns: Void
    func getRecipes(success: ((_ recipes: [MSRecipe]) -> Void)? = nil, errorOccured: ((_ error: String) -> Void)? = nil) {
        recipesProvider.getRecipesFromContentFull(success: {[weak self] (recipes) in
            self?.recipes = recipes
            success?(recipes)
        }) { (error) in
            self.delegate?.shouldShowError(error: error)
            errorOccured?(error)
        }
    }
}
