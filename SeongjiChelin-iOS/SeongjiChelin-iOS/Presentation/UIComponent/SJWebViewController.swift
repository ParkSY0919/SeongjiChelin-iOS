//
//  SJWebViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/13/25.
//

import UIKit

import WebKit

final class SJWebViewController: BaseViewController {
    
    private var webView: WKWebView?
    
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWebView()
    }
    
    private func setWebView() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.load(request)
        } else {
            print("Invalid URL string.")
        }
    }
    
}

