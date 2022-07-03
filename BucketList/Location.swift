//
//  Location.swift
//  BucketList
//
//  Created by Nawaf Alotaibi on 27/06/2022.
//

import Foundation
import MapKit
struct Location : Identifiable,Codable,Equatable{
    var id : UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    
    static var example = Location(id: UUID(), name: "Nawaf", description: "Nawaf House", latitude: 24.74334917201114, longitude: 46.583650842252304)
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs:Location , rhs:Location)-> Bool{
        lhs.id == rhs.id
    }
}
