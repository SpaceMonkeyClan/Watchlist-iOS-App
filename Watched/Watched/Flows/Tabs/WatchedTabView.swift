//
//  WatchedTabView.swift
//  Watched
//
//  Created by Rene Dena on 4/24/21.
//

import SwiftUI

/// Movies that the user watched already
struct WatchedTabView: View {
    
    @ObservedObject var manager: MoviesDataManager
    @State private var showMovieDetails: Bool = false
    @State private var selectedMovie: Movie?
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            /// Navigate to movie details screen
            if showMovieDetails && selectedMovie != nil {
                NavigationLink(
                    destination: MovieDetailsView(manager: manager, selectedMovie: selectedMovie!),
                    isActive: $showMovieDetails,
                    label: { EmptyView() }).hidden()
            }
            
            ResultsListView
            NoWatchedResults
        }
    }
    
    /// Results list view
    private var ResultsListView: some View {
        ScrollView {
            ForEach(0..<manager.watchedMovies.count, id: \.self, content: { id in
                VStack {
                    HStack(alignment: .top) {
                        ImageView(imageURL: manager.watchedMovies[id].imageURL)
                            .frame(width: UIScreen.main.bounds.width/2.7, height: UIScreen.main.bounds.width/2)
                            .mask(RoundedRectangle(cornerRadius: 15)).padding(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5)
                            .padding(.leading, 15).padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text(manager.watchedMovies[id].title).font(.system(size: 20, weight: .medium))
                                .lineLimit(2).minimumScaleFactor(0.8)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(AppConfig.orangeColor)
                                Text(String(format: "%.1f", manager.watchedMovies[id].voteAverage)).bold()
                            }.padding([.top, .bottom], 5)
                            Spacer()
                            Button(action: {
                                manager.updateStatus(forMovie: manager.watchedMovies[id], status: .watched, remove: true)
                            }, label: {
                                HStack {
                                    Text("REMOVE MOVIE").bold()
                                    Image(systemName: "trash.fill").offset(y: -2)
                                }
                                .font(.system(size: 15)).padding(.leading, 2)
                                .foregroundColor(AppConfig.orangeColor)
                            })
                        }.padding(.trailing, 30).padding([.top, .bottom])
                        Spacer()
                    }
                    Divider()
                }
                .frame(width: UIScreen.main.bounds.width)
                .onTapGesture {
                    selectedMovie = manager.watchedMovies[id]
                    showMovieDetails = true
                }
            })
        }
    }
    
    /// No Must Watch results view
    private var NoWatchedResults: some View {
        VStack(alignment: .center, spacing: 5) {
            if manager.watchedMovies.count == 0 {
                Image(systemName: "film")
                    .font(.system(size: 45)).padding()
                Text("Hmm.. Empty list").bold()
                Text("See the Must Watch movies then tap the Mark as Watched button")
                    .font(.system(size: 20, weight: .medium))
                    .opacity(0.5)
            }
        }
        .multilineTextAlignment(.center)
        .foregroundColor(AppConfig.darkColor)
        .font(.system(size: 25))
        .padding()
    }
}

struct WatchedTabView_Previews: PreviewProvider {
    static var previews: some View {
        WatchedTabView(manager: MoviesDataManager())
    }
}
