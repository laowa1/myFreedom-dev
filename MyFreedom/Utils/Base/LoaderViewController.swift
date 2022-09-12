//
//  LoaderViewController.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 14.03.2022.
//

import UIKit

class LoaderViewController: BaseViewController {
    
    let loaderView: UIActivityIndicatorView = build {
        $0.style = UIActivityIndicatorView.Style.large
        $0.color = BaseColor.green500
        $0.hidesWhenStopped = true
    }
    
    override var baseModalTransitionStyle: UIModalTransitionStyle { .crossDissolve }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loaderView)
        loaderView.layoutByCentering(over: view)
        view.backgroundColor = BaseColor.base50.withAlphaComponent(0.5)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loaderView.startAnimating()
    }
}
