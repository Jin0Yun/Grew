//
//  NaverMapView.swift
//  Grew
//
//  Created by 마경미 on 10.10.23.
//

import SwiftUI

import CoreLocation
import GeoFire
import NMapsMap

struct NaverMapView: UIViewRepresentable {
    @EnvironmentObject var viewModel: MapStore
    
    internal func makeCoordinator() -> Coordinator {
        return Coordinator(parentMapView: self)
    }
    
    func makeUIView(context: Context) -> NMFMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        for marker in viewModel.markers {
            marker.mapView = nil
        }

        for items in viewModel.filteredListItems {
            if let latitude = Double(items.latitude),
               let longitude = Double(items.longitude) {
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: latitude, lng: longitude)
                marker.captionText = items.title
                marker.mapView = uiView
                
                marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                    viewModel.clickedSymbol(title: items.title)
                    return true
                }
                viewModel.markers.append(marker)
            }
        }
        
    }
    
    internal class Coordinator: NSObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
        private var parentMapView: NaverMapView
        private let view = NMFMapView(frame: .zero)
        private var locationManager = CLLocationManager()
        init(parentMapView: NaverMapView) {
            self.parentMapView = parentMapView
            
            super.init()
            
            view.positionMode = .normal
            view.addCameraDelegate(delegate: self)
            view.touchDelegate = self

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
            
            parentMapView.viewModel.fetchNearGrew()
        }

        func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
            let changedLocation = CLLocation(latitude: view.cameraPosition.target.lat, longitude: view.cameraPosition.target.lng)
            let distance = GFUtils.distance(from: changedLocation, to: parentMapView.viewModel.currentLocation)
            
            if distance >= parentMapView.viewModel.radiusInM {
                parentMapView.viewModel.fetchNearGrew()
            }
            
            parentMapView.viewModel.currentLocation = changedLocation
        }
        
        func getNaverMapView() -> NMFMapView {
            view
        }
    }
}

#Preview {
    NaverMapView()
}
