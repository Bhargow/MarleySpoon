//
//  ViewController.swift
//  MarleySpoon
//
//  Created by rao on 13/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class MSRecipesListViewController: UIViewController {
    var recipeListViewModel: MSRecipeListViewModel!
    
    @IBOutlet var tblViewRecipes: UITableView!
    @IBOutlet var tblViewRecipesHeader: UIView!
    
// MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = logoImageView
        
        showProgress()
        
        recipeListViewModel = MSRecipeListViewModel.init(delegate: self)
        recipeListViewModel.getRecipes()
    }
}

// MARK: TableView Delegate Methods
extension MSRecipesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipeListViewModel.recipes[indexPath.row]
        let recipesDetailsViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MSRecipeDetailsViewController") as! MSRecipeDetailsViewController
        let recipeDetailsViewModel = MSRecipeDetailsViewModel(delegate: recipesDetailsViewController)
        recipesDetailsViewController.recipeDetailsViewModel =  recipeDetailsViewModel
        recipesDetailsViewController.recipeDetailsViewModel.recipe = recipe
        
        self.navigationController?.pushViewController(recipesDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tblViewRecipesHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: TableView DataSource Methods
extension MSRecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeListViewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            "MSRecipeListTableViewCell", for: indexPath) as? MSRecipeListTableViewCell {
            let cellData = recipeListViewModel.recipes[indexPath.row]
            cell.recipeViewModel = MSRecipeCellViewModel(recipe: cellData)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: MSViewModel Delegate Methods
extension MSRecipesListViewController: MSViewModelDelegate {
    func shouldRefreshContentViews() {
        DispatchQueue.main.async {
            self.hideProgress()
            self.tblViewRecipes.reloadData()
        }
    }
    
    func shouldShowError(error: String) {
        DispatchQueue.main.async {
            self.hideProgress()
            self.showAlertViewWithBlock(message: error, btnTitleOne: "Ok")
        }
    }
}
