//
//  WatchedApp.swift
//  Watched
//
//  Created by Rene Dena on 4/23/21.
//

import SwiftUI
import GoogleMobileAds

@main
struct WatchedApp: App {
    
    // MARK: - Main rendering function
    var body: some Scene {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return WindowGroup {
            DashboardContentView()
        }
    }
}

// MARK: - Google AdMob Interstitial - Support class
class Interstitial: NSObject, GADFullScreenContentDelegate {
    var interstitial: GADInterstitialAd?

    /// Default initializer of interstitial class
    override init() {
        super.init()
        loadInterstitial()
    }
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppConfig.adMobAdID, request: request, completionHandler: { [self] ad, error in
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func showInterstitialAds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.interstitial != nil {
                let root = UIApplication.shared.windows.first?.rootViewController
                self.interstitial?.present(fromRootViewController: root!)
            }
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
}

// MARK: - Useful extensions
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// For iPhones with the notch
let hasNotch = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 > 0

/// Generic alert when the user changed the status for a movie
func presentStatusAlert(movieStatus: MovieStatus) {
    if let topController = UIApplication.shared.windows.first?.rootViewController {
        let alert = UIAlertController(title: "Nice Job!", message: "This movie has been added to the \(movieStatus.rawValue) list", preferredStyle: .alert)
        topController.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConfig.movieStatusAlertAutoDismissInterval, execute:
            { alert.dismiss(animated: true, completion: nil) })
    }
}
