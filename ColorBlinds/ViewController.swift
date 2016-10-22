//
//  ViewController.swift
//  ColorBlinds
//
//  Created by Jordi de Kock on 15-04-16.
//  Copyright © 2016 Jordi de Kock. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

typealias CGGammaValue = Float
typealias CGDirectDisplayID = UInt32

class ViewController: UIViewController {
    
    var testImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleDict = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.title = "Colorblinds"
        
        testImage = UIImageView.init(frame: CGRect(x: 20, y: 20, width: self.view.bounds.size.width - 40, height: 240));
        testImage.image = UIImage(named: "Balloons")
        testImage.clipsToBounds = true
        testImage.contentMode = .scaleAspectFill
        self.view.addSubview(testImage);
        
        let nextViewButton = UIButton.init(type: .custom)
        nextViewButton.frame = CGRect(x: 20, y: testImage.frame.size.height + testImage.frame.origin.y + 20, width: self.view.bounds.size.width - 40, height: 50)
        nextViewButton.backgroundColor = .red
        nextViewButton.setTitle("Next view", for: UIControlState())
        nextViewButton.addTarget(self, action: #selector(ViewController.nextView), for: .touchUpInside)
        self.view.addSubview(nextViewButton)
    }
    
    func nextView() {
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
        
        print("next view")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
