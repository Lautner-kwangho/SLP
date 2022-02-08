//
//  MapViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/09.
//

import Foundation

struct MapViewModel {
    
    
}


/*
 쓸거 문서 정리
 - 한번 정하고 변경 안됨 (싹들 좌표 잡기)
 let coord = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
 print("위도: \(coord.lat), 경도: \(coord.lng)")
 
 - 위치 추적 모드 (권한 설정)
 위치 추적 모드 지정: positionMode를 지정하면 프로그램적으로 위치 추적 모드를 지정할 수 있습니다.
 현위치 버튼 컨트롤 사용: showLocationButton으로 현위치 버튼 컨트롤을 활성화하면 사용자의 탭에 따라 위치 추적 모드를 변경할 수 있습니다.
 
 NMFMyPositionDisabled: 위치를 추적하지 않습니다.
 NMFMyPositionNormal: 위치 추적이 활성화되고, 현위치 오버레이가 사용자의 위치를 따라 움직입니다. 그러나 지도는 움직이지 않습니다.
 naverMapView.positionMode = .direction
 
 - 마커 이미지
 marker.iconImage = NMFOverlayImage(name: "marker_icon")
 
 - 축척 원
 circle.radius = 500
 locationOverlay.circleRadius = 50 <- 이게 맞을듯
 
 

 
 */
