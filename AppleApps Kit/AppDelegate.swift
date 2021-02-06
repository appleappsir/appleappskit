//
//  AppDelegate.swift
//  AppleApps Kit
//
//  Created by IntZero on 9/12/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlOpened = url.absoluteString
        let modified = urlOpened.replace(target: "applappkit://", withString:"")
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : AWViewController = mainStoryboard.instantiateViewController(withIdentifier: "AWViewController") as! AWViewController
        initialViewController.urlString = modified
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
