//
//  ViewController.swift
//  ArkitCoreLocationSample
//
//  Created by kotanbo on 2023/03/13.
//

import UIKit
import ARKit_CoreLocation
import CoreLocation

class ViewController: UIViewController {

    var sceneLocationView = SceneLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(sceneLocationView)

        let latitudeText = UITextField()
        latitudeText.placeholder = "緯度"
        latitudeText.keyboardType = .decimalPad
        latitudeText.borderStyle = .roundedRect
        latitudeText.returnKeyType = .done
        latitudeText.clearButtonMode = .always
        view.addSubview(latitudeText)
        latitudeText.translatesAutoresizingMaskIntoConstraints = false
        latitudeText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        latitudeText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true

        let longitudeText = UITextField()
        longitudeText.placeholder = "経度"
        longitudeText.keyboardType = .decimalPad
        longitudeText.borderStyle = .roundedRect
        longitudeText.returnKeyType = .done
        longitudeText.clearButtonMode = .always
        view.addSubview(longitudeText)
        longitudeText.translatesAutoresizingMaskIntoConstraints = false
        longitudeText.topAnchor.constraint(equalTo: latitudeText.topAnchor).isActive = true
        longitudeText.leftAnchor.constraint(equalTo: latitudeText.rightAnchor, constant: 10).isActive = true

        let altitudeText = UITextField()
        altitudeText.placeholder = "高度"
        altitudeText.keyboardType = .decimalPad
        altitudeText.borderStyle = .roundedRect
        altitudeText.returnKeyType = .done
        altitudeText.clearButtonMode = .always
        view.addSubview(altitudeText)
        altitudeText.translatesAutoresizingMaskIntoConstraints = false
        altitudeText.topAnchor.constraint(equalTo: latitudeText.bottomAnchor, constant: 10).isActive = true
        altitudeText.leftAnchor.constraint(equalTo: latitudeText.leftAnchor).isActive = true

        let saveButton = UIButton(configuration: .filled())
        saveButton.setTitle("ピン追加", for: .normal)
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: altitudeText.topAnchor).isActive = true
        saveButton.leftAnchor.constraint(equalTo: altitudeText.rightAnchor, constant: 10).isActive = true
        let addPin = {
            latitudeText.resignFirstResponder()
            longitudeText.resignFirstResponder()
            altitudeText.resignFirstResponder()
            if latitudeText.text?.isEmpty ?? true {
                return
            }
            if longitudeText.text?.isEmpty ?? true {
                return
            }
            if altitudeText.text?.isEmpty ?? true {
                return
            }

            let coordinate = CLLocationCoordinate2D(
                latitude: Double(latitudeText.text!) ?? 0,
                longitude: Double(longitudeText.text!) ?? 0
            )
            let location = CLLocation(coordinate: coordinate, altitude: Double(altitudeText.text!) ?? 0)
            let image = UIImage(named: "map_pin")!

            let annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.scaleRelativeToDistance = true
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

            let alert = UIAlertController(title: "確認", message: "追加しました。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        saveButton.addAction(.init { _ in addPin() }, for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        sceneLocationView.pause()
        super.viewWillDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
