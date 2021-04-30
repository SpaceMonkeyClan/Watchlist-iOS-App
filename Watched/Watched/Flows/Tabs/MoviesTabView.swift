//
//  MoviesTabView.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI

/// Home/Movies tab view
struct MoviesTabView: View {
    
    @ObservedObject var manager: MoviesDataManager
    @State private var moviesType: HomeScreenMovieType = AppConfig.defaultHomeScreenMoviesType
    @State private var showSearchResults: Bool = false
    @State private var showMovieDetails: Bool = false
    @State private var selectedMovie: Movie?
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            
            /// Navigate to the search results screen
            if showSearchResults {
                NavigationLink(
                    destination: SearchResultsView(manager: manager),
                    isActive: $showSearchResults,
                    label: { EmptyView() }).hidden()
            }
            
            /// Navigate to movie details screen
            if showMovieDetails && selectedMovie != nil {
                NavigationLink(
                    destination: MovieDetailsView(manager: manager, selectedMovie: selectedMovie!),
                    isActive: $showMovieDetails,
                    label: { EmptyView() }).hidden()
            }
            
            SearchBarView
            CategoriesCarouselView
            MovieResultsCarouselView
            Spacer()
            Image("tmdb_logo").resizable().scaledToFit().frame(height: 10)
            Spacer()
        }
    }
    
    /// Search bar view
    private var SearchBarView: some View {
        ZStack {
            HStack {
                Image(systemName: "magnifyingglass").font(.system(size: 20))
                    .foregroundColor(AppConfig.darkColor).opacity(0.5)
                Spacer()
            }
            TextField("Search Movies...", text: $manager.searchTerm) { _ in } onCommit: {
                showSearchResults = true
            }
            .autocapitalization(.none).disableAutocorrection(true)
            .padding().offset(x: 15).foregroundColor(AppConfig.darkColor)
        }
        .padding([.leading, .trailing]).background(
            RoundedRectangle(cornerRadius: 18).foregroundColor(AppConfig.darkGrayColor)
        ).padding([.leading, .trailing], 20)
    }
    
    /// Categories carousel view
    private var CategoriesCarouselView: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                Spacer(minLength: 15)
                ForEach(0..<HomeScreenMovieType.allCases.count, id: \.self, content: { id in
                    Button(action: {
                        moviesType = HomeScreenMovieType.allCases[id]
                        manager.fetchHomeScreenMovies(endpoint: moviesType.endpoint)
                    }, label: {
                        VStack(alignment: .center) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundColor(HomeScreenMovieType.allCases[id] == moviesType ? AppConfig.orangeColor : AppConfig.lightGrayColor.opacity(0.5))
                                Image("\(HomeScreenMovieType.allCases[id])")
                                    .resizable().scaledToFit().frame(width: 35, height: 35)
                                    .opacity(HomeScreenMovieType.allCases[id] == moviesType ? 1 : 0.3)
                                    .foregroundColor(HomeScreenMovieType.allCases[id] == moviesType ? AppConfig.lightColor : AppConfig.orangeColor)
                            }
                            Text(HomeScreenMovieType.allCases[id].rawValue)
                                .multilineTextAlignment(.center).font(.system(size: 15, weight: .regular))
                        }.frame(width: 80, height: 125).padding([.leading, .trailing], 5)
                    }).foregroundColor(AppConfig.darkColor)
                })
                Spacer(minLength: 15)
            }
        }).padding(.top, 20)
    }
    
    /// Movies carousel
    private var MovieResultsCarouselView: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(moviesType.rawValue).font(.system(size: 25)).bold()
                if manager.homeScreenMovies.count == 0 {
                    Text(manager.isLoading ? "" : "No Movies yet")
                }
            }.padding([.leading, .trailing], 20)
            GeometryReader { reader in
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack {
                        Spacer(minLength: 10)
                        ForEach(0..<manager.homeScreenMovies.count, id: \.self, content: { id in
                            Button(action: {
                                selectedMovie = manager.homeScreenMovies[id]
                                showMovieDetails = true
                            }, label: {
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .overlay(ImageView(imageURL: manager.homeScreenMovies[id].imageURL))
                                        .mask(RoundedRectangle(cornerRadius: 20)).clipped().padding(.top, 10)
                                        .shadow(color: Color.black.opacity(0.4), radius: 5)
                                    Text(manager.homeScreenMovies[id].title).lineLimit(1).padding([.leading, .trailing], 5)
                                        .multilineTextAlignment(.leading).font(.system(size: 15, weight: .medium))
                                    Spacer()
                                }.frame(width: reader.size.height/1.5)
                            })
                            .foregroundColor(AppConfig.darkColor)
                            .padding([.leading, .trailing], 10)
                        })
                        Spacer(minLength: 10)
                    }
                })
            }.animation(nil)
        }.padding(.top, 30)
    }
}

// MARK: - Preview UI
struct MoviesTabView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesTabView(manager: MoviesDataManager())
    }
}
