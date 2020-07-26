//  ViewController.swift
//  tip
//  Created by Zubair Shaik on 7/22/20.
//  Copyright © 2020 Codepath. All rights reserved.

import UIKit
import CoreLocation
import MapKit
import Foundation

class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
   
   @IBOutlet weak var totalLabel: UILabel!
   @IBOutlet weak var tipPercentageLabel: UILabel!
   @IBOutlet weak var billAmountTextField: UITextField!
   @IBOutlet weak var tipControl: UISegmentedControl!
   @IBOutlet weak var tipAmountLabel: UILabel!
   @IBOutlet weak var currencyLabel: UILabel!
   @IBOutlet weak var symbolLabel: UILabel!

   override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "Tip Calculator"
      let locationManager = CLLocationManager()
       locationManager.delegate = self
       locationManager.startMonitoringSignificantLocationChanges()
      let currentLocation = NSLocale.current
      currencyLabel.text = currentLocation.currencyCode
      symbolLabel.text = currentLocation.currencySymbol
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
      let userData = UserDefaults.standard
      let updatedDefaultTip = userData.integer(forKey: "defaultTip")
      tipPercentageLabel.text = String(format: "%.3f", updatedDefaultTip)
      let backgroundTheme = userData.string(forKey: "colorTheme")
      self.view.isOpaque = false
      switch backgroundTheme
      {
      case "Blue":
         self.view.backgroundColor = UIColor(hue: 0.5, saturation: 0.66, brightness: 0.66, alpha: 1)
         
      case "Green":
         self.view.backgroundColor = UIColor(hue: 0.25, saturation: 0.66, brightness: 0.66, alpha: 1)
      case "White":
         self.view.backgroundColor = UIColor.white
      case "Red":
         self.view.backgroundColor = UIColor(hue: 0, saturation: 0.66, brightness: 0.66, alpha: 1)
      case "Yellow":
         self.view.backgroundColor = UIColor.yellow
      default:
         self.view.backgroundColor = UIColor.white
      }
   }

   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
      billAmountTextField.becomeFirstResponder()
      let userData = UserDefaults.standard
      let updatedDefaultTip = userData.double(forKey: "defaultTip")
      let bill = Double(billAmountTextField.text!) ?? 0
      tipPercentageLabel.text = String(format: "%.3f", ((updatedDefaultTip * bill)/100))
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
   }

   override func viewDidDisappear(_ animated: Bool) {
       super.viewDidAppear(animated)
   }
   
   @IBAction func onTap(_ sender: Any) {
      let userData = UserDefaults.standard
      userData.synchronize()
   }

   @IBAction func calculateTip(_ sender: Any) {
      //get initial bill amount and calculate tips
      let bill = Double(billAmountTextField.text!) ?? 0
      let tipPercentages = [0.15,0.18,0.20]
      
      //calculate tip and total
      let userData = UserDefaults.standard
      let updatedDefaultTip = userData.integer(forKey: "defaultTip")
      var tip = Double()
      var tipAmount = Double()
      if updatedDefaultTip == 0
      {
         tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
         tipAmount = tipPercentages[tipControl.selectedSegmentIndex]
      }else
      {
         tip = Double(Double(Int(bill) * updatedDefaultTip) / 100)
         tipAmount = Double(Double(updatedDefaultTip)/100)
      }
      let finalBill = tip + bill
      
      //update the tip and total labels
      tipAmountLabel.text = String(format: "%.3f", tipAmount)
      tipPercentageLabel.text = String(format: "%.3f", tip)
      totalLabel.text = String(format: "%.3f", finalBill)
   }
   
}

