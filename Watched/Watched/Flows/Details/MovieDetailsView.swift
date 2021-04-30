//
//  MovieDetailsView.swift
//  Watched
//
//  Created by Rene Dena on 4/24/21.
//

import SwiftUI

/// Shows the details about a movie
struct MovieDetailsView: View {
    
    @ObservedObject var manager: MoviesDataManager
    @Environment(\.presentationMode) var presentationMode
    @State var selectedMovie: Movie
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                AppConfig.darkGrayColor
                AppConfig.lightColor
                Spacer(minLength: UIScreen.main.bounds.height/3)
            }.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                NavigationCustomView
                MovieDetailsHeaderView
                BottomActionView
            }
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true).navigationBarTitle("")
    }
    
    /// Navigation title view
    private var NavigationCustomView: some View {
        HStack(spacing: 15) {
            Button(action: {
                UIImpactFeedbackGenerator().impactOccurred()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward.circle")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .foregroundColor(AppConfig.darkColor)
            })
            Spacer()
        }.padding(.top, 20).padding(.trailing, 30).padding(.leading, 20)
    }
    
    /// Movie details header view
    private var MovieDetailsHeaderView: some View {
        ScrollView {
            ImageView(imageURL: selectedMovie.imageURL)
                .frame(width: UIScreen.main.bounds.width/1.6, height: UIScreen.main.bounds.width/1.2).clipped()
                .mask(RoundedRectangle(cornerRadius: 20)).padding()
                .shadow(color: AppConfig.orangeColor.opacity(0.3), radius: 7)
            HStack(alignment: .top) {
                Text(selectedMovie.title).font(.system(size: 22)).bold()
                    .lineLimit(2).minimumScaleFactor(0.8).offset(y: -2)
                Spacer()
                Text("\(String(format: "%.1f", selectedMovie.voteAverage)) / \(selectedMovie.voteCount)")
                Image(systemName: "star.fill").foregroundColor(AppConfig.orangeColor)
            }.padding([.leading, .trailing, .top], 20)
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Release Date:").bold()
                    Spacer()
                    Text(selectedMovie.releaseDate ?? "N/A")
                    Image(systemName: "calendar").foregroundColor(AppConfig.orangeColor)
                }.padding(.bottom, 5)
                Divider()
                Text("Overview:").bold()
                Text(selectedMovie.overview).foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
            }.padding([.leading, .trailing], 20).padding(.top, 10)
            Spacer(minLength: 50)
        }
    }
    
    /// Bottom view to take action on the moview
    private var BottomActionView: some View {
        ZStack {
            RoundedCorner(radius: 40, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom).foregroundColor(AppConfig.darkColor)
                .shadow(color: Color(#colorLiteral(red: 0.7174408436, green: 0.7174408436, blue: 0.7174408436, alpha: 1)), radius: 5, y: -5)
            VStack(spacing: 20) {
                Text("Choose an option").bold()
                HStack(spacing: 20) {
                    Button(action: {
                        manager.updateStatus(forMovie: selectedMovie, status: .mustWatch)
                    }, label: {
                        Text("Must Watch").bold()
                            .padding([.leading, .trailing])
                            .padding([.top, .bottom], 12)
                            .foregroundColor(AppConfig.lightColor)
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(AppConfig.orangeColor))
                            .font(.system(size: 15))
                    })
                    Button(action: {
                        manager.updateStatus(forMovie: selectedMovie, status: .watched)
                    }, label: {
                        Text("Watched It").bold()
                            .padding([.leading, .trailing])
                            .padding([.top, .bottom], 12)
                            .foregroundColor(AppConfig.darkColor)
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(AppConfig.darkGrayColor))
                            .font(.system(size: 15))
                    })
                }
                Spacer()
            }.foregroundColor(.white).padding(30)
        }.frame(height: 100)
    }
}

// MARK: - Preview UI
struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(manager: MoviesDataManager(), selectedMovie: Movie(id: 1, posterPath: "https://image.tmdb.org/t/p/w185/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg", releaseDate: "2021-03-24", title: "Godzill vs Kong", overview: "In a time when monsters walk the Earth, humanity’s fight for its future sets Godzilla and Kong on a collision course that will see the two most powerful forces of nature on the planet collide in a spectacular battle for the ages.", voteAverage: 4.9, voteCount: 293))
    }
}
