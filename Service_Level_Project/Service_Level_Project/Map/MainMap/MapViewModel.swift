//
//  MapViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/09.
//

import Foundation

import CoreLocation
import NMapsMap

import RxSwift
import RxCocoa
import RxRelay

class MapViewModel: BaseViewModel {
    
    struct Input {
        let mapView: NMFMapView
    }
    
    struct Output {
        let placeData: Driver<SeSacSearchFreindsModel>
    }
    
    static var myData = PublishRelay<SeSacSearchFreindsModel>()
    private var allPlaceData = BehaviorRelay<SeSacSearchFreindsModel>(value: SeSacSearchFreindsModel())
    private var markData = Set<QueueData>()
    private var markfilterSet = Set<NMFMarker>()
    
    var locationManager = CLLocationManager()
    var genderFilterNumber = 2
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        MapViewModel.myData.asSignal()
            .emit(onNext: { [weak self] model in
                guard let self = self else { return }
                self.allPlaceData.accept(model)
            })
            .disposed(by: disposeBag)
        return Output(placeData: allPlaceData.asDriver())
    }
    
    func currentCameraMoveToUser(map: NMFMapView) -> Void {
        let place = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 37.517819364682694, lng: locationManager.location?.coordinate.longitude ?? 126.88647317074734 )
        let cameraUpdate = NMFCameraUpdate(scrollTo: place)
        cameraUpdate.animation = .easeIn
        
        map.minZoomLevel = 10.0
        map.maxZoomLevel = 18.0
        
        return map.moveCamera(cameraUpdate)
    }
    
    func makeCircleInMap(overlay: NMFLocationOverlay) {
        overlay.hidden = false
        // 위치 바꿔줄 떄
//        overlay.location = NMGLatLng(lat: 37.863700, lng: 126.985534)
        overlay.circleOutlineWidth = 0.1
        overlay.circleRadius = 70
    }
    
    /*
    func makeMarkerUserInMap(map: NMFMapView) {
        let place = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 37.517819364682694, lng: locationManager.location?.coordinate.longitude ?? 126.88647317074734 )
        
        //마커(이거 안지울거)
        let marker = NMFMarker()
        //제거
        //marker.mapView = nil
        //생성
        marker.position = place
        marker.mapView = map
        
        marker.iconImage = NMFOverlayImage(name: SeSacUserImageManager.imageName(0))
        marker.width = 80
        marker.height = 80
        marker.iconPerspectiveEnabled = true
        marker.isHideCollidedSymbols = false
    }
    */
    
    // 배열 추가(Set 타입) - > 안되던 오류 추가 수정한 건데 코드가 길어짐
    func insertMarkerFriendsInMap(map: NMFMapView) {
        self.allPlaceData.asDriver()
            .drive(onNext: { data in
                self.makeMarkDeleteInMap()
                if data.fromQueueDB != [] {
                    DispatchQueue.global().sync {
                        
                        for mark in data.fromQueueDB {
                            // 기본 데이터 적용
                            guard let mark = mark else { return }
                            self.markData.insert(mark)
                            // 필터 마크 적용
                            if self.genderFilterNumber != 2 {
                                if mark.gender == self.genderFilterNumber {
                                    self.markfilterSet.insert(NMFMarker(position: NMGLatLng(lat: mark.lat, lng: mark.long), iconImage: NMFOverlayImage(name: SeSacUserImageManager.imageName(mark.sesac))))
                                }
                            } else {
                                self.markfilterSet.insert(NMFMarker(position: NMGLatLng(lat: mark.lat, lng: mark.long), iconImage: NMFOverlayImage(name: SeSacUserImageManager.imageName(mark.sesac))))
                            }
                        }
                        self.makeMarkFriendsInMap(map: map)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func makeMarkFriendsInMap(map: NMFMapView) {
        self.markfilterSet.forEach {
            $0.mapView = map
            $0.width = 80
            $0.height = 80
            $0.isHideCollidedMarkers = true
            $0.isForceShowIcon = true
        }
    }
    
    func makeMarkDeleteInMap() {
        self.markfilterSet.forEach {
            $0.mapView = nil
        }
        self.markfilterSet.removeAll()
    }
    
}
