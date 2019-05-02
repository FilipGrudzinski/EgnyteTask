//
//  ViewController.swift
//  EgnyteTask
//
//  Created by Filip on 02/05/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func downloadWeatherButton(_ sender: Any) {
        print("downloadWeatherButton")
    }
    @IBAction func printWeatherButton(_ sender: Any) {
        print("printWeatherButton")
    }
    @IBAction func downloadFootBallButton(_ sender: Any) {
        print("downloadFootBallButton")
    }
    @IBAction func printFootBallButton(_ sender: Any) {
        print("printFootBallButton")
    }
}

