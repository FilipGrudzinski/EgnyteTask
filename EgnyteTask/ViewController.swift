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
        downloadFileFromURL("weather.dat", weatherUrl)
    }
    
    @IBAction func printWeatherButton(_ sender: Any) {
        let documentsUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let path = documentsUrl.appendingPathComponent("football.dat").path
        do {
            // Read an entire text file into an NSString.
            let contents = try? NSString(contentsOfFile: path,
                                         encoding: String.Encoding.ascii.rawValue)
            print(contents!)
            // Print all lines.
            contents!.enumerateLines({ (line, stop) -> () in
                print("Line = \(line)")
            })
        }
    }
    @IBAction func downloadFootBallButton(_ sender: Any) {
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
            replacePopUp(fileName, url, destinationFileUrl)
        } else {
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                        self.saveItem(tempLocalUrl, destinationFileUrl)
                    }
                } else {
                    print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "")
                    self.successPopUp("Try again later")
                }
            }
            task.resume()
        }
    }
    
    private func saveItem(_ tempLocalUrl: URL, _ destinationFileUrl: URL) {
        do {
            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
            successPopUp("Successfully saved")
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
        }
    }
    
    private func successPopUp(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func replacePopUp(_ fileName: String, _ url: String, _ destinationFileUrl: URL)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "File Exist", message: "Replace?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {(UIAlertAction) in self.replaceExistingFile(fileName, url, destinationFileUrl) }
            let noAction = UIAlertAction(title: "No", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func replaceExistingFile(_ fileName: String, _ url: String, _ destinationFileUrl: URL){
        do {
            try FileManager.default.removeItem(at: destinationFileUrl)
            self.downloadFileFromURL(fileName, url)
        } catch (let writeError) {
            print("Error removing a file \(destinationFileUrl) : \(writeError)")
        }
        dismissPopUp()
    }
    
    private func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
}
