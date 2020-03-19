//
//  EditStatisticsViewController.swift
//  MtG Assistant
//
//  Created by Maksym Baikovets on 26.02.2020.
//  Copyright © 2020 Maksym Baikovets. All rights reserved.
//

import UIKit
import CoreData

class EditStatisticsViewController: UITableViewController, UITextFieldDelegate {

    var statisticsDataSource = StatisticsDataSource()
    var coreHeadlines: [NSManagedObject] = []
    var data: StatisticsHeadline?
    
    // -------------------------------------------------------------------
    // MARK: Outlets
    // -------------------------------------------------------------------
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var firstPlayerName: TextField!
    @IBOutlet weak var secondPlayerName: TextField!
    
    @IBOutlet weak var firstPlayerDeck: TextField!
    @IBOutlet weak var secondPlayerDeck: TextField!
    
    @IBOutlet weak var resultLabel: TextField!
    @IBOutlet weak var dateLabel: TextField!
    
    private func commonInit() {
        guard let data = data else { return }

        firstPlayerName.text = data.firstPlayer
        secondPlayerName.text = data.secondPlayer

        firstPlayerDeck.text = data.firstPlayerDeck
        secondPlayerDeck.text = data.secondPlayerDeck

        resultLabel.text = data.result
        dateLabel.text = data.date

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()

        cancelButton.title = NSLocalizedString("Cancel", comment: "")
        saveButton.title = NSLocalizedString("Save", comment: "")
        
        datePickerCreate()
    }
    
    func datePickerCreate() {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        dateLabel.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged),
                                 for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        print([identifier])
        
        guard let firstPlayerLabel = firstPlayerName.text else { return false }
        guard let secondPlayerLabel = secondPlayerName.text else { return false }

        guard let firstDeck = firstPlayerDeck.text else { return false }
        guard let secondDeck = secondPlayerDeck.text else { return false }

        guard let result = resultLabel.text else { return false }
        guard let date = dateLabel.text else { return false }

        if identifier == "SaveUpdatedStatistics" {
            
            // TODO: Check fields for correctness and show errors on form
            while true {
                var alertTitle = String()
                var alertMessage = String()
                
                if firstPlayerLabel == "" {
                    alertTitle = "Field Missing"
                    alertMessage = "Enter First Player name!"
                }
                
                else if secondPlayerLabel == "" {
                    alertTitle = "Field Missing"
                    alertMessage = "Enter Second Player name!"
                }
                    
                else if firstDeck == "" {
                    alertTitle = "Field Missing"
                    alertMessage = "Enter First Deck name!"
                }
                    
                else if secondDeck == "" {
                    alertTitle = "Field Missing"
                    alertMessage = "Enter Second Deck name!"
                }
                    
                else if result == "" {
                    alertTitle = "Field Missing"
                    alertMessage = "Enter Result of the game!"
                }
                    
                else if date == "" {
                    alertTitle = "Field Missing"
                    alertMessage = "Enter date of the game!"
                }
                    
                else {
                    break
                }
                    
                let alertController = UIAlertController(
                    title: alertTitle,
                    message: alertMessage,
                    preferredStyle: .alert
                )
                    
                alertController.addAction(UIAlertAction(
                    title: NSLocalizedString("Done", comment: ""),
                    style: .default,
                    handler: nil))

                present(alertController, animated: true, completion: nil)
                return false
                
            }
            
            statisticsDataSource.saveToCoreData(firstPlayer: firstPlayerLabel,
                                                secondPlayer: secondPlayerLabel,
                                                firstDeck: firstDeck,
                                                secondDeck: secondDeck,
                                                result: result, date: date)

            data = StatisticsHeadline(firstPlayer: firstPlayerLabel,
                                      secondPlayer: secondPlayerLabel,
                                      date: date,
                                      result: result,
                                      firstPlayerDeck: firstDeck,
                                      secondPlayerDeck: secondDeck
            )
            
            return true
            
        }
        
        return true
        
    }

}
