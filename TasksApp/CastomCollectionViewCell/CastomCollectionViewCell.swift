//
//  CastomCollectionViewCell.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 19.04.2022.
//

import UIKit


class CastomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    func setupCell(image: UIImage) {
        self.imageView.image = image
    }
}
