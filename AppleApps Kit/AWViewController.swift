//
//  AWViewController.swift
//  AppleApps Kit
//
//  Created by IntZero on 9/13/20.
//

import UIKit
import WebKit
import SkeletonView

class AWViewController: UIViewController, WKNavigationDelegate, UIWebViewDelegate, WKUIDelegate {
    
    @IBOutlet weak var mainWebView: WKWebView!
    let loadingBackgroundView = UIView()
    var loadingView: UIView = UIView()
    var activityView: UIActivityIndicatorView?
    var urlString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainWebView.navigationDelegate = self
        self.mainWebView.uiDelegate = self
        loadWebPage()
    }
    
    internal func loadWebPage(fromCache isCacheLoad: Bool = false) {
        var url : URL!
        if(self.urlString == nil){
            url = URL(string: "https://app.appleapps.ir")
        } else {
            url = URL(string: self.urlString)
        }
        let request = URLRequest(url: url, cachePolicy: (isCacheLoad ? .returnCacheDataElseLoad: .reloadRevalidatingCacheData), timeoutInterval: 10)
        //URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.mainWebView.load(request)
        }
    }
    
    func showActivityIndicator() {
        
        //        loadingBackgroundView.frame = self.view.bounds
        //        loadingBackgroundView.backgroundColor = UIColor.black
        //        loadingBackgroundView.alpha = 0.3
        //        loadingBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        self.view.addSubview(loadingBackgroundView)
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView?.center = self.view.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingView.alpha = 0.7
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        self.view.addSubview(loadingView)
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
            //            loadingBackgroundView.alpha = 0
            loadingView.alpha = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
        if ((urlString == "http") || (urlString == "https")) {
         showActivityIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        if ((urlString == "http") || (urlString == "https")) {
            hideActivityIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        if let url = navigationAction.request.url {
            let urlString = url.absoluteString
            let prefix = String(urlString.prefix(4))
            if (!(prefix == "http")) {
                print(urlString)
                let app = UIApplication.shared
                let newUrl = URL(string: urlString)!
                if (app.canOpenURL(newUrl)) {
                    app.open(newUrl, options: [:], completionHandler: nil)
                }
            }
        }
        decisionHandler(.allow)
    }

    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let url = request.url, navigationType == .linkClicked else { return true }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return false
    }
}
