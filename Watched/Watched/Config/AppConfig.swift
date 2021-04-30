//
//  AppConfig.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    /// Test Interstitial ID: ca-app-pub-3940256099942544/4411468910
    static let adMobAdID: String = "ca-app-pub-4998868944035881/7571559957"
    
    // MARK: - API Configurations
    static let tmdbAPIKey = "f46bc019441be789063da9ec32ecede6"
    static let tmdbAPIBasePath = "https://api.themoviedb.org/3"
    
    // MARK: - UI Configurations
    static let lightColor = Color(#colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1))
    static let darkColor = Color(#colorLiteral(red: 0.110825114, green: 0.1783016622, blue: 0.2700639367, alpha: 1))
    static let orangeColor = Color(#colorLiteral(red: 0.936199367, green: 0.3894290626, blue: 0.01969358698, alpha: 1))
    static let lightGrayColor = Color(#colorLiteral(red: 0.9009860158, green: 0.9061098099, blue: 0.9230549335, alpha: 1))
    static let darkGrayColor = Color(#colorLiteral(red: 0.8669198155, green: 0.8869883418, blue: 0.9251181483, alpha: 1))
    
    static let defaultHomeScreenMoviesType = HomeScreenMovieType.popular
    static let movieStatusAlertAutoDismissInterval = 1.5
    
    static let screenTitleGradient = Gradient(colors: [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))])
}

// MARK: - API Endpoints
enum APIEndpoint: String {
    case popular = "/movie/popular"
    case playing = "/movie/now_playing"
    case topRated = "/movie/top_rated"
    case upcoming = "/movie/upcoming"
    case genres = "/genre/movie/list"
    case search = "/search/movie"
    
    /// API Request URL
    var requestURL: URL {
        URL(string: "\(AppConfig.tmdbAPIBasePath)\(self.rawValue)?api_key=\(AppConfig.tmdbAPIKey)")!
    }
    
    /// Search API Request URL
    static func searchRequestURL(query: String) -> URL {
        let base = APIEndpoint.search.requestURL.absoluteString
        let formattedQuery = "\(query.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        return URL(string: base+"&query=\(formattedQuery)")!
    }
}

// MARK: - Tab view type
enum TabViewType: String, CaseIterable, Identifiable {
    case movies, mustWatch = "Must Watch", watched
    
    var icon: Image {
        switch self {
        case .movies:
            return Image("home")
        case .mustWatch:
            return Image("mustWatch")
        case .watched:
            return Image("watched")
        }
    }
    
    var id: Int { hashValue }
}

// MARK: - Home/Movies tab categories
enum HomeScreenMovieType: String, CaseIterable, Identifiable {
    case popular = "Popular Movies"
    case nowPlaying = "Now Playing"
    case topRated = "Top Rated Movies"
    case upcoming = "Upcoming Movies"

    var endpoint: APIEndpoint {
        switch self {
        case .popular:
            return .popular
        case .nowPlaying:
            return .playing
        case .topRated:
            return .topRated
        case .upcoming:
            return .upcoming
        }
    }
    
    var id: Int { hashValue }
}
