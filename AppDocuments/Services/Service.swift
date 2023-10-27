//
//  Service.swift
//  AppDocuments



import UIKit

final class Service {
    
    private let pathForFolder: String
   /*
    var imagesNameArray: [String] {
        return (try? FileManager.default.contentsOfDirectory(atPath: pathForFolder)) ?? []
    }
    */
    
    init(pathForFolder: String) {
        self.pathForFolder = pathForFolder
    }
    
    init() {
        pathForFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func saveImage(_ image: UIImage) {
        var imageNumber = 1
        var imageFileName = "image\(imageNumber).jpg"
        var fileURL = URL(fileURLWithPath: pathForFolder).appendingPathComponent(imageFileName)
        
        while FileManager.default.fileExists(atPath: fileURL.path) {
            imageNumber += 1
            imageFileName = "image\(imageNumber).jpg"
            fileURL = URL(fileURLWithPath: pathForFolder).appendingPathComponent(imageFileName)
        }

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            do {
                try imageData.write(to: fileURL)
            } catch {
                print("Ошибка сохранения изображения \(error)")
            }
        }
    }
    /*
    func loadImages(into images: inout [UIImage]) {
        let fileURLs = imagesNameArray
        for fileURL in fileURLs {
            if let image = UIImage(contentsOfFile: fileURL) {
                images.append(image)
                print(images.count)
            }
        }
    }
    */
    func deliteImage(imageName: String) {
        let imageURL = URL(fileURLWithPath: pathForFolder).appendingPathComponent(imageName)
        print(imageURL)
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print("ошибка при удалении")
        }
        
    }
    
    func loadFromDocuments() -> [ImageModel] {
        var images: [ImageModel] = []
        let documentDirectory = URL(fileURLWithPath: pathForFolder)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
            let imageFileURLs = fileURLs.filter { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" }
            
            images = imageFileURLs.compactMap { imageURL in
                if let image = UIImage(contentsOfFile: imageURL.path) {
                    let imageName = imageURL.lastPathComponent
                    return ImageModel(image: image, imageName: imageName)
                }
                return nil
             }

        } catch {
            print(images.map { $0.imageName })
            print("ошибка получения данных",error)
        }
        return images
    }
}
