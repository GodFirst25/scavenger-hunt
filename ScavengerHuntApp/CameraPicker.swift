//
//  CameraPicker.swift
//  ScavengerHunt
//
//  Created by student on 9/16/25.
//

import SwiftUI
import UIKit


struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onPicked: (() -> Void)? = nil
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(_parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(_parent: CameraPicker) {self.parent = _parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onPicked?()
            }
            
            func imagePickerControllerDidCancel(_picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
    }
}

