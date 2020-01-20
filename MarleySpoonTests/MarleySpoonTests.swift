//
//  MarleySpoonTests.swift
//  MarleySpoonTests
//
//  Created by rao on 13/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest
@testable import MarleySpoon

class MarleySpoonTests: XCTestCase {
    
    var storyboard: UIStoryboard?

    var recipesListViewController: MSRecipesListViewController!
    var recipeListTableViewCell: MSRecipeListTableViewCell!
    var recipeDetailsViewController: MSRecipeDetailsViewController!
    
    var recipeListViewModel: MSRecipeListViewModel!
    var recipeDetailsViewModel: MSRecipeDetailsViewModel!
    
    var expectation: XCTestExpectation = XCTestExpectation(description: "RecipeListViewModelExpectation")

    
    override func setUp() {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MSRecipesListViewController = storyboard?.instantiateViewController(withIdentifier: "MSRecipesListViewController") as! MSRecipesListViewController
        recipesListViewController = vc
        
        let detailsVc: MSRecipeDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "MSRecipeDetailsViewController") as! MSRecipeDetailsViewController
        recipeDetailsViewController = detailsVc
    }

    override func tearDown() {
        storyboard = nil
        recipesListViewController = nil
        recipeDetailsViewController = nil
        recipeListViewModel = nil
        recipeDetailsViewModel = nil
    }
    
