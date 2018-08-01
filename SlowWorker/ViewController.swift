//
//  ViewController.swift
//  SlowWorker
//
//  Created by klarheit on 31/07/2018.
//  Copyright © 2018 klarheit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultsTextView: UITextView!
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // spinner.stopAnimating()
    }

    func fetchSomethingFromServer() -> String {
        Thread.sleep(forTimeInterval: 1)
        return "Hi there"
    }
    
    func processData(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 2)
        return data.uppercased()
    }
    
    func calculateFirstResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 3)
        return "Number of chars: \(data.count)"
    }
    
    func calculateSecondResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 4)
        return data.replacingOccurrences(of: "E", with: "e")
    }
    
    @IBAction func doWork(_ sender: UIButton) {
        let startTime = NSDate()
        self.resultsTextView.text = ""
        startButton.isEnabled = false
        spinner.startAnimating()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchedData)
            var firstResult: String!
            var secondResult: String!
            
            let group = DispatchGroup()
            queue.async(group: group) {
                firstResult = self.calculateFirstResult(processedData)
            }
            queue.async(group: group) {
                secondResult = self.calculateSecondResult(processedData)
            }
            group.notify(queue: queue) {
                let resultsSummary = "First: [\(firstResult!))]\nSecond: [\(secondResult!)]"
                let endTime = NSDate()
                let str = "Completed in \(endTime.timeIntervalSince(startTime as Date)) seconds"
                DispatchQueue.main.async {
                    self.resultsTextView.text = resultsSummary + "\n" + str
                    self.startButton.isEnabled = true
                    self.spinner.stopAnimating()
                }
            }
        }
    }
}

