//
//  IntroPageViewController.swift
//  RemoteAssistance
//
//  Created by Sidhant Gandhi on 2/26/18.
//  Copyright © 2018 moback. All rights reserved.
//

import UIKit

class IntroPageViewController: UIViewController {
    var toSetTitle: String?
    var toSetSubtitle: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleLabel.text = self.toSetTitle
        self.subtitleLabel.text = self.toSetSubtitle
    }
    
    static func create(title: String, subtitle: String) -> IntroPageViewController {
        let introPage = IntroPageViewController(nibName: "IntroPageViewController", bundle: nil)
        introPage.toSetTitle = title
        introPage.toSetSubtitle = subtitle
        return introPage
    }
}
