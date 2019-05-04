//
//  ViewController.swift
//  EgnyteTask
//
//  Created by Filip on 02/05/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

struct Weather {
    let dayNumber: String
    let tempSpread: Double
}
struct FootballTeam {
    let team: String
    let difference: Double
}

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
        if !resultWeather.isEmpty {
            resultsLabel.text = resultWeather
        } else {
            resultsLabel.text = "No file downloaded"
        }
    }
    
    @IBAction func downloadFootBallButton(_ sender: Any) {
        let downloadFootBall = FileDownloader()
        downloadFootBall.downloadFileFromURL("football.dat", footballUrl)
    }
    
    @IBAction func printFootBallButton(_ sender: Any) {
       // printTheTeam("football.dat")
    }
    
}


//    func downloadFileFromURL(_ fileName: String, _ url: String) {
//        // Create destination URL
//        let documentsUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
//        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
//        //Create URL to the source file you want to download
//        let fileURL = URL(string: url)
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//        let request = URLRequest(url:fileURL!)
//
//        if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
//            replacePopUp(fileName, url, destinationFileUrl)
//        } else {
//            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
//                if let tempLocalUrl = tempLocalUrl, error == nil {
//                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                        print("Successfully downloaded. Status code: \(statusCode)")
//                        self.saveItem(tempLocalUrl, destinationFileUrl)
//                    }
//                } else {
//                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "")
//                    self.successPopUp("Try again later")
//                }
//            }
//            task.resume()
//        }
//    }
    
//    private func saveItem(_ tempLocalUrl: URL, _ destinationFileUrl: URL) {
//        do {
//            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
//            successPopUp("Successfully saved")
//        } catch (let writeError) {
//            print("Error creating a file \(destinationFileUrl) : \(writeError)")
//        }
//    }
    
//    private func replaceExistingFile(_ fileName: String, _ url: String, _ destinationFileUrl: URL){
//        do {
//            try FileManager.default.removeItem(at: destinationFileUrl)
//            //self.downloadFileFromURL(fileName, url)
//        } catch (let writeError) {
//            print("Error removing a file \(destinationFileUrl) : \(writeError)")
//        }
//        dismissPopUp()
//    }
//    
//    private func successPopUp(_ message: String) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Ok", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
//            
//            alert.addAction(okAction)
//            
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    private func replacePopUp(_ fileName: String, _ url: String, _ destinationFileUrl: URL)  {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "File Exist", message: "Replace?", preferredStyle: .alert)
//            let yesAction = UIAlertAction(title: "Yes", style: .default) {(UIAlertAction) in self.replaceExistingFile(fileName, url, destinationFileUrl) }
//            let noAction = UIAlertAction(title: "No", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
//            
//            alert.addAction(yesAction)
//            alert.addAction(noAction)
//            
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    private func dismissPopUp() {
//        dismiss(animated: true, completion: nil)
//    }
    
//    private func removeSpecialCharsFromString(text: String) -> String {
//        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+=().!_")
//        return text.filter {okayChars.contains($0) }
//    }
    
//    private func printTheDay(_ filePathName: String) {
//        let path = documentsUrl.appendingPathComponent(filePathName).path
//        do {
//            if let contents = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
//                let lines = contents.components(separatedBy: "\n")
//                for i in 2..<lines.count {
//                    if lines[i].count != 0 {
//                        let data = lines[i].split(separator: " ")
//                        let day = String(data[0])
//                        guard let max = Double(self.removeSpecialCharsFromString(text: String(data[1]))) else {
//                            return
//                        }
//                        guard let min = Double(self.removeSpecialCharsFromString(text: String(data[2]))) else {
//                            return
//                        }
//                        let spread = max - min
//                        let new = Weather(dayNumber: day, tempSpread: spread)
//                        weatherArray.append(new)
//                    }
//                }
//            }
//        }
//        let sortedArray = weatherArray.sorted(by: { $0.tempSpread < $1.tempSpread })
//        resultsLabel.text = ("Day with the smallest temperature spread is \(sortedArray[0].dayNumber)")
//    }
    
//    private func printTheTeam(_ filePathName: String) -> String {
//        let path = documentsUrl.appendingPathComponent("football.dat").path
//        do {
//            if let contents = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
//                let lines = contents.components(separatedBy: "\n")
//                for i in 0..<lines.count {
//                    let data = lines[i].split(separator: " ")
//                    if data.count > 8 {
//                        let day = String(data[1])
//                        guard let max = Double(self.removeSpecialCharsFromString(text: String(data[6]))) else {
//                            return "No Item"
//                        }
//                        guard let min = Double(self.removeSpecialCharsFromString(text: String(data[8]))) else {
//                            return "No Item"
//                        }
//                        let spread = max - min
//                        let new = FootballTeam(team: day, difference: spread)
//                        FootballTeamArray.append(new)
//                    }
//                }
//            }
//        }
//        let sortedArray = FootballTeamArray.sorted(by: { $0.difference < $1.difference })
//        return "The team with the smallest difference is \(sortedArray[0].team)"
//    }
//
//    func printTheDay(_ filePathName: String) -> String {
//        let path = documentsUrl.appendingPathComponent(filePathName).path
//        do {
//            if let contents = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
//                let lines = contents.components(separatedBy: "\n")
//                for i in 2..<lines.count {
//                    if lines[i].count != 0 {
//                        let data = lines[i].split(separator: " ")
//                        let day = String(data[0])
//                        guard let max = Double(self.removeSpecialCharsFromString(text: String(data[1]))) else {
//                            return "No Item"
//                        }
//                        guard let min = Double(self.removeSpecialCharsFromString(text: String(data[2]))) else {
//                            return "No Item"
//                        }
//                        let spread = max - min
//                        let new = Weather(dayNumber: day, tempSpread: spread)
//                        weatherArray.append(new)
//                    }
//                }
//            }
//        }
//        let sortedArray = weatherArray.sorted(by: { $0.tempSpread < $1.tempSpread })
//        return "Day with the smallest temperature spread is \(sortedArray[0].dayNumber)"
//    }
