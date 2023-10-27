//
//  DocViewController.swift
//  AppDocuments

import UIKit

class DocViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   //MARK: -свойствва
    
    private var fileService = Service()
    
    var imageModels: [ImageModel] = []
    let imagePicker: UIImagePickerController = UIImagePickerController()

    private lazy var addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoButton))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //MARK: - init, viewDidLoad
    
    init() {
        fileService = Service()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(fileService: Service) {
        self.fileService = fileService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Documents"
        loadImage()
        setupImagePicker()
        setupLayout()
    }

    //MARK: - методы
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            fileService.saveImage(image)
            loadImage()
            tableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func loadImage() {
        let images = fileService.loadFromDocuments()
        imageModels.removeAll()
        let targetSize = CGSize(width: 50, height: 50)
        
        for (index, image) in images.enumerated() {
            let resizedImage = resizeImage(image.image, targetSize: targetSize)
            var im = images[index].image
            im = resizedImage
            let imgModel = ImageModel(image: im, imageName: image.imageName)
            imageModels.append(imgModel)
            //imageModels.insert(imgModel, at: 0)
        }
        
        //для сортировки в таблице
        /*
        imageModels.sort { image, name in
            image.imageName < name.imageName
        }
        */
        tableView.reloadData()
    }
    
    //MARK: - вспомогательные методы
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = render.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }

    //MARK: - button

    @objc func addPhotoButton() {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK: Layout
    
    func setupLayout() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = addBarButtonItem
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

        ])
    }
}

extension DocViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let imageData = imageModels[indexPath.row]
        cell.imageView?.image = imageData.image
        cell.textLabel?.text = imageData.imageName
        return cell
         
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let imageToDelite = imageModels[indexPath.row].imageName
            imageModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            fileService.deliteImage(imageName: imageToDelite)
            print(imageToDelite)
        }
    }
    
    
}
