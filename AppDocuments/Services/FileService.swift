//
//  FileService.swift
//  AppDocuments


import UIKit

final class FileService {
    
    static let shared = FileService()
    
    private let documentsDirectory: URL
    
    private init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(_ image: UIImage) {
        var imageNumber = 1
        var imageFileName = "image\(imageNumber).jpg"
        var fileURL = documentsDirectory.appendingPathComponent(imageFileName)
        
        while FileManager.default.fileExists(atPath: fileURL.path) {
            imageNumber += 1
            imageFileName = "image \(imageNumber).jpg"
            fileURL = documentsDirectory.appendingPathComponent(imageFileName)
        }

        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print(error)
            }
        }
    }
    
    func deliteImage(at index: Int) {
        let fileURL = documentsDirectory.appendingPathComponent("photo \(index).jpg")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func loadImages(into images: inout [UIImage]) {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    images.append(image)
                }
            }
        } catch {
            print("error")
        }
    }
    

    
    /*
    
    private let pathForFolder: String
    
    init(pathForFolder: String) {
        self.pathForFolder = pathForFolder
    }
    
    init() {
        pathForFolder = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0]
    }
    
    //функция добавления файла
    func addFile(name: String, content: String) {
        let url = URL(filePath: pathForFolder + "/" + name)
        try? content.data(using: .utf8)?.write(to: url)
    }
    */
}
