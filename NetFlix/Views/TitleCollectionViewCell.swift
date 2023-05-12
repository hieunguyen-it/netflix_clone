//
//  TitleCollectionViewCell.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/19/23.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let indentifier = "TitleCollectionView"
    
    // Khởi tạo image View
    private let postImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
        
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(postImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postImageView.frame = contentView.bounds
        
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        postImageView.sd_setImage(with: url, completed: nil)
    }
    
}
