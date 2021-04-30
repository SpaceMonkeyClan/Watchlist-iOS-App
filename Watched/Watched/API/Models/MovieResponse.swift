//
//  MovieResponse.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI
import Foundation

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let results: [Movie]
}

// MARK: - Movie
struct Movie: Codable {
    let id: Int
    let posterPath, releaseDate: String?
    let title, overview: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case overview, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    /// Formatted image URL
    var imageURL: String {
        "https://image.tmdb.org/t/p/w185\(posterPath ?? "")"
    }
    
    /// Get the dictionary representation
    var dictionary: [String: Any] {
        [
            "id": id, "poster_path": posterPath ?? "", "release_date": releaseDate ?? "",
            "title": title, "overview": overview, "vote_average": voteAverage, "vote_count": voteCount
        ]
    }
}
