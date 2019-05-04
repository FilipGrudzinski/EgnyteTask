//
//  FileDownloader.swift
//  EgnyteTask
//
//  Created by Filip on 04/05/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class FileDownloader: ViewController {
    func downloadFileFromURL(_ fileName: String, _ url: String) {
        // Create destination URL
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
            self.successPopUp("Successfully saved")
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
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
    
    private func successPopUp(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
            
            alert.addAction(okAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func replacePopUp(_ fileName: String, _ url: String, _ destinationFileUrl: URL)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "File Exist", message: "Replace?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {(UIAlertAction) in self.replaceExistingFile(fileName, url, destinationFileUrl) }
            let noAction = UIAlertAction(title: "No", style: .cancel) {(UIAlertAction) in self.dismissPopUp()}
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
}
