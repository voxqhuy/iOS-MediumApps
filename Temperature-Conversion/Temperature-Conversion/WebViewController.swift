//
//  WebViewController.swift
//  Temperature-Conversion
//
//  Created by Vo Huy on 5/10/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        // Create a webview
//        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView()
        // Set it as the view of this view controller
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.linkedin.com/in/voxqhuy")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
