//
//  CardListViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/8/21.
//

import UIKit
import WebKit

class CardListViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    let userDefault = UserDefaults.standard
    var webView: WKWebView!

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: "isFavoriteDesign")
        webConfiguration.userContentController.add(self, name: "addFavoriteDesign")
        webConfiguration.userContentController.add(self, name: "deleteFavoriteDesign")
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
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
        print(message.name)
        guard let dict = message.body as? [String: Any] else { return }
        let code = dict["code"] as! String
        let colorCode = dict["color_code"] as! String
        let greetingType = dict["greeting_type"] as! Int
        let photoCount = dict["photo_count"] as! Int
        let favoriteDesign = FavoriteDesign(
            code: code,
            colorCode: colorCode,
            greetingType: greetingType,
            photoCount: photoCount
        )
        print(favoriteDesign)
        if message.name == "addFavoriteDesign" {
            userDefault.setValue(true, forKey: favoriteDesign.code)
            webView.evaluateJavaScript("changeFaved(true);")
        } else if message.name == "deleteFavoriteDesign" {
            userDefault.removeObject(forKey: favoriteDesign.code)
            webView.evaluateJavaScript("changeFaved(false);")
        } else if message.name == "isFavoriteDesign" {
            webView.evaluateJavaScript("changeFaved(false);")
            if userDefault.object(forKey: favoriteDesign.code) != nil {
                webView.evaluateJavaScript("changeFaved(true);")
            }
        }
    }
}
