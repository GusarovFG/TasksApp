//
//  ImageViewController.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 20.04.2022.
//
import SnapKit
import UIKit

class ImageViewController: UIViewController {
    
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.imageView.contentMode = .scaleAspectFit
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(300)
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}
