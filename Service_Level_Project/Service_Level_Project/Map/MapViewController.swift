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
    
    override func configure() {
        view.backgroundColor = .blue
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

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
    // iOS 15 기준으로 하고 나중에 시간되면 분기 처리
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
        print("여기는 언제 나오는 거냐;")
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 on 상태")
            locationManager.startUpdatingLocation()
            print("위치 서비스 : ", locationManager.location?.coordinate)
        } else {
            print("위치 서비스 off 상태")
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
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("접근 ㄴㄴ 사람들")
        case .denied:
            print("거부되어 있음")
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorized:
            print("default")
        @unknown default:
            print("default")
        }
    }
}
