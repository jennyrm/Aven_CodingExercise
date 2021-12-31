//
//  Organization.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import Foundation

struct Organization: Codable, Hashable {
    let login: String
    let id: Int
    let url: String
    let avatarUrl: String
    let description: String
    let htmlUrl: String
    var isViewed: Bool
    
    private enum CodingKeys: String, CodingKey {
        case login = "login", id = "id", url = "url", avatarUrl = "avatar_url", description = "description", htmlUrl = "html_url", isViewed = "isViewed"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decodeIfPresent(String.self, forKey: .login)!
        id = try container.decodeIfPresent(Int.self, forKey: .id)!
        url = try container.decodeIfPresent(String.self, forKey: .url)!
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)!
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? "No Description"
        htmlUrl = try container.decodeIfPresent(String.self, forKey: .htmlUrl) ?? ""
        isViewed = try container.decodeIfPresent(Bool.self, forKey: .isViewed) ?? false
    }
}
