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
    
    var task: Task?
    var imagesFromTask: [UIImage] = []
    var indexOfTask = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.register(UINib(nibName: "CastomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collCell")
        let barButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(saveTask))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        if task != nil {
            self.titleTextField.text = self.task?.title
            self.textView.text = self.task?.text
            self.imagesFromTask = CoreDataManager.shared.imagesFromCoreData(taskImages: task?.images) ?? []
            self.creatingDateLabel.text = self.task?.creationDate
            self.editDateLabel.text = self.task?.editDate
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func saveTask() {
        if self.task == nil {
            CoreDataManager.shared.saveTask(title: self.titleTextField.text,
                                            text: self.textView.text,
                                            images: CoreDataManager.shared.coreDataObjectFromImages(images: self.imagesFromTask),
                                            creationDate: DateManager.shared.getDate())
            self.navigationController?.popViewController(animated: true)
        } else {
            CoreDataManager.shared.editTask(index: self.indexOfTask,
                                            title: self.titleTextField.text,
                                            text: self.textView.text,
                                            images: CoreDataManager.shared.coreDataObjectFromImages(images: self.imagesFromTask),
                                            editDate: DateManager.shared.getDate())
            
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            cell.setupCell(image: UIImage(systemName: "camera.fill")!)
        } else {
            switch indexPath{
            case [0,0]..<[0,self.imagesFromTask.count]:
                cell.setupCell(image: self.imagesFromTask[indexPath.row])
            case [0,self.imagesFromTask.count]:
                cell.setupCell(image: UIImage(systemName: "camera.fill")!)
            default:
                break
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }
}
