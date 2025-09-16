//
//  TaskDetailView.swift
//  ScavengerHunt
//
//  Created by gllaptops on 9/15/25.
//

import SwiftUI
import MapKit
import CoreLocation
import ImageIO


struct IdentifiableLocation: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

struct TaskDetailView: View {
    @Binding var task: Task
    
    @State private var showPicker = false
    @State private var showCamera = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // CoreLocation manager for fallback
    @StateObject private var locationManager = LocationManager()
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                Text(task.title)
                    .font(.title)
                    .bold()
                Text(task.description)
                    .foregroundColor(.secondary)
                    .font(.body)
                
                // Show selected photo if available
                if let image = task.photo {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(12)
                } //else {
                //  Text("📷 No photo attached yet")
                //      .foregroundColor(.secondary)
                //.padding(.horizontal)
                // }
                
                if let location = task.location ?? locationManager.location {
                    let identifiableLocation = IdentifiableLocation(coordinate: location)
                        Map(coordinateRegion: $region, annotationItems: [identifiableLocation]) { loc in
                            MapMarker(coordinate: loc.coordinate, tint: .blue)
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                        .onAppear {
                            region = MKCoordinateRegion(
                                center: location,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        }
                    }
                
                // Picker button
                Button(action: {showPicker = true}) {
                    Text("Attach from Library")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    //.padding(.horizontal)
                }
                
                Button(action: {showCamera = true }){
                    Text("Take a Photo")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                // Task completion indicator
                //if task.isCompleted {
                //    Text("✅ Task Complated")
                //            .foregroundColor(.green)
                //            .bold()
                //}
                
                //if let location = task.location {
                //    Map(coordinateRegion: $region, annotationItems: [location]) { coord in
                //        MapMarker(coordinate: coord, tint: .red)
                //    }
                //    .frame(height: 250)
                //    .cornerRadius(12)
                //}
                .padding()
            }
            //.navigationTitle("Task Detail")
            .sheet(isPresented: $showPicker) {
                PhotoPicker(selectedImage: Binding<UIImage?>(
                    get: { task.photo },
                    set: { task.photo = $0 }
                )) { data in
                    if let unwrappedData = data, let coord = extractLocation(from: unwrappedData){
                        task.location = coord
                        region.center = coord
                    }
                    task.isCompleted = true
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(selectedImage: Binding(
                    get: { task.photo },
                    set: { task.photo = $0 }
                )) {
                    task.isCompleted = true
                }
            }
        }
    }
}

func extractLocation(from data: Data) -> CLLocationCoordinate2D? {
  guard let source = CGImageSourceCreateWithData(data as CFData, nil),
        let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
        let gps = metadata[kCGImagePropertyGPSDictionary] as? [CFString: Any],
        let lat = gps[kCGImagePropertyGPSLatitude] as? Double,
        let lon = gps[kCGImagePropertyGPSLongitude] as? Double else {
    return nil
  }
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
}
