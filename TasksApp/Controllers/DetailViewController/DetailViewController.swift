//
//  DetailViewController.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 20.04.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var creatingDateLabel: UILabel!
    @IBOutlet weak var editDateLabel: UILabel!
    @IBOutlet weak var labelForEditeDate: UILabel!
    @IBOutlet weak var labelForCreateDate: UILabel!
    
    var task: Task?
    var indexOfTask = 0
    private var imagesFromTask: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.view.endEditing(true)
    }
    
    private func setupUI() {
        
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.register(UINib(nibName: "CastomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collCell")
        self.imagesCollectionView.backgroundColor? = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        let barButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(saveTask))
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if task != nil {
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                self.imagesFromTask = CoreDataManager.shared.imagesFromCoreData(taskImages: self.task?.images) ?? []
                DispatchQueue.main.async {
                    self.imagesCollectionView.reloadData()
                    self.titleTextField.text = self.task?.title
                    self.textView.text = self.task?.text
                    self.creatingDateLabel.text = self.task?.creationDate
                    if self.task?.editDate == nil {
                        self.labelForEditeDate.isEnabled = false
                    } else {
                        self.editDateLabel.text = self.task?.editDate
                    }
                    self.title = self.task?.title
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        } else {
            self.title = "Новая заметка"
            self.labelForEditeDate.isHidden = true
            self.labelForCreateDate.isHidden = true
        }
    }
    
    private func addPhotoCellPressed() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Камера", style: .default) { _ in
            self.chooseImagePicker(sourse: .camera)
        }
        let photo = UIAlertAction(title: "Галерея", style: .default) { _ in
            self.chooseImagePicker(sourse: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func saveTask() {
        if self.task == nil {
            CoreDataManager.shared.saveTask(title: self.titleTextField.text,
                                            text: self.textView.text,
                                            images: self.imagesFromTask,
                                            creationDate: DateManager.shared.getDate())
            
        } else {
            CoreDataManager.shared.editTask(index: self.indexOfTask,
                                            title: self.titleTextField.text,
                                            text: self.textView.text,
                                            images: CoreDataManager.shared.coreDataObjectFromImages(images: self.imagesFromTask),
                                            editDate: DateManager.shared.getDate())
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func itileTiexfieldIsEmptyCheck(_ sender: UITextField) {
        if !(sender.text?.isEmpty ?? true) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imagesFromTask.isEmpty {
            return 1
        } else {
            return self.imagesFromTask.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! CastomCollectionViewCell
        if self.imagesFromTask.isEmpty {
            cell.setupCell(image: UIImage(systemName: "camera")!)
        } else {
            switch indexPath{
            case [0,0]..<[0,self.imagesFromTask.count]:
                cell.setupCell(image: self.imagesFromTask[indexPath.row])
            case [0,self.imagesFromTask.count]:
                cell.setupCell(image: UIImage(systemName: "camera")!)
            default:
                break
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath {
        case [0,self.imagesFromTask.count] :
            addPhotoCellPressed()
        default:
            let imageVC = ImageViewController()
            imageVC.imageView.image = self.imagesFromTask[indexPath.row]
            self.navigationController?.show(imageVC, sender: self)
        }
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.imagesFromTask.append(pickedImage)
            self.imagesCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}


