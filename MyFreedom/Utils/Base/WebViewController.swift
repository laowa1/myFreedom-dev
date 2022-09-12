//
//  WebViewController.swift
//  MyFreedom
//
//  Created by &&TairoV on 11.04.2022.
//

import WebKit

class WebViewController: BaseViewController {

    override var baseModalPresentationStyle: UIModalPresentationStyle { .formSheet }

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        return webView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }

    private var headerView = BackdropHeaderView()

    override func navigationController(
            _ navigationController: UINavigationController,
            willShow viewController: UIViewController,
            animated: Bool
        ) {
            navigationController.setNavigationBarHidden(false, animated: false)
        }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(webView)
    }

    private func setupLayout() {

        var layoutConstraints = [NSLayoutConstraint]()

        headerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        webView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc func set(title: String, url: URL) {
        headerView.configure(title: title, handleClose: { [ weak self ] in
            self?.dismiss(animated: true, completion: nil)
        })
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestUrl = navigationAction.request.url, requestUrl.scheme == "tel" {
            UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
