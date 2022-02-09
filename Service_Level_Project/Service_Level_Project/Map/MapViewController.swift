//
//  MapViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/08.
//

import UIKit
import CoreLocation
import NMapsMap

final class MapViewController: BaseViewController {
    
    let mapView = NMFMapView(frame: .zero).then {
        $0.positionMode = .direction
    }
    
    let genderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    let allSelectButton = ButtonConfiguration(customType: .h48(type: .fill, icon: false)).then {
        $0.setTitle("전체", for: .normal)
        $0.layer.borderWidth = 0
        $0.layer.cornerRadius = 0
    }
    let maleSelectButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
        $0.setTitle("남자", for: .normal)
        $0.layer.borderWidth = 0
        $0.layer.cornerRadius = 0
    }
    let femaleSelectButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
        $0.setTitle("여자", for: .normal)
        $0.layer.borderWidth = 0
        $0.layer.cornerRadius = 0
    }
    
    let myPlaceButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
        $0.setImage(UIImage(named: "place"), for: .normal)
//        let place = NMFNaverMapView().showLocationButton
    }
    
    let matchButton = UIButton().then {
        $0.setImage(UIImage(named: "friendsSearch"), for: .normal)
    }
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapAuthorizationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func configure() {
        view.backgroundColor = .blue
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func mapAuthorizationStatus() {
        let status = locationManager.authorizationStatus as! CLAuthorizationStatus
        if status.rawValue == 2 {
            locationManager.requestWhenInUseAuthorization()
            let alertPage = SeSacAlert("위치 권한 오류", "권한 미허용 시\n기타 서비스 및 새싹 친구 찾기를 진행하실 수 없습니다.") {
                self.dismiss(animated: true)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertPage.cancelButton.isHidden = true
            alertPage.modalPresentationStyle = .overFullScreen
            self.present(alertPage, animated: true, completion: nil)
        } else if status.rawValue == 4 {
            // 허용이라 패스
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func setConstraints() {
        view.addSubview(mapView)
        view.addSubview(genderStackView)
        genderStackView.addArrangedSubview(allSelectButton)
        genderStackView.addArrangedSubview(maleSelectButton)
        genderStackView.addArrangedSubview(femaleSelectButton)
        view.addSubview(myPlaceButton)
        view.addSubview(matchButton)
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.frame.width / 11)
            make.height.equalTo(genderStackView.snp.width).multipliedBy(3)
        }
        myPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(genderStackView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(genderStackView)
        }
        
        matchButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("Map: ",#function)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Map: ",#function)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Map: ",#function)
    }
    
    // iOS 15 기준으로 하고 나중에 시간되면 분기 처리(얼럿 뜰 때 나옴)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServiceAuthorization()
    }
    
    // 요청여부에 따라서 안내
    func checkUserLocationServiceAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        checkMyPlace(authorizationStatus)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            let alertPage = SeSacAlert("위치 권한 오류", "권한 미허용 시 기타 서비스 및 새싹 친구 찾기를 진행하실 수 없습니다.") {
                self.dismiss(animated: true)
            }
            alertPage.cancelButton.isHidden = true
            alertPage.modalPresentationStyle = .overFullScreen
            self.present(alertPage, animated: true, completion: nil)
        }
    }

    // 요청 Alert확인 시 액션
    func checkMyPlace(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse :
            locationManager.startUpdatingLocation()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined, .restricted :
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Map: unknown default")
        }
    }
}
