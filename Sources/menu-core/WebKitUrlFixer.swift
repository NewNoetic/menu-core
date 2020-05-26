import WebKit

public typealias FullWebKitDelegate = WKNavigationDelegate & WKUIDelegate

public class WebKitUrlFixer: NSObject, WKNavigationDelegate, WKUIDelegate {
    public var forwardDelegate: FullWebKitDelegate?
    
    public init(forwardDelegate: FullWebKitDelegate? = nil) {
        self.forwardDelegate = forwardDelegate
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let delegateReturn = self.forwardDelegate?.webView?(webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
        
        if navigationAction.targetFrame == nil {
            guard let url = navigationAction.request.url else {
                log("no url to open in browser")
                return delegateReturn
            }
            log("opening \(url) in browser")
            NSWorkspace.shared.open(url)
        }
        
        return delegateReturn
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        self.forwardDelegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        
        webView.evaluateJavaScript("""
            window.open = function(open) {
                return function (url, name, features) {
                    window.open(url, '_blank');
                    return window;
                };
            } (window.open);
        """
        , completionHandler: nil)
        
        decisionHandler(.allow)
    }
    
    func log(_ message: Any) {
        print("[WebKitUrlFix] \(message)")
    }
}
