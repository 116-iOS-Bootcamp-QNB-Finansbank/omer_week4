//
//  ContentView.swift
//  LocationPermission
//
//  Created by Ömer Köse on 28.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let locationServices = CLLocationManager()
    private var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusLabel()
        initalizeLocationServices()
    }
    
    private func initalizeLocationServices() {
        locationServices.delegate = self
        
        /* Allow application to update location in the background */
        locationServices.allowsBackgroundLocationUpdates = true
        /* Notify the user about the usage of the location via the background location indicator*/
        locationServices.showsBackgroundLocationIndicator = true
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        /* Request the location from the user */
        locationServices.requestAlwaysAuthorization()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        /* Cases above is to display or execute specific actions for the application depending on
         the location permission given by the user, also display the current permission status as an output
         in the console */
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationServicesNeededState()
        case .denied:
            print("denied")
            promptForAuthorization()
        case .restricted:
            print("restricted")
            locationServicesRestrictedState()
        case .authorizedAlways:
            print("authorizedAlways")
            /* Start updating location of the user when given permission */
            locationServices.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            /* Start updating location of the user when given permission */
            locationServices.startUpdatingLocation()
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}

extension ViewController {
    private func setupStatusLabel() {
        statusLabel = UILabel(frame: .zero)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 24)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
                                        statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                                        statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                        statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -16)
        ])
    }
    
    /* This function directs user to the settings when location permission is not given
     an alert box is being created for the user to interact
     first option to direct user to the settings of the device
     second is to cancel and terminate the permission process */
    func promptForAuthorization() {
        let alert = UIAlertController(title: "Location access is needed to get your current location", message: "Please allow access", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {
            _ in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            [weak self] _ in self?.locationServicesNeededState()
        })
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        alert.preferredAction = settingsAction
        
        present(alert, animated: true, completion: nil)
    }
    
    /* This function displays the current status of the permission given by the user (DENIED) */
    func locationServicesNeededState() {
        self.statusLabel.text = "Access to location services is needed."
    }
    
    /* This function displays the current status of the permission given by the user (RESTRICTED) */
    func locationServicesRestrictedState() {
        self.statusLabel.text = "The app is restricted from using the location servies."
    }
}


