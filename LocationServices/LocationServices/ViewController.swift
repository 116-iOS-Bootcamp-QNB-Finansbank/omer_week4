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
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationServices.requestAlwaysAuthorization()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
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
    
    func locationServicesNeededState() {
        self.statusLabel.text = "Access to locaiton services is needed."
    }
    
    func locationServicesRestrictedState() {
        self.statusLabel.text = "The app is restricted from using the location servies."
    }
}


