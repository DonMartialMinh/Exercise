//
//  CardListViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/8/21.
//

import UIKit
import WebKit

class CardListViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        let source =
//            """
//                document.getElementById('favorite-button').addEventListener("click", function(){
//                window.webkit.messageHandlers.addFavoriteDesign.postMessage("123");
//                });
//            """
//        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
//        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "addFavoriteDesign")
        webView.configuration.userContentController.add(self, name: "deleteFavoriteDesign")
        webView.configuration.userContentController.add(self, name: "isFavoriteDesign")
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://shimapri:s2ima8r1@www6.shimaumaprint.com/webview/nenga/design?use_type=n")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}

extension CardListViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "addFavoriteDesign" {
            webView.evaluateJavaScript("changeFaved(true);") {
                (result, error) in
                if error == nil {
                    print(result)
                } else {
                    print(error)
                }
            }
            print(message.body)
//            if let dict = message.body as? Dictionary<String, String> {
//                let code = dict["code"]
//                let greetingType = dict["greeting_type"]
//                let colorCode = dict["color_code"]
//                let photoCount = dict["photo_count"]
//                print(code)
//                print(greetingType)
//                print(colorCode)
//                print(photoCount)
//            }
        } else if message.name == "deleteFavoriteDesign" {
            webView.evaluateJavaScript("changeFaved(false);") {
                (result, error) in
                if error == nil {
                    print(result)
                } else {
                    print(error)
                }
            }
            print(message.body)
//            if let dict = message.body as? Dictionary<String, String> {
//                let code = dict["code"]
//                let greetingType = dict["greeting_type"]
//                let colorCode = dict["color_code"]
//                let photoCount = dict["photo_count"]
//                print(code)
//                print(greetingType)
//                print(colorCode)
//                print(photoCount)
//            }
        } else if message.name == "isFavoriteDesign" {
            print(message.body)
            
        }
    }
}
