import UIKit
import WebKit

class BurnerAuthorizationViewController: UIViewController, WKNavigationDelegate {

    let redirect_uri = "burner://burnerauth"
    let clientId = BurnerSDK.shared.clientId
    let scope = Creds.shared.scope.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let state = Creds.shared.randomString

    var completion: ((_ burner: Burner?, _ oauth: OAuth?, _ error: Error?) -> Void)?
    
    var webView: WKWebView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var loadingErrorView: UIView!
    
    var burner: Burner?
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = true
        loadingErrorView.isHidden = true
        
        // manually add WKWebView to get around lack of IB support
        
        let config: WKWebViewConfiguration = WKWebViewConfiguration.init()
        if #available(iOS 10.0, *) {
            config.dataDetectorTypes = .link
        }
        
        let webViewFrame = CGRect(x: 20, y: 30, width: view.frame.size.width - 40, height: view.frame.size.height - 60)
        webView = WKWebView.init(frame: webViewFrame, configuration: config)
        webView.allowsLinkPreview = false
        webView.navigationDelegate = self
        view.insertSubview(webView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAuthView()
    }
    
    func loadAuthView() {
        
        loadingErrorView.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        webView.navigationDelegate = self
        let url = authUrl()
        let myRequest = URLRequest(url: url)
        
        print("using auth url: \(url.absoluteString)")
        
        // clear cache
        if #available(iOS 9.0, *) {
            let dataTypes: Set = [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeCookies]
            let dateFrom = Date(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: dateFrom) {
                self.webView.load(myRequest)
            }
        } else {
            // Fallback on earlier versions
            self.webView.load(myRequest)
        }
        
    }
    
    func handleError(_ error: Error) {
        // we had an error loading the view, throw an error
        if let completionHandler = completion {
            completionHandler(nil, nil, error)
        }
        
        loadingErrorView.isHidden = false
        loadingView.stopAnimating()
        loadingView.isHidden = true
        
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error)
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let urlString = navigationAction.request.url?.absoluteString,
            urlString.contains(redirect_uri) {
            let items = URLComponents(string: urlString)?.queryItems
            if let code = items?.filter({$0.name == "code"}).first?.value {
                
                print("DEBUG: getting auth token: \(code)")
                
                HttpManager.shared.getAuthToken(code: code, completion: { (burner, oauth, error) in
                    
                    self.burner = burner
                    
                    var segue = "AuthCompleteExisting"
                    
                    print("found burner: \(String(describing: self.burner))")
                    print("phone number: \(String(describing: self.burner?.phoneNumber))")
                    print("expires: \(String(describing: self.burner?.expires))")
                    
                    if let _ = self.burner,
                       let _ = self.burner?.phoneNumber,
                       let _ = self.burner?.expires  {
                        print("Debug using new segue")
                        segue = "AuthCompleteNew"
                    }
                    
                    print("DEBUG: Using segue: \(segue)")
                    
                    // complete the request on the SDK side
                    if let completionHandler = self.completion {
                        DispatchQueue.main.async(execute: {() -> Void in
                            completionHandler(burner, oauth, error)
                            self.performSegue(withIdentifier: segue, sender: nil)
                        })
                    }
                    
                })
            } else if let _ = items?.filter({$0.name == "error"}).first?.value {
                
                print("Dismissing here")
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            
            // open link in safari if it's from burner
            
            if let urlString = navigationAction.request.url?.absoluteString,
                let url = navigationAction.request.url {
                
                if urlString.contains("burnerapp.com/privacy") || urlString.contains("burnerapp.com/terms-of-service") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
            }
            
        }
        
        decisionHandler(.allow)
    }
    
    @IBAction func dismissAuthAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print("DEBUG: preparing for segue: \(String(describing: segue.identifier))")
        if let destination = segue.destination as? SuccessViewController {

            destination.burner = self.burner
        }
        
        if let destination = segue.destination as? WebErrorViewController {
            destination.delegate = self
        }
    }

    func authUrl() -> URL {
        let urlString = "\(Creds.shared.host)/oauth/authorize?client_id=\(clientId!)&scope=\(scope)&state=\(state)&redirect_uri=\(redirect_uri)"
        let url = URL(string: urlString)!
        return url
    }

}

extension BurnerAuthorizationViewController: WebErrorDelegate {
    
    func webErrorDidRefresh() {
        loadAuthView()
    }
    
}
