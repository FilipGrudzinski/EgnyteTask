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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadWeatherButton(_ sender: Any) {
        print("downloadWeatherButton")
        downloadFileFromURL("weather.dat", weatherUrl)
    }
    
    @IBAction func printWeatherButton(_ sender: Any) {
        print("printWeatherButton")
    }
    @IBAction func downloadFootBallButton(_ sender: Any) {
        print("downloadFootBallButton")
        downloadFileFromURL("football.dat", footballUrl)
    }
    @IBAction func printFootBallButton(_ sender: Any) {
        print("printFootBallButton")
    }
    
    func downloadFileFromURL(_ fileName: String, _ url: String) {
        // Create destination URL
        let documentsUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        //Create URL to the source file you want to download
        let fileURL = URL(string: url)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        
        if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
            popUp(fileName, url, destinationFileUrl)
        } else {
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                    self.saveItem(tempLocalUrl, destinationFileUrl)
                } else {
                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "");
                }
            }
            task.resume()
        }
    }
    
    private func saveItem(_ tempLocalUrl: URL, _ destinationFileUrl: URL) {
        do {
            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
            print("Successfully saved")
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
        }
    }
    
    private func popUp(_ fileName: String, _ url: String, _ destinationFileUrl: URL)  {
        let alert = UIAlertController(title: "Warning", message: "File Exist Replace", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {(UIAlertAction) in self.replaceExistingFile(fileName, url, destinationFileUrl) }
        let noAction = UIAlertAction(title: "No", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func replaceExistingFile(_ fileName: String, _ url: String, _ destinationFileUrl: URL){
        do {
            try FileManager.default.removeItem(at: destinationFileUrl)
            print("Successfully removed")
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
        }
        downloadFileFromURL(fileName, url)
    }
    
    private func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
}
