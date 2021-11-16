//
//  CardListViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/8/21.
//

import UIKit
import WebKit
import SVProgressHUD

class CardListViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    private var favoriteDesigns: [FavoriteDesign] = []
    private var currentFavoriteDesign: FavoriteDesign?
    private var webView: WKWebView!
    private var viewModel = CardListViewModel()
    private let script = """
        document.getElementById("create-button").addEventListener("click", function() {
            window.webkit.messageHandlers.\(Constants.Design.Event.select).postMessage("designSelected");
        });
    """

    // MARK: - LoadView
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

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadFavoriteDesigns()
        let url = URL(string: "https://shimapri:s2ima8r1@www6.shimaumaprint.com/webview/nenga/design?use_type=n")
        let request = URLRequest(url: url!)
        webView.load(request)
    }

    // MARK: - Data Manipulation
    private func getFavoriteDesign(from data: Any ) -> FavoriteDesign? {
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

    private func addFavoriteDesign(item: FavoriteDesign) {
        favoriteDesigns.append(item)
        viewModel.saveFavoriteDesign(favDesignArray: favoriteDesigns)
    }

    private func deleteFavoriteDesign(item: FavoriteDesign) {
        favoriteDesigns = favoriteDesigns.filter({ (favoriteDesign) in
            favoriteDesign.code != item.code ||
                favoriteDesign.colorCode != item.colorCode ||
                favoriteDesign.greetingType != item.greetingType ||
                favoriteDesign.photoCount != item.photoCount
        })
        viewModel.saveFavoriteDesign(favDesignArray: favoriteDesigns)
    }

    private func isFavoriteDesign(item: FavoriteDesign) -> Bool {
        return favoriteDesigns.contains(where: { (favoriteDesign) -> Bool in
            favoriteDesign.code == item.code &&
                favoriteDesign.colorCode == item.colorCode &&
                favoriteDesign.greetingType == item.greetingType &&
                favoriteDesign.photoCount == item.photoCount
        })
    }

    // MARK: - Navigation
    func navigateToNextScreen() {
        SVProgressHUD.show(withStatus: Constants.hubLoading.localized)
        guard let templateCode = currentFavoriteDesign?.code else { return }
        viewModel.fetchTemplate(with: templateCode) { [weak self] template in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if template != nil {
                var isContainVariation = true
                var isContainAddPhoto = true
                if !template!.variationOptions.photoCount.isEmpty &&
                    !template!.variationOptions.colorCode.isEmpty &&
                    !template!.variationOptions.greetingType.isEmpty {
                    isContainVariation = false
                }
                if template!.variationOptions.photoCount.isEmpty ||
                    template!.variationOptions.photoCount.count == 1 &&
                    template!.variationOptions.photoCount.contains(0) {
                    isContainAddPhoto = false
                }
                if isContainVariation && isContainAddPhoto {
                    self.performSegue(withIdentifier: Constants.goToVariationScreenSegue, sender: self)
                } else if !isContainVariation && !isContainAddPhoto {
                    let VC  = DesignViewController.initFromNib()
                    self.navigationController?.pushViewController(VC, animated: true)
                } else if isContainVariation && !isContainAddPhoto{
                    self.performSegue(withIdentifier: Constants.goToVariationScreenSegue, sender: self)
                } else if !isContainVariation && isContainAddPhoto {
                    let VC  = PhotoSelectViewController.initFromNib()
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
}

extension CardListViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
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
                currentFavoriteDesign = favoriteDesign
                webView.evaluateJavaScript("changeFaved(false);")
                if isFavoriteDesign(item: favoriteDesign){
                    webView.evaluateJavaScript("changeFaved(true);")
                }
            }
        case Constants.Design.Event.select:
            navigateToNextScreen()
        default:
            print("Unhandled Message")
        }
    }
}

extension CardListViewController: CardListViewModelEvent {
    func didUpdateFavoriteDesigns(_ cardListViewModel: CardListViewModel, favoriteDesigns: [FavoriteDesign]) {
        self.favoriteDesigns.append(contentsOf: favoriteDesigns)
    }

    func didFailWithError(error: Error) {
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
}
