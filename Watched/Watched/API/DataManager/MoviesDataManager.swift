//
//  MoviesDataManager.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI
import Foundation

/// Movie status that the user can set
enum MovieStatus: String, CaseIterable {
    case mustWatch = "Must Watch", watched = "Watched"
}

/// Main data manager to fetch the movies data
class MoviesDataManager: ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var isLoading: Bool = false
    @Published var searchTerm: String = ""
    @Published var homeScreenMovies = [Movie]()
    @Published var searchResults = [Movie]()
    @Published var mustWatchMovies = [Movie]()
    @Published var watchedMovies = [Movie]()
    
    /// Start fetching the home screen movies when the app launches
    init() {
        fetchHomeScreenMovies(endpoint: AppConfig.defaultHomeScreenMoviesType.endpoint)
        fetchSavedMovies()
    }
}

// MARK: - Fetch Movies by generic categories (Ex.: Popular, Upcoming, etc)
extension MoviesDataManager {
    /// Fetch movies for the home screen
    /// - Parameter endpoint: pass a specific endpoint to get certain movies
    func fetchHomeScreenMovies(endpoint: APIEndpoint) {
        isLoading = true
        homeScreenMovies.removeAll()
        URLSession.shared.dataTask(with: endpoint.requestURL) { (data, _, _) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isLoading = false
                if let responseData = data, let response = try? JSONDecoder().decode(MovieResponse.self, from: responseData) {
                    self.homeScreenMovies = response.results
                }
            }
        }.resume()
    }
}

// MARK: - Search for a movie
extension MoviesDataManager {
    
    /// Search for the term typed by the user
    func performSearch() {
        isLoading = true
        URLSession.shared.dataTask(with: APIEndpoint.searchRequestURL(query: searchTerm)) { (data, _, _) in
            DispatchQueue.main.async {
                self.isLoading = false
                if let responseData = data, let response = try? JSONDecoder().decode(MovieResponse.self, from: responseData) {
                    self.searchResults = response.results
                }
            }
        }.resume()
    }
}

// MARK: - Mark/Remove movies from Must Watch or Watched lists
extension MoviesDataManager {
    
    /// Update the status for a movie
    /// - Parameters:
    ///   - movie: movie object
    ///   - status: status like must watch or watched
    ///   - remove: will remove the movie from the watched list
    func updateStatus(forMovie movie: Movie, status: MovieStatus, remove: Bool = false) {
        UIImpactFeedbackGenerator().impactOccurred()
        var savedMovies = UserDefaults.standard.dictionary(forKey: status.rawValue) ?? [String:Any]()
        savedMovies["\(movie.id)"] = movie.dictionary /// add the movie to selected `status` category
        /// If the user will remove the movie completely from their `Watched` list
        if remove {
            watchedMovies.removeAll(where: { $0.id == movie.id })
            savedMovies.removeValue(forKey: "\(movie.id)")
            UserDefaults.standard.setValue(savedMovies, forKey: status.rawValue)
            UserDefaults.standard.synchronize()
            
        } else {
            /// Remove the same movie from the other `status` category, if available
            let oppositeStatus = status == .watched ? MovieStatus.mustWatch.rawValue : MovieStatus.watched.rawValue
            if var existingMovies = UserDefaults.standard.dictionary(forKey: oppositeStatus) {
                existingMovies.removeValue(forKey: "\(movie.id)")
                UserDefaults.standard.setValue(existingMovies, forKey: oppositeStatus)
            }
            UserDefaults.standard.setValue(savedMovies, forKey: status.rawValue)
            UserDefaults.standard.synchronize()
            /// Update existing arrays of movies. Remove from one array while adding to the other
            if status == .mustWatch && !mustWatchMovies.contains(where: { $0.id == movie.id }) {
                mustWatchMovies.append(movie)
                watchedMovies.removeAll(where: { $0.id == movie.id })
            } else if status == .watched && !watchedMovies.contains(where: { $0.id == movie.id }) {
                watchedMovies.append(movie)
                mustWatchMovies.removeAll(where: { $0.id == movie.id })
            }
            presentStatusAlert(movieStatus: status)
        }
    }
    
    /// Fetch saved movies for both watched and must watch
    func fetchSavedMovies() {
        func buildMovie(withDictionary dictionary: Any) -> Movie? {
            if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed) {
                if let movie = try? JSONDecoder().decode(Movie.self, from: data) {
                    return movie
                }
            }
            return nil
        }
        
        MovieStatus.allCases.forEach { status in
            if let dictionary = UserDefaults.standard.dictionary(forKey: status.rawValue) {
                dictionary.forEach { _, details in
                    switch status {
                    case .mustWatch:
                        if let movie = buildMovie(withDictionary: details),
                           !mustWatchMovies.contains(where: { $0.id == movie.id }) {
                            mustWatchMovies.append(movie)
                        }
                    case .watched:
                        if let movie = buildMovie(withDictionary: details),
                           !watchedMovies.contains(where: { $0.id == movie.id }) {
                            watchedMovies.append(movie)
                        }
                    }
                }
            }
        }
    }
}
