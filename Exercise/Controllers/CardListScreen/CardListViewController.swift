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
            window.webkit.messageHandlers.\(Constants.Design.Event.select).postMessage("designSelected");
        });
    """

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: Constants.Design.Event.add)
        webConfiguration.userContentController.add(self, name: Constants.Design.Event.check)
        webConfiguration.userContentController.add(self, name: Constants.Design.Event.delete)
        webConfiguration.userContentController.add(self, name: Constants.Design.Event.setFirebasefunnel)
        webConfiguration.userContentController.add(self, name: Constants.Design.Event.select)
        webConfiguration.userContentController.add(self, name: "viewPage")
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
        switch message.name {
        case Constants.Design.Event.add:
            if let favoriteDesign = getFavoriteDesign(from: message.body) {
                addFavoriteDesign(item: favoriteDesign)
                webView.evaluateJavaScript("changeFaved(true);")
            }
        case Constants.Design.Event.delete:
            if let favoriteDesign = getFavoriteDesign(from: message.body) {
                deleteFavoriteDesign(item: favoriteDesign)
                webView.evaluateJavaScript("changeFaved(false);")
            }
        case Constants.Design.Event.check:
            if let favoriteDesign = getFavoriteDesign(from: message.body) {
                webView.evaluateJavaScript("changeFaved(false);")
                if isFavoriteDesign(item: favoriteDesign){
                    webView.evaluateJavaScript("changeFaved(true);")
                }
            }
        case Constants.Design.Event.select:
            performSegue(withIdentifier: Constants.goToVariationScreenSegue, sender: self)
        default:
            print("Unhandled Message")
        }
    }

    func getFavoriteDesign(from data: Any ) -> FavoriteDesign? {
        if let dict = data as? [String: Any] {
            if let code = dict[Constants.Design.Properties.code] as? String,
               let colorCode = dict[Constants.Design.Properties.colorCode] as? String,
               let greetingType = dict[Constants.Design.Properties.greetingType] as? Int,
               let photoCount = dict[Constants.Design.Properties.photoCount] as? Int {
                let favoriteDesign = FavoriteDesign(
                    code: code,
                    colorCode: colorCode,
                    greetingType: greetingType,
                    photoCount: photoCount
                )
                return favoriteDesign
            }
        }
        return nil
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
