//
//  MSRecipeDetailsViewModel.swift
//  MarleySpoon
//
//  Created by rao on 19/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation

class MSRecipeDetailsViewModel: NSObject {
    var recipe: MSRecipe! {
        didSet {
            self.getChefName()
            self.getTags()
        }
    }
    var chef: MSChef? {
        didSet {
            setChefName()
        }
    }
    var tags: [MSTag] = [] {
        didSet {
            setTagString()
        }
    }
    let provider: MSRecipesProvider
    let delegate: MSViewModelDelegate?
    
    var chefName: String = "" {
        didSet {
            delegate?.shouldRefreshContentViews()
        }
    }
    
    var tagsString: String = "" {
        didSet {
            delegate?.shouldRefreshContentViews()
        }
    }
    
    init(provider: MSRecipesProvider = MSRecipesProvider(), delegate: MSViewModelDelegate? = nil) {
        self.provider = provider
        self.delegate = delegate
    }
    
    //    - Description: Get chef's name form recipe's chef's model and sets chefName and calls delegate's shouldRefreshContentViews method
    //    - Parameters: None
    //    - Returns: Void
    func getChefName(success: ((_ chef: MSChef) -> Void)? = nil, errorOccured: ((_ error: String) -> Void)? = nil) {
        if let chef = recipe.chef {
            provider.getChef(for: "\(chef.id)", success: {[weak self] (chef) in
                self?.chef = chef
                success?(chef)
            }) { (error) in
                self.delegate?.shouldShowError(error: error)
                errorOccured?(error)
            }
        } else {
            self.delegate?.shouldShowError(error: "")
            errorOccured?("Chef object is empty")
        }
    }
    
    private func setChefName() {
        self.chefName = self.chef?.name ?? ""
    }
    
    //    - Description: Get tags form recipe's tags model and sets tags and calls delegate's shouldRefreshContentViews method
    //    - Parameters: None
    //    - Returns: Void
    func getTags(success: ((_ tags: [MSTag]) -> Void)? = nil, errorOccured: ((_ error: String) -> Void)? = nil) {
        var tagObjects: [MSTag] = []
        if let tags = recipe.tags {
            for tag in tags {
                provider.getTag(for: tag.id, success: {[weak self] (tag) in
                    tagObjects.append(tag)
                        if tagObjects.count == tags.count {
                            self?.tags = tagObjects
                            success?(tagObjects)
                        }
                    }, errorOccured: { (error) in
                        self.delegate?.shouldShowError(error: error)
                        errorOccured?(error)
                })
            }
        } else {
            self.delegate?.shouldShowError(error: "")
            errorOccured?("Tags object is empty")
        }
    }
    
    //    - Description: Concdinate tags to single string
    //    - Parameters: None
    //    - Returns: Void
    private func setTagString() {
        var tagArray: [String] = []
        for tag in self.tags {
            tagArray.append(tag.name?.capitalized ?? "")
        }
        self.tagsString = tagArray.joined(separator: ", ")
    }
}

