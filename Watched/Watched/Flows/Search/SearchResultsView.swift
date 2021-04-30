//
//  SearchResultsView.swift
//  Watched
//
//  Created by Rene Dena on 4/24/21.
//

import SwiftUI

/// A list of search results
struct SearchResultsView: View {

    @ObservedObject var manager: MoviesDataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showMovieDetails: Bool = false
    @State private var selectedMovie: Movie?
    private let screenTitle = "Search Results"

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
            
            VStack(spacing: 10) {
                NavigationCustomView
                ZStack {
                    ResultsListView
                    NoSearchResults
                }
            }
            LoadingView(loading: $manager.isLoading)
        }
        .navigationBarHidden(true).navigationBarBackButtonHidden(true).navigationBarTitle("")
        .onAppear(perform: {
            manager.performSearch()
        })
    }
    
    /// Navigation title view
    private var NavigationCustomView: some View {
        HStack(spacing: 15) {
            Button(action: {
                UIImpactFeedbackGenerator().impactOccurred()
                presentationMode.wrappedValue.dismiss()
                manager.searchResults.removeAll()
                manager.searchTerm = ""
            }, label: {
                Image(systemName: "chevron.backward.circle")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .foregroundColor(AppConfig.darkColor)
            })
            Text(screenTitle)
                .overlay(
                    LinearGradient(gradient: AppConfig.screenTitleGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .mask(Text(screenTitle))
                )
                .font(.system(size: 45, weight: .black)).lineLimit(1).minimumScaleFactor(0.5)
            Spacer()
        }.padding(.top, 20).padding(.trailing, 30).padding(.leading, 20)
    }
    
    /// Results list view
    private var ResultsListView: some View {
        ScrollView {
            ForEach(0..<manager.searchResults.count, id: \.self, content: { id in
                VStack {
                    HStack(alignment: .top) {
                        ImageView(imageURL: manager.searchResults[id].imageURL)
                            .frame(width: UIScreen.main.bounds.width/2.7, height: UIScreen.main.bounds.width/2)
                            .mask(RoundedRectangle(cornerRadius: 15)).padding(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5)
                            .padding(.leading, 15).padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text(manager.searchResults[id].title).font(.system(size: 20, weight: .medium))
                                .lineLimit(2).minimumScaleFactor(0.8)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(AppConfig.orangeColor)
                                Text(String(format: "%.1f", manager.searchResults[id].voteAverage)).bold()
                            }.padding([.top, .bottom], 5)
                            Spacer()
                            Button(action: {
                                manager.updateStatus(forMovie: manager.searchResults[id], status: .mustWatch)
                            }, label: {
                                Text("Must Watch").bold()
                                    .padding([.leading, .trailing])
                                    .padding([.top, .bottom], 12)
                                    .foregroundColor(AppConfig.lightColor)
                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(AppConfig.orangeColor))
                                    .font(.system(size: 15))
                            })
                            Button(action: {
                                manager.updateStatus(forMovie: manager.searchResults[id], status: .watched)
                            }, label: {
                                Text("Mark as Watched").bold()
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
                    selectedMovie = manager.searchResults[id]
                    showMovieDetails = true
                }
            })
        }
    }
    
    /// No Search results view
    private var NoSearchResults: some View {
        VStack(alignment: .center, spacing: 5) {
            if manager.isLoading == false && manager.searchResults.count == 0 {
                Image(systemName: "film").font(.system(size: 45)).padding()
                Text("No Results").bold()
                Text("There are no movies that matched your search term")
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

// MARK: - Preview UI
struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(manager: MoviesDataManager())
    }
}
