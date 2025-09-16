//
//  Task.swift
//  ScavengerHunt
//
//  Created by gllaptops on 9/15/25.
//

import Foundation
import CoreLocation
import UIKit


struct Task: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var photo: UIImage? = nil
    var location: CLLocationCoordinate2D? = nil
}