// MARK: MSRecipesProvider Tests
    func testRecipesProviderPosivte() {
        let recipesProvider = MSRecipesProvider(spaceId: contentFullSpaceId, accessToken: contentFullAccessId, contentTypeClasses: defaultContentTypeClasses)
        
        recipesProvider.getRecipesFromContentFull(success: { (recipes) in
            self.expectation.fulfill()
            XCTAssertNotNil(recipes)
        }) { (err) in
            self.expectation.fulfill()
            XCTFail()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testRecipesProviderNegative() {
        let wrongContentFullSpaceId = "kk2bw5ojx490"
        let wrongContentFullAccessId = "7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84d"
        
        let recipesProvider = MSRecipesProvider(spaceId: wrongContentFullSpaceId, accessToken: wrongContentFullAccessId, contentTypeClasses: defaultContentTypeClasses)
        recipesProvider.getRecipesFromContentFull(success: { (recipes) in
            self.expectation.fulfill()
            XCTFail()
        }) { (err) in
            self.expectation.fulfill()
            XCTAssertNotNil(err)
        }
        wait(for: [expectation], timeout: 10)
    }
    
// MARK: MSRecipeListViewModel Tests
    func testRecipeListViewModelPositive() {
        let recipesProvider = MSRecipesProvider()
        recipeListViewModel = MSRecipeListViewModel(recipesProvider: recipesProvider)
        recipeListViewModel.getRecipes(success: { (recipes) in
            XCTAssertNotNil(self.recipeListViewModel.recipes)
            self.expectation.fulfill()
        }) { (error) in
            XCTAssertNotNil(error)
            XCTFail()
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testRecipeListViewModelNegative() {
        let wrongContentFullSpaceId = "kk2bw5ojx490"
        let wrongContentFullAccessId = "7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84d"
        let recipesProvider = MSRecipesProvider.init(spaceId: wrongContentFullSpaceId, accessToken: wrongContentFullAccessId)
        recipeListViewModel = MSRecipeListViewModel(recipesProvider: recipesProvider)
        recipeListViewModel.getRecipes(success: { (recipes) in
            XCTAssertNil(self.recipeListViewModel.recipes)
            self.expectation.fulfill()
            XCTFail()
        }) { (err) in
            self.expectation.fulfill()
            XCTAssertNotNil(err)
        }
        wait(for: [expectation], timeout: 10)
    }

    // MARK: MSRecipeDetailsViewModel Tests
    func testRecipeDetailsViewModelPositive() {
        let chefExpectation = XCTestExpectation.init(description: "Chef Expectation")
        let tagExpectation = XCTestExpectation.init(description: "Tag Expectation")
        
        let recipeDetailsViewModel: MSRecipeDetailsViewModel = MSRecipeDetailsViewModel()
        recipeDetailsViewModel.recipe = self.getMockPositiveRecipe()
        
        XCTAssertNotNil(recipeDetailsViewModel.recipe.title)
        XCTAssertNotNil(recipeDetailsViewModel.recipe.description)
        XCTAssertFalse(recipeDetailsViewModel.recipe.calories == 0)
        XCTAssertNotNil(recipeDetailsViewModel.recipe.photo)
        XCTAssertNotNil(recipeDetailsViewModel.recipe.chef)
        XCTAssertNotNil(recipeDetailsViewModel.recipe.tags)
        
        recipeDetailsViewModel.getChefName(success: { (chef) in
            chefExpectation.fulfill()
            XCTAssertNotNil(recipeDetailsViewModel.chef)
            XCTAssertTrue(recipeDetailsViewModel.chefName == "Mark Zucchiniberg ")
        }) { (error) in
            chefExpectation.fulfill()
            XCTFail()
        }
                
        recipeDetailsViewModel.getTags(success: { (tags) in
            tagExpectation.fulfill()
            XCTAssertNotNil(recipeDetailsViewModel.tags)
            XCTAssertFalse(recipeDetailsViewModel.tags.isEmpty)
            XCTAssertTrue(recipeDetailsViewModel.tagsString == "vegan, healthy")
        }) { (error) in
            tagExpectation.fulfill()
            XCTFail()
        }
        
        wait(for: [chefExpectation, tagExpectation], timeout: 10)
    }
    
    
    func testRecipeDetailsViewModelNegative() {
        let chefExpectation = XCTestExpectation.init(description: "Chef Expectation")
        let tagExpectation = XCTestExpectation.init(description: "Tag Expectation")
        
        let recipeDetailsViewModel: MSRecipeDetailsViewModel = MSRecipeDetailsViewModel()
        recipeDetailsViewModel.recipe = self.getMockNegativeRecipe()
        
        XCTAssertNil(recipeDetailsViewModel.recipe.title)
        XCTAssertNil(recipeDetailsViewModel.recipe.description)
        XCTAssertTrue(recipeDetailsViewModel.recipe.calories == 0)
        XCTAssertNil(recipeDetailsViewModel.recipe.photo)
        XCTAssertNil(recipeDetailsViewModel.recipe.chef)
        XCTAssertNil(recipeDetailsViewModel.recipe.tags)
        
        
        recipeDetailsViewModel.getChefName(success: { (chef) in
            chefExpectation.fulfill()
            XCTFail()
        }) { (error) in
            chefExpectation.fulfill()
            XCTAssertNotNil(error)
        }
        
        recipeDetailsViewModel.getTags(success: { (tags) in
            tagExpectation.fulfill()
            XCTFail()
        }) { (error) in
            tagExpectation.fulfill()
            XCTAssertNotNil(error)
        }
        wait(for: [chefExpectation, tagExpectation], timeout: 10)
    }
    
    // MARK: MSRecipeDetailsViewController Tests
    func testRecipeDetailsViewControllerPositive() {
        let chefExpectation = XCTestExpectation.init(description: "Chef Expectation")
        let tagExpectation = XCTestExpectation.init(description: "Tag Expectation")
        
        self.recipeDetailsViewController.recipeDetailsViewModel = MSRecipeDetailsViewModel(delegate: self.recipeDetailsViewController)
        self.recipeDetailsViewController.recipeDetailsViewModel.recipe = self.getMockPositiveRecipe()
        _ = self.recipeDetailsViewController.view
        
        XCTAssertTrue(self.recipeDetailsViewController.lblTitle.text == "Beautiful courgette carbonara")
        XCTAssertTrue(self.recipeDetailsViewController.lblDescription.text == "Carbonara is a classic pasta sauce made with cream, bacon and Parmesan and is absolutely delicious. I've added gorgeous courgettes for a summery twist. Try to buy the best ingredients you can, as that’s what really helps to make this dish amazing. I’m using a flowering variety of thyme but normal thyme is fine to use. When it comes to the type of pasta, you can serve carbonara with spaghetti or linguine, but I’ve been told by Italian mammas (who I don’t argue with!) that penne is the original, so that’s what I’m using in this recipe. Before you start cooking, it’s important to get yourself a very large pan, or use a high-sided roasting tray so you can give the pasta a good toss.")
        XCTAssertNotNil(self.recipeDetailsViewController.recipeImg.imageView.image)
        
        let result = XCTWaiter.wait(for: [chefExpectation, tagExpectation], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(self.recipeDetailsViewController.recipeDetailsViewModel.chef)
            XCTAssertTrue(self.recipeDetailsViewController.lblChef.text == "by Mark Zucchiniberg ")
            XCTAssertNotNil(self.recipeDetailsViewController.recipeDetailsViewModel.tags) 
            XCTAssertTrue((self.recipeDetailsViewController.lblTags.text?.contains("healthy"))!)
            XCTAssertTrue((self.recipeDetailsViewController.lblTags.text?.contains("vegan"))!)
            chefExpectation.fulfill()
            tagExpectation.fulfill()
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testRecipeDetailsViewControllerNegative() {
        let chefExpectation = XCTestExpectation.init(description: "Chef Expectation")
        let tagExpectation = XCTestExpectation.init(description: "Tag Expectation")
        
        self.recipeDetailsViewController.recipeDetailsViewModel = MSRecipeDetailsViewModel(delegate: self.recipeDetailsViewController)
        self.recipeDetailsViewController.recipeDetailsViewModel.recipe = self.getMockNegativeRecipe()
        _ = self.recipeDetailsViewController.view
        
        XCTAssertNil(self.recipeDetailsViewController.lblTitle.text)
        XCTAssertNil(self.recipeDetailsViewController.lblDescription.text)
        XCTAssertNil(self.recipeDetailsViewController.recipeImg.imageView.image)
        
        let result = XCTWaiter.wait(for: [chefExpectation, tagExpectation], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNil(self.recipeDetailsViewController.recipeDetailsViewModel.chef)
            XCTAssertTrue(self.recipeDetailsViewController.lblChef.text == "")
            XCTAssertTrue(self.recipeDetailsViewController.recipeDetailsViewModel.tags.isEmpty)
            XCTAssertTrue(self.recipeDetailsViewController.lblTags.text == "")
            chefExpectation.fulfill()
            tagExpectation.fulfill()
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    // MARK: MSRecipesListViewController Tests
    func testRecipesListViewControllerPositive() {
                
        let tblViewLoadExpectation: XCTestExpectation = XCTestExpectation.init(description: "TableView Load Expectation")
        let recipesProvider = MSRecipesProvider()

        recipesListViewController.recipeListViewModel = MSRecipeListViewModel.init(delegate: recipesListViewController, recipesProvider: recipesProvider)
        _ = recipesListViewController.view
        recipesListViewController.recipeListViewModel.getRecipes(success: { (recipes) in
            DispatchQueue.main.async {
                let result = XCTWaiter.wait(for: [tblViewLoadExpectation], timeout: 2.0)
                if result == XCTWaiter.Result.timedOut {
                    XCTAssertTrue(self.recipesListViewController.tblViewRecipes.numberOfRows(inSection: 0) > 0)
                    tblViewLoadExpectation.fulfill()
                } else {
                    XCTFail("Delay interrupted")
                }
                
                let testData = self.recipesListViewController.recipeListViewModel.recipes[0]
                self.recipeListTableViewCell = self.recipesListViewController.tblViewRecipes.dequeueReusableCell(withIdentifier: "MSRecipeListTableViewCell") as? MSRecipeListTableViewCell
                self.recipeListTableViewCell.recipeViewModel = MSRecipeCellViewModel(recipe: testData)
                XCTAssertTrue(self.recipeListTableViewCell.lblTitle.text == testData.title)
                XCTAssertTrue(self.recipeListTableViewCell.recipeImg.imgUrl == testData.photo)
                XCTAssertNotNil(self.recipeListTableViewCell.recipeImg.imageView.image)
                
                self.expectation.fulfill()
            }
        }) { (error) in
            self.expectation.fulfill()
            XCTFail()
        }
        self.wait(for: [expectation], timeout: 10)

    }
    
    func testRecipesListViewControllerNegative() {

        let wrongContentFullSpaceId = "kk2bw5ojx490"
        let wrongContentFullAccessId = "7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84d"
        
        let recipesProvider = MSRecipesProvider(spaceId: wrongContentFullSpaceId, accessToken: wrongContentFullAccessId, contentTypeClasses: defaultContentTypeClasses)

        recipesListViewController.recipeListViewModel = MSRecipeListViewModel(delegate: recipesListViewController, recipesProvider: recipesProvider)
        
        recipesListViewController.recipeListViewModel.getRecipes(success: { (recipes) in
            self.expectation.fulfill()
            XCTFail()
        }) { (error) in
            self.expectation.fulfill()
            XCTAssertNotNil(error)
        }
        self.wait(for: [expectation], timeout: 10)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func getMockPositiveRecipe() -> MSRecipe {
        return MSRecipe.init(id: "testPositiveRecipe1", localeCode: "", updatedAt: nil, createdAt: nil, title: "Beautiful courgette carbonara", calories: 123, description: "Carbonara is a classic pasta sauce made with cream, bacon and Parmesan and is absolutely delicious. I've added gorgeous courgettes for a summery twist. Try to buy the best ingredients you can, as that’s what really helps to make this dish amazing. I’m using a flowering variety of thyme but normal thyme is fine to use. When it comes to the type of pasta, you can serve carbonara with spaghetti or linguine, but I’ve been told by Italian mammas (who I don’t argue with!) that penne is the original, so that’s what I’m using in this recipe. Before you start cooking, it’s important to get yourself a very large pan, or use a high-sided roasting tray so you can give the pasta a good toss.", chef: MSRecipeChef(id: "1Z8SwWMmS8E84Iogk4E6ik"), tags: [MSRecipeTags.init(id: "3RvdyqS8408uQQkkeyi26k"), MSRecipeTags.init(id: "gUfhl28dfaeU6wcWSqs0q")], photo: URL(string: "https://img.jamieoliver.com/jamieoliver/recipe-database/xtra_med/94356757.jpg"))
    }
    
    func getMockNegativeRecipe() -> MSRecipe {
        return MSRecipe(id: "testNegativeRecipe1", localeCode: nil, updatedAt: nil, createdAt: nil, title: nil, calories: 0, description: nil, chef: nil, tags: nil, photo: nil)
    }
}
