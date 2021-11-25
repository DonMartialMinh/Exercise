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

    // MARK: - View LifeCycle
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadFavoriteDesigns()
        let url = URL(string: "https://shimapri:s2ima8r1@www6.shimaumaprint.com/webview/nenga/design?use_type=n")
        let request = URLRequest(url: url!)
        webView.load(request)
    }

    // MARK: - Data Manipulation
    private func getFavoriteDesign(from data: Any ) -> FavoriteDesign? {
        guard let dict = data as? [String: Any] else { return nil }
        var favoriteDesign: FavoriteDesign?
        if let code = dict[Constants.Design.Properties.code] as? String,
           let colorCode = dict[Constants.Design.Properties.colorCode] as? String,
           let greetingType = dict[Constants.Design.Properties.greetingType] as? Int,
           let photoCount = dict[Constants.Design.Properties.photoCount] as? Int {
            favoriteDesign = FavoriteDesign(
                code: code,
                colorCode: colorCode,
                greetingType: greetingType,
                photoCount: photoCount
            )
        }
        return favoriteDesign
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
        viewModel.fetchTemplate(with: templateCode) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
            case .success(let data):
                guard let template = data,
                      let isVariation = template.isVariation(),
                      let isPhotoSelect = template.isPhotoSelect()
                else { return }
                DataProvider().add(template)
                if isVariation {
                    let VC = VariationViewController.initFromNib()
                    VC.template = template
                    self.navigationController?.pushViewController(VC, animated: true)
                } else if isPhotoSelect {
                    let VC  = PhotoSelectViewController.initFromNib()
                    VC.template = template
                    self.navigationController?.pushViewController(VC, animated: true)
                } else {
                    let VC = DesignViewController.initFromNib()
                    VC.template = template
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            case .failure(let error):
                self.didFailWithError(error: error)
            }
        }
    }

    ///Change favorite icon when user click in web view
    func changeFavorite(_ favorite: Bool) -> String {
        return "changeFaved(\(favorite));"
    }
}

extension CardListViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case Constants.Design.Event.add:
            if let favoriteDesign = getFavoriteDesign(from: message.body) {
                addFavoriteDesign(item: favoriteDesign)
                webView.evaluateJavaScript(changeFavorite(true))
            }
        case Constants.Design.Event.delete:
            if let favoriteDesign = getFavoriteDesign(from: message.body) {
                deleteFavoriteDesign(item: favoriteDesign)
                webView.evaluateJavaScript(changeFavorite(false))
            }
        case Constants.Design.Event.check:
            if let favoriteDesign = getFavoriteDesign(from: message.body) {
                currentFavoriteDesign = favoriteDesign
                webView.evaluateJavaScript(changeFavorite(false))
                if isFavoriteDesign(item: favoriteDesign){
                    webView.evaluateJavaScript(changeFavorite(true))
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
