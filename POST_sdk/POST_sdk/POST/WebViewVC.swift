//
//  WebViewVC.swift
//  POST_sdk
//
//  Created by Apple on 20/04/23.
//

import Foundation
import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var webview: WKWebView!

    var url : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.navigationDelegate = self
        
        if let strUrl = url{
            if let link = URL(string:strUrl){
                let request = URLRequest(url: link)
                webview.load(request)
            }
        }
        
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        decisionHandler(.allow)

       }
}

