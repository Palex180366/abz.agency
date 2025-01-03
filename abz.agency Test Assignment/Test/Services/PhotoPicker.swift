//
//  PhotoPicker.swift
//  Test
//
//  Created by Oleksandr on 29.12.2024.
//

import UIKit
import SwiftUI
import Photos
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var imagePath: String?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1 // Limit: 1 image
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        //
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self, let uiImage = image as? UIImage else { return }
                
                // Save the image to a local directory
                DispatchQueue.main.async {
                    self.parent.selectedImage = uiImage
                    self.parent.imagePath = self.saveImageToDocumentsDirectory(image: uiImage)
                }
            }
        }
        
        // Save the image to a local directory and return the path
        func saveImageToDocumentsDirectory(image: UIImage) -> String? {
            let imageName = UUID().uuidString + ".jpg"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            let fileURL = documentsDirectory.appendingPathComponent(imageName)
            
            if let data = image.jpegData(compressionQuality: 0.8) {
                do {
                    try data.write(to: fileURL)
                    return fileURL.path // Return the path as a string
                } catch {
                    print("Error while saving an image: \(error)")
                }
            }
            return nil
        }
    }
}
