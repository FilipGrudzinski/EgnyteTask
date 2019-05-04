//
//  DataPrinter.swift
//  EgnyteTask
//
//  Created by Filip on 04/05/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class DataPrinter: ViewController {
    private func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+=().!_")
        return text.filter {okayChars.contains($0) }
    }
    
    func printTheTeam(_ filePathName: String) -> String {
        let path = documentsUrl.appendingPathComponent("football.dat").path
        if FileManager.default.fileExists(atPath: path) {
            do {
                if let contents = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
                    let lines = contents.components(separatedBy: "\n")
                    for i in 0..<lines.count {
                        let data = lines[i].split(separator: " ")
                        if data.count > 8 {
                            let day = String(data[1])
                            guard let max = Double(self.removeSpecialCharsFromString(text: String(data[6]))) else {
                                return "No Item"
                            }
                            guard let min = Double(self.removeSpecialCharsFromString(text: String(data[8]))) else {
                                return "No Item"
                            }
                            let spread = max - min
                            let new = FootballTeam(team: day, difference: spread)
                            FootballTeamArray.append(new)
                        }
                    }
                }
            }
            let sortedArray = FootballTeamArray.sorted(by: { $0.difference < $1.difference })
            return "The team with the smallest difference is \(sortedArray[0].team)"
        } else {
            return "No data to print"
        }
    }
    
    func printTheDay(_ filePathName: String) -> String {
        let path = documentsUrl.appendingPathComponent(filePathName).path
        if FileManager.default.fileExists(atPath: path) {
            do {
                if let contents = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
                    let lines = contents.components(separatedBy: "\n")
                    for i in 2..<lines.count {
                        if lines[i].count != 0 {
                            let data = lines[i].split(separator: " ")
                            let day = String(data[0])
                            guard let max = Double(self.removeSpecialCharsFromString(text: String(data[1]))) else {
                                return "No Item"
                            }
                            guard let min = Double(self.removeSpecialCharsFromString(text: String(data[2]))) else {
                                return "No Item"
                            }
                            let spread = max - min
                            let new = Weather(dayNumber: day, tempSpread: spread)
                            weatherArray.append(new)
                        }
                    }
                }
            }
            let sortedArray = weatherArray.sorted(by: { $0.tempSpread < $1.tempSpread })
            return "Day with the smallest temperature spread is \(sortedArray[0].dayNumber)"
        } else {
            return "No data to print"
        }
    }
}
