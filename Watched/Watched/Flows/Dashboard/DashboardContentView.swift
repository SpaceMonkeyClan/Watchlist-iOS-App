//
//  DashboardContentView.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI

/// Main dashboard flow
struct DashboardContentView: View {
    
    @ObservedObject private var manager = MoviesDataManager()
    @State private var selectedTab: TabViewType = .movies
    private let adMobAds = Interstitial()
    
    // MARK: - Main rendering function
    var body: some View {
        NavigationView {
            GeometryReader { _ in
                ZStack {
                    AppConfig.darkColor.edgesIgnoringSafeArea(.all)
                    TabBarCustomView
                    VStack {
                        RoundedCorner(radius: 40, corners: [.bottomLeft, .bottomRight])
                            .foregroundColor(AppConfig.lightColor).edgesIgnoringSafeArea(.top)
                            .frame(height: UIScreen.main.bounds.height - (hasNotch ? 150 : 90))
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 15) {
                        NavigationCustomView
                        TabsContentView
                        Spacer(minLength: 70)
                    }
                    LoadingView(loading: $manager.isLoading)
                }
            }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
        }
    }
    
    /// Tab bar view
    private var TabBarCustomView: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(0..<TabViewType.allCases.count, id: \.self, content: { id in
                    Button(action: {
                        selectedTab = TabViewType.allCases[id]
                        adMobAds.showInterstitialAds()
                    }, label: {
                        TabViewType.allCases[id].icon.font(.system(size: 30))
                            .foregroundColor(selectedTab == TabViewType.allCases[id] ? AppConfig.orangeColor : AppConfig.lightGrayColor)
                    }).frame(maxWidth: .infinity)
                })
            }
        }.padding(hasNotch ? 10 : 20)
    }
    
    /// Navigation title view
    private var NavigationCustomView: some View {
        VStack {
            HStack {
                Text(selectedTab.rawValue.capitalized)
                    .overlay(
                        LinearGradient(gradient: AppConfig.screenTitleGradient,
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                            .mask(
                                Text(selectedTab.rawValue.capitalized)
                            )
                    )
                    .font(.system(size: 45, weight: .black))
                Spacer()
            }.padding([.leading, .trailing, .top], 20)
        }
    }
    
    /// Tab content views
    private var TabsContentView: some View {
        VStack {
            switch selectedTab {
            case .movies:
                MoviesTabView(manager: manager)
            case .mustWatch:
                MustWatchTabView(manager: manager)
            case .watched:
                WatchedTabView(manager: manager)
            }
        }
    }
}

// MARK: - Preview UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContentView()
    }
}
