//
//  LaunchViewController.swift
//  SNKRSLaunchScreenExample
//
//  Created by Caleb Rudnicki on 6/7/20.
//  Copyright © 2020 Caleb Rudnicki. All rights reserved.
//

import UIKit
import SNKRSLaunchScreen

class LaunchViewController: UIViewController {
    
    // MARK: Properties
    
    private let snkrsLaunchView = SNKRSLaunchView(iconImages: [UIImage(named: "Swoosh")!,
                                                               UIImage(named: "Jumpman")!,
                                                               UIImage(named: "AllStar")!],
                                                  iconInitialSize: CGSize(width: 124.0, height: 124.0))

    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        snkrsLaunchView.useCustomIconColor = true
//        snkrsLaunchView.color1 = .systemRed
//        snkrsLaunchView.color2 = .white
//        snkrsLaunchView.duration = 1.0
        
        view.backgroundColor = .systemBackground
        view.addSubview(snkrsLaunchView)

        self.snkrsLaunchView.start({
            let viewController = ViewController()
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false, completion: nil)
        })
    }

}
