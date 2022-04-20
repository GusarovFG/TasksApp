//
//  CastomCollectionViewCell.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 19.04.2022.
//

import UIKit


class CastomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupCell(image: UIImage) {
        self.imageView.image = image
    }
}
