//
//  PlacesViewController.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/12/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class PlacesViewController: UIViewController {
    
    let rentViewHeight = CGFloat(44)

    var places: [[String:Any]]!
    
    var viewModel = PlacesViewModel()
    
    @IBOutlet weak var mapViewMain: MKMapView!
    @IBOutlet weak var viewRent: UIView!
    @IBOutlet weak var labelRent: UILabel!
    @IBOutlet weak var constraintForRentViewBottomSpace: NSLayoutConstraint!
    
    var selectedPlaceAnnotation: PlaceAnnotation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapViewMain.delegate = self
        self.viewRent.isHidden = true
        processViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Jitensha"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppConfig.configAppPrimaryColorBlue,
                                                                        NSAttributedStringKey.font: UIFont(name: AppConfig.configAppLogoFontFamilyName, size: 15)!]
        
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "icon_listing"), style: .plain, target: self, action: #selector(onListing))
        leftBarItem.tintColor = Color.black
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "icon_signout"), style: .plain, target: self, action: #selector(onSignout))
        rightBarItem.tintColor = Color.black
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }

    @objc func onSignout() {
        let alert = UIAlertController(title: nil, message: "Are you sure to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.signout()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onListing() {
        self.performSegue(withIdentifier: "sid_payments", sender: nil)
    }

    func signout() {
        AppManager.shared.signout()
        var controllers = self.navigationController!.viewControllers
        for controller in controllers {
            if controller is LoginViewController {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        controllers[1] = loginViewController
        self.navigationController?.viewControllers = controllers
        self.navigationController?.popToViewController(loginViewController, animated: true)
    }
    
    func refreshMap(with places:[Place]) {
        
        if places.count == 0 {
            return
        }
        
        self.mapViewMain.removeAnnotations(self.mapViewMain.annotations)
        
        var minLatitude: Double = 90, minLongitude: Double = 180
        var maxLatitude: Double = -90, maxLongitude: Double = -180
        
        for place in places {
            
            if minLatitude > place.coordinate.latitude {
                minLatitude = place.coordinate.latitude
            }
            if minLongitude > place.coordinate.longitude {
                minLongitude = place.coordinate.longitude
            }
            if maxLatitude < place.coordinate.latitude {
                maxLatitude = place.coordinate.latitude
            }
            if maxLongitude < place.coordinate.longitude {
                maxLongitude = place.coordinate.longitude
            }
            
            self.mapViewMain.addAnnotation(place.annotation())
            
        }
        
        let mapPadding = 1.1
        let minimumVisibleLatitude = 0.01
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2),
                                        span: MKCoordinateSpan(latitudeDelta: max(minimumVisibleLatitude, (maxLatitude - minLatitude) * mapPadding), longitudeDelta: (maxLongitude - minLongitude) * mapPadding))
        
        let scaledRegion = self.mapViewMain.regionThatFits(region)
        self.mapViewMain.setRegion(scaledRegion, animated: true)
        
    }
    
    func processViewModel() {
        viewModel.loadPlaces()
        _ = viewModel.places.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (places) in
            guard let this = self else {return}
            this.refreshMap(with: places)
        })
    }
    
    @IBAction func onRent(_ sender: Any) {
        self.rentSelectedPlace()
    }
    
    func rentSelectedPlace() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPaymentViewController") as! NewPaymentViewController
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.viewModel.place.value = self.selectedPlaceAnnotation!.info
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
}

extension PlacesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKPinAnnotationView()
        annotationView.canShowCallout = true
        let calloutButton = UIButton(type: .detailDisclosure)
        calloutButton.setImage(UIImage(named:"icon_arrow_to_right_black"), for: .normal)
        calloutButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        annotationView.rightCalloutAccessoryView = calloutButton
//        annotationView.rightCalloutAccessoryView = UIImageView(image: UIImage(named:"icon_arrow_to_right_black"))//calloutButton
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        self.selectedPlaceAnnotation = view.annotation as? PlaceAnnotation ?? nil
        if self.selectedPlaceAnnotation != nil {
            self.labelRent.text = "Rent \(self.selectedPlaceAnnotation!.title ?? "")"
        }
        if self.viewRent.isHidden {
            self.showRentView()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // hide rent view if no other annotation selected, need a little delaying to check if other annoation has been selected.
        self.selectedPlaceAnnotation = nil
        self.perform(#selector(checkDeselect), with: nil, afterDelay: 0.2)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.rentSelectedPlace()
    }
    
    @objc func checkDeselect() {
        if self.selectedPlaceAnnotation == nil {
            self.hideRentView()
        }
    }
    
    func showRentView() {
        self.viewRent.isHidden = false
        self.constraintForRentViewBottomSpace.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
        }
    }
    
    func hideRentView() {
        self.constraintForRentViewBottomSpace.constant = 44
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.viewRent.isHidden = true
            }
        }
    }
}
