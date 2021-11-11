//
//  CardListViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/8/21.
//

import UIKit
import WebKit

class CardListViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var favoriteDesigns: [FavoriteDesign] = []
    var webView: WKWebView!
    var viewModel = CardListViewModel()
    let script = """
        document.getElementById("create-button").addEventListener("click", function() {
            window.webkit.messageHandlers.handleDesignSelected.postMessage("designSelected");
        });
    """

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: "isFavoriteDesign")
        webConfiguration.userContentController.add(self, name: "addFavoriteDesign")
        webConfiguration.userContentController.add(self, name: "deleteFavoriteDesign")
        webConfiguration.userContentController.add(self, name: "viewPage")
        webConfiguration.userContentController.add(self, name: "setFirebaseFunnels")
        webConfiguration.userContentController.add(self, name: "handleDesignSelected")
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webConfiguration.userContentController.addUserScript(userScript)
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
        viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadFavoriteDesigns()
        let url = URL(string: "https://shimapri:s2ima8r1@www6.shimaumaprint.com/webview/nenga/design?use_type=n")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}

extension CardListViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        guard let dict = message.body as? [String: Any] else {
            return
        }
        guard let code = dict["code"] as? String,
              let colorCode = dict["color_code"] as? String,
              let greetingType = dict["greeting_type"] as? Int,
              let photoCount = dict["photo_count"] as? Int else {
            print("Error casting to favoriteDesign properties")
            return
        }
        let favoriteDesign = FavoriteDesign(
            code: code,
            colorCode: colorCode,
            greetingType: greetingType,
            photoCount: photoCount
        )
        switch message.name {
        case "addFavoriteDesign":
            addFavoriteDesign(item: favoriteDesign)
            webView.evaluateJavaScript("changeFaved(true);")
        case "deleteFavoriteDesign":
            deleteFavoriteDesign(item: favoriteDesign)
            webView.evaluateJavaScript("changeFaved(false);")
        case "isFavoriteDesign":
            webView.evaluateJavaScript("changeFaved(false);")
            if isFavoriteDesign(item: favoriteDesign){
                webView.evaluateJavaScript("changeFaved(true);")
            }
        case "handleDesignSelected":
            print("handleDesignSelected")
        default:
            print("Unhandled Message")
        }
    }

    func addFavoriteDesign(item: FavoriteDesign) {
        favoriteDesigns.append(item)
        viewModel.saveFavoriteDesign(favDesignArray: favoriteDesigns)
    }

    func deleteFavoriteDesign(item: FavoriteDesign) {
        favoriteDesigns = favoriteDesigns.filter({ (favoriteDesign) in
            favoriteDesign.code != item.code ||
            favoriteDesign.colorCode != item.colorCode ||
            favoriteDesign.greetingType != item.greetingType ||
            favoriteDesign.photoCount != item.photoCount
        })
        viewModel.saveFavoriteDesign(favDesignArray: favoriteDesigns)
    }

    func isFavoriteDesign(item: FavoriteDesign) -> Bool {
        return favoriteDesigns.contains(where: { (favoriteDesign) -> Bool in
            favoriteDesign.code == item.code &&
            favoriteDesign.colorCode == item.colorCode &&
            favoriteDesign.greetingType == item.greetingType &&
            favoriteDesign.photoCount == item.photoCount
        })
    }
}

extension CardListViewController: CardListViewModelEvent {
    func didUpdateFavoriteDesigns(_ cardListViewModel: CardListViewModel, favoriteDesignArray: [FavoriteDesign]) {
        favoriteDesigns.append(contentsOf: favoriteDesignArray)
    }
}
