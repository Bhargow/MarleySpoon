//
//  MSRecipesProvider.swift
//  MarleySpoon
//
//  Created by rao on 18/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit
import Contentful

class MSRecipesProvider: NSObject {
    
    let client: Client!
    let contentTypeClasses: [EntryDecodable.Type]!
    
    init(spaceId: String = contentFullSpaceId, accessToken: String = contentFullAccessId, contentTypeClasses: [EntryDecodable.Type] = defaultContentTypeClasses) {
        self.contentTypeClasses = contentTypeClasses
        self.client = Client(spaceId: spaceId, accessToken: accessToken, contentTypeClasses: contentTypeClasses)
    }
    
    //    - Description: Get recipes entry form content full
    //    - Parameters: success: @escaping (_ recipes: [MSRecipe]) -> Void, errorOccured: @escaping (_ error: String) -> Void
    //    - Returns: Void
    func getRecipesFromContentFull(success: @escaping (_ recipes: [MSRecipe]) -> Void, errorOccured: @escaping (_ error: String) -> Void) {
        let _ = client.fetchArray(of: MSRecipe.self) { (result: Result<HomogeneousArrayResponse<MSRecipe>>) in
            switch result {
            case .success(let entriesArrayResponse):
                let recipes = entriesArrayResponse.items
                success(recipes)
            case .error(let error):
                errorOccured(error.localizedDescription)
            }
        }
    }
    
    //    - Description: Get chef entry form for chef entry id from content full API
    //    - Parameters: id: String, success: @escaping (_ chef: MSChef) -> Void, errorOccured: @escaping (_ error: String) -> Void
    //    - Returns: Void
    func getChef(for id:String, success: @escaping (_ chef: MSChef) -> Void, errorOccured: @escaping (_ error: String) -> Void) {
        client.fetch(MSChef.self, id: id) { (result: Result<MSChef>) in
            switch result {
            case .success(let chef):
                success(chef)
            case .error(let error):
                errorOccured(error.localizedDescription)
            }
        }
    }
    
    //    - Description: Get tag entry form for tag entry id from content full API
    //    - Parameters: id: String, success: @escaping (_ tag: MSTag) -> Void, errorOccured: @escaping (_ error: String) -> Void
    //    - Returns: Void
    func getTag(for id: String, success: @escaping (_ tag: MSTag) -> Void, errorOccured: @escaping (_ error: String) -> Void) {
        client.fetch(MSTag.self, id: id) { (result: Result<MSTag>) in
            switch result {
            case .success(let tag):
                success(tag)
            case .error(let error):
                errorOccured(error.localizedDescription)
            }
        }
    }
}


