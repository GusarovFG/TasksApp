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
    private var button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.imageView.contentMode = .scaleAspectFit
        self.button.addTarget(self, action: #selector(closeController), for: .touchDown)
        self.button.backgroundColor = .blue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(300)
            make.top.bottom.left.right.equalToSuperview()
        }
        self.imageView.addSubview(self.button)
        self.button.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.right.top.equalToSuperview()
        }
    }
    
    @objc private func closeController() {
        self.navigationController?.popViewController(animated: true)
    }
}
