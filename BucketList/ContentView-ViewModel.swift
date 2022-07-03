//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Nawaf Alotaibi on 30/06/2022.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView{
    @MainActor class ViewModel:ObservableObject{
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.74334917201114, longitude: 46.583650842252304), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published private(set) var locations = [Location]()
        @Published var selectedPlace:Location?
        @Published var isUnlocked = false
        
        
        func addLocation(){
            let newLocation = Location(id:UUID(),name:"new location",description:"",latitude:mapRegion.center.latitude,longitude:mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location:Location){
            guard let selectedPlace = selectedPlace else {return}

            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                    if success {
                        Task{
                            await MainActor.run{
                                self.isUnlocked = true
                            }
                        }
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
        
    }
    
    
}
