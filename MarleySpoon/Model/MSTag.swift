//
//  MSTags.swift
//  MarleySpoon
//
//  Created by rao on 19/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation
import Contentful

final class MSTag: EntryDecodable, FieldKeysQueryable {
    enum FieldKeys: String, CodingKey {
      case name
    }
    
    static let contentTypeId: String = "tag"
    
    // FlatResource members.
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let name: String?
    
    public required init(from decoder: Decoder) throws {
        
        let sys         = try decoder.sys()
        
        id              = sys.id
        localeCode      = sys.locale
        updatedAt       = sys.updatedAt
        createdAt       = sys.createdAt
        
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: MSTag.FieldKeys.self)
        self.name          = try fields.decodeIfPresent(String.self, forKey: .name)
    }
    
    init(id: String, localeCode: String?, updatedAt: Date?, createdAt: Date?, name: String?) {
        
        self.id = id
        self.localeCode = localeCode
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.name = name
    }
}
