//
//  MSRecipe.swift
//  MarleySpoon
//
//  Created by rao on 18/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation
import Contentful

final class MSRecipe: EntryDecodable, FieldKeysQueryable {
    // If your field names and your properties names differ, you can define the mapping in your `FieldKeys` enum.
    enum FieldKeys: String, CodingKey {
      case photo
      case title, calories, description, chef, tags
    }
    
    static let contentTypeId: String = "recipe"
    
    // FlatResource members.
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let title: String?
    let calories: Int?
    let description: String?
    
    // Relationship fields.
    var photo: URL?
    var chef: MSRecipeChef?
    var tags: [MSRecipeTags]?
    
    public required init(from decoder: Decoder) throws {
        
        let sys         = try decoder.sys()
        
        id              = sys.id
        localeCode      = sys.locale
        updatedAt       = sys.updatedAt
        createdAt       = sys.createdAt
        
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: MSRecipe.FieldKeys.self)
        
        self.title          = try fields.decodeIfPresent(String.self, forKey: .title)
        self.calories       = try fields.decodeIfPresent(Int.self, forKey: .calories) ?? 0
        self.description    = try fields.decodeIfPresent(String.self, forKey: .description)
        self.chef           = try fields.decodeIfPresent(MSRecipeChef.self, forKey: .chef)
        self.tags           = try fields.decodeIfPresent(Array<MSRecipeTags>.self, forKey: .tags)
        
        try fields.resolveLink(forKey: .photo, decoder: decoder) { [weak self] image in
            self?.photo = (image as? Asset)?.url
        }
    }
    
    init(id: String, localeCode: String?, updatedAt: Date?, createdAt: Date?, title: String?, calories: Int, description: String?, chef: MSRecipeChef?, tags: [MSRecipeTags]?, photo: URL?) {
        
        self.id = id
        self.localeCode = localeCode
        self.updatedAt = updatedAt
        self.createdAt = createdAt

        self.title = title
        self.calories = calories
        self.description = description
        self.chef = chef
        self.tags = tags
        self.photo = photo
    }
}

final class MSRecipeChef: Decodable {
    let id: String
    public required init(from decoder: Decoder) throws {
        let sys         = try decoder.sys()
        id              = sys.id
    }
    
    init(id: String) {
        self.id = id
    }
}

final class MSRecipeTags: Decodable {
    let id: String
    public required init(from decoder: Decoder) throws {
        let sys         = try decoder.sys()
        id              = sys.id
    }
    init(id: String) {
        self.id = id
    }
}
