//
//  HeroHeaderUIView.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/18/23.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    
    // B3: Khởi tạo contanst là heroImageView với sự kế thừa lớp UIImageView
    // Lưu ý kế thừa luôn sử dụng dấu :
    private let heroImageView: UIImageView = {
        // Khởi tạo và gán với class UIImageView để sử dụng các phương thức trong class.
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        // Lấy ra ảnh từ Assets
        imageView.image = UIImage(named: "heroImage")
        
        // B4: Trả về imageView
        return imageView
    }()
    
    // Add gradient
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    
    //B1. Khởi tạo và ghi đè để dùng frame kế thừa lớp CGRect
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // B5: Thêm view mới heroImageView
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyContrains()
    }
    
    private func applyContrains(){
        let playButtonContrains = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonContrains = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonContrains)
        NSLayoutConstraint.activate(downloadButtonContrains)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
               return
           }
        
           heroImageView.sd_setImage(with: url, completed: nil)
       }
    
    // B6: kế thừa layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    //B2. Trong quá trình khởi tạo nếu có lỗi thì show ra lỗi.
    required init?(coder: NSCoder){
        fatalError()
    }
}
