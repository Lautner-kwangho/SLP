//
//  MapViewController+Function.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/10.
//

import UIKit
import NMapsMap

extension MapViewController: NMFMapViewCameraDelegate {
    // Camera Delegate
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == -1 {
            self.mapMiddleMarker.isHidden = false
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        // [카메라 움직임] 여기서 좌표 뽑은 거 서버 콜 하기( 시간은 한번 더 생각해보기)
        let cameraPosition = mapView.cameraPosition
        let cameraMiddlePlace = cameraPosition.target
        
        let region = mapRegion(latitude: cameraPosition.target.lat, longitude: cameraPosition.target.lng)
        
        UserDefaults.standard.set(Int(region)!, forKey: UserDefaultsManager.region)
        UserDefaults.standard.set(cameraPosition.target.lat, forKey: UserDefaultsManager.latitude)
        UserDefaults.standard.set(cameraPosition.target.lng, forKey: UserDefaultsManager.longitude)
        
        // 움직일 때 네트워크 요청
        SeSacURLNetwork.friendsWithMe(region: Int(region)!, latitude: cameraPosition.target.lat, longitude: cameraPosition.target.lng)
    }
    
    func mapRegion(latitude: Double, longitude: Double) -> String {
        let firstNumber = String((latitude + 90) * 10000)
        let secondNumber = String((longitude + 180) * 10000)

        let fontFilter = firstNumber.index(firstNumber.startIndex, offsetBy: 4)
        let backFilter = secondNumber.index(secondNumber.startIndex, offsetBy: 4)
        
        let region = String(firstNumber[...fontFilter]) + String(secondNumber[...backFilter])
    
        return region
    }
}
