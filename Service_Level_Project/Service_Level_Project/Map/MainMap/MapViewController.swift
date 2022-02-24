//
//  MapViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/08.
//

import UIKit
import CoreLocation
import NMapsMap
import RxSwift

final class MapViewController: BaseViewController {
    
    let mapView = NMFMapView(frame: .zero).then {
        $0.positionMode = .direction
    }
    let mapMiddleMarker = UIImageView().then {
        $0.image = UIImage(named: "map_marker")
        $0.isHidden = true
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
    }
    
    let matchButton = UIButton().then {
        $0.setImage(UIImage(named: "friendsSearch"), for: .normal)
    }
    
    private lazy var input = MapViewModel.Input(mapView: mapView)
    lazy var output = viewModel.transform(input: input)
    
    let viewModel = MapViewModel()
    private let disposeBag = DisposeBag()
    
    var recommendDB = [String]()
    var aroundDB = [String]()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        //FCM Token
        print("내 id 토큰 :",UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken))
        SeSacURLNetwork.shared.updateFCMToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapAuthorizationStatus()
        self.navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.tabBarController?.tabBar.isHidden = false
        let mapIconName = UserDefaults.standard.string(forKey: UserDefaultsManager.mapButton)
        if let mapIconName = mapIconName {
            matchButton.setImage(UIImage(named: mapIconName), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func bind() {
        allSelectButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.allSelectButton.customLayout(.fill)
                self.maleSelectButton.customLayout(.inactive)
                self.femaleSelectButton.customLayout(.inactive)
                self.viewModel.genderFilterNumber = 2
                self.viewModel.insertMarkerFriendsInMap(map: self.mapView)
            })
            .disposed(by: disposeBag)
        
        maleSelectButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.allSelectButton.customLayout(.inactive)
                self.maleSelectButton.customLayout(.fill)
                self.femaleSelectButton.customLayout(.inactive)
                self.viewModel.genderFilterNumber = 0
                self.viewModel.insertMarkerFriendsInMap(map: self.mapView)
            })
            .disposed(by: disposeBag)
        
        femaleSelectButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.allSelectButton.customLayout(.inactive)
                self.maleSelectButton.customLayout(.inactive)
                self.femaleSelectButton.customLayout(.fill)
                self.viewModel.genderFilterNumber = 1
                self.viewModel.insertMarkerFriendsInMap(map: self.mapView)
            })
            .disposed(by: disposeBag)
        
        myPlaceButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.mapMiddleMarker.isHidden = true
                self.viewModel.currentCameraMoveToUser(map: self.mapView)
                self.viewModel.makeCircleInMap(overlay: self.mapView.locationOverlay)
            })
            .disposed(by: disposeBag)
        
        matchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                // 화면 분기 처리
                
                 
                if let mapIconName = UserDefaults.standard.string(forKey: UserDefaultsManager.mapButton) {
                    switch mapIconName {
                    case SeSacMapButtonImageManager.imageName(0):
                        let vc = HobbyViewController()
                        vc.recommendHobby = self.recommendDB
                        vc.aroundHobby = self.aroundDB
                        self.navigationController?.pushViewController(vc, animated: true)
                    case SeSacMapButtonImageManager.imageName(1):
                        let vc = SearchFriendsViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    case SeSacMapButtonImageManager.imageName(2):
                        let vc = ChattingViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    default:
                        break
                    }
                } else {
                    let hobbyVC = HobbyViewController()
                    
                    hobbyVC.recommendHobby = self.recommendDB
                    hobbyVC.aroundHobby = self.aroundDB
                    
                    self.navigationController?.pushViewController(hobbyVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.placeData.asDriver()
            .drive(onNext: { [weak self] model in
                guard let self = self else { return }
                self.recommendDB = []
                self.aroundDB = []
                
                model.fromQueueDB.forEach { data in
                    guard let data = data else {return}
                    data.hf.forEach { hobby in
                        self.aroundDB.append(hobby)
                    }
                }
                self.recommendDB = model.fromRecommend
            })
            .disposed(by: disposeBag)
        
        viewModel.insertMarkerFriendsInMap(map: mapView)
    }
    
    override func configure() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.addCameraDelegate(delegate: self)
    }
    
    func mapAuthorizationStatus() {
        let status = locationManager.authorizationStatus as! CLAuthorizationStatus
        if status.rawValue == 2 {
            locationManager.requestWhenInUseAuthorization()
            let alertPage = SeSacAlert("위치 권한 오류", "권한 미허용 시\n기타 서비스 및 새싹 친구 찾기를 진행하실 수 없습니다. 이동하시겠습니까?") {
                self.dismiss(animated: true)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertPage.modalPresentationStyle = .overFullScreen
            self.present(alertPage, animated: true, completion: nil)
            viewModel.currentCameraMoveToUser(map: mapView)
//            viewModel.makeMarkerUserInMap(map: mapView)
        } else if status.rawValue == 4 {
            // 허용이라 패스
            viewModel.currentCameraMoveToUser(map: mapView)
//            viewModel.makeMarkerUserInMap(map: mapView)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func setConstraints() {
        view.addSubview(mapView)
        view.addSubview(mapMiddleMarker)
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
        
        mapMiddleMarker.snp.makeConstraints { make in
            make.center.equalTo(mapView)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(view.frame.width / 9)
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
