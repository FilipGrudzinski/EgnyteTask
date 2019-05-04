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
    private let weatherUrl = "http://codekata.com/data/04/weather.dat"
    private let footballUrl = "http://codekata.com/data/04/football.dat"
    public let documentsUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
    var weatherArray = [Weather]()
    var FootballTeamArray = [FootballTeam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadWeatherButton(_ sender: Any) {
        let downloadWeather = FileDownloader()
        downloadWeather.downloadFileFromURL("weather.dat", weatherUrl)
    }
    
    @IBAction func printWeatherButton(_ sender: Any) {
        let printWeather = DataPrinter()
        let resultWeather = printWeather.printTheDay("weather.dat")
        resultsLabel.text = resultWeather
    }
    
    @IBAction func downloadFootBallButton(_ sender: Any) {
        let downloadFootBall = FileDownloader()
        downloadFootBall.downloadFileFromURL("football.dat", footballUrl)
    }
    
    @IBAction func printFootBallButton(_ sender: Any) {
        let printTeam = DataPrinter()
        let resultTeam = printTeam.printTheTeam("football.dat")
        resultsLabel.text = resultTeam
    }
}
