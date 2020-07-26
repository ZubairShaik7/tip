//
//  SettingsViewController.swift
//  tip
//
//  Created by Zubair Shaik on 7/22/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
  
   @IBOutlet weak var defaultTipLabel: UILabel!
   @IBOutlet weak var defaultTipText: UITextField!
   @IBOutlet weak var colorSelector: UIPickerView!
   @IBOutlet weak var themeLabel: UILabel!
   @IBOutlet weak var mapView: MKMapView!
   
   let locationManager = CLLocationManager()
   var currentLocation = CLLocation?.self
   
   let pickerData = ["Blue", "Green", "White", "Red", "Yellow"]
   let mainScreen = ViewController.self
   
   override func viewWillAppear(_ animated: Bool) {
      let userData = UserDefaults.standard
      let backgroundTheme = userData.string(forKey: "colorTheme")
      let defaultTip = userData.double(forKey: "defaultTip")
      defaultTipText.text = String(defaultTip)
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

    override func viewDidLoad() {
        super.viewDidLoad()
         // Sets the title in the Navigation Bar
        self.title = "Tip Calculator"
      colorSelector.dataSource = self
      colorSelector.delegate = self
      let row = UserDefaults.standard.integer(forKey: "pickerViewRow")
      colorSelector.selectRow(row, inComponent: 0, animated: false)
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
      self.locationManager.requestAlwaysAuthorization()
      mapView.delegate = self
      mapView.showsUserLocation = true
      if CLLocationManager.locationServicesEnabled()
      {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.startUpdatingLocation()
      }
    }
   
   @objc func dismissKeyboard() {
       //Causes the view (or one of its embedded text fields) to resign the first responder status.
       view.endEditing(true)
   }
   
   func selectRow(_ row: Int,
   inComponent component: Int,
   animated: Bool){}
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     if let location = locations.last{
         let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
         let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
         self.mapView.setRegion(region, animated: true)
     }
   }
   
   @IBAction func onTap(_ sender: Any) {
      let userData = UserDefaults.standard
      userData.synchronize()
   }
   
   @IBAction func dafualtTipDecider(_ sender: Any) {
      let defaultTip = Double(defaultTipText.text!) ?? 0
      let userData = UserDefaults.standard
      userData.set(defaultTip, forKey: "defaultTip")
      userData.synchronize()
   }
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int
     {
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     {
        return pickerData.count
      }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
   {
         return pickerData[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
   {
      let userData = UserDefaults.standard
      UserDefaults.standard.set(row,forKey: "pickerViewRow")
      switch pickerData[row]
      {
      case "Blue":
         self.view.backgroundColor = UIColor(hue: 0.5, saturation: 0.66, brightness: 0.66, alpha: 1)
         userData.set("Blue", forKey: "colorTheme")
      case "Green":
         self.view.backgroundColor = UIColor(hue: 0.25, saturation: 0.66, brightness: 0.66, alpha: 1)
         userData.set("Green", forKey: "colorTheme")
      case "White":
         self.view.backgroundColor = UIColor.white
         userData.set("White", forKey: "colorTheme")
      case "Red":
         self.view.backgroundColor = UIColor(hue: 0, saturation: 0.66, brightness: 0.66, alpha: 1)
         userData.set("Red", forKey: "colorTheme")
      case "Yellow":
         self.view.backgroundColor = UIColor.yellow
         userData.set("Yellow", forKey: "colorTheme")
      default:
         self.view.backgroundColor = UIColor.white
      }
      userData.synchronize()
   }
}
