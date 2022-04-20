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
    
    var task: Task = Task()
    var imagesFromTask: [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.register(UINib(nibName: "CastomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collCell")
        let barButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(saveTask))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func saveTask() {
        
        CoreDataManager.shared.saveTask(title: self.titleTextField.text, text: self.textView.text, images: CoreDataManager.shared.coreDataObjectFromImages(images: self.imagesFromTask), creationDate: DateManager.shared.getDate())
        self.dismiss(animated: true, completion: nil)
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
