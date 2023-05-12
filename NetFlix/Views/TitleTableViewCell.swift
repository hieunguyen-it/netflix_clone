//
//  TitleTableViewCell.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 5/3/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let indentifier = "TitleTableViewCell"
    
    /*
         Khi thiết kế giao diện, để đảm bảo độ chính xác và dễ dàng trong việc quản lý ràng buộc,
         chúng ta thường không sử dụng translatesAutoresizingMaskIntoConstraints mà tạo ra các ràng buộc
         (constraints) cho view bằng cách sử dụng NSLayoutConstraint.
         Khi đặt translatesAutoresizingMaskIntoConstraints thành false, chúng ta cho phép quản lý ràng buộc
         tự động bằng cách tạo các ràng buộc cho view bằng cách sử dụng ràng buộc tường minh thông qua
         NSLayoutConstraint. Việc này giúp cho chúng ta có thể dễ dàng kiểm soát được vị trí và kích
         thước của các view trên màn hình.
     */
    
    // Tạo Button
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    
    // Tạo Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Tạo Poster Image
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstrains()
    }
    
    private func applyConstrains(){
        
        // style Image
        let titlesPosterUIImageViewConstrains = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        // style Title
        let titleLabelConstrains = [
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        // style Button
        let playTitleButtonConstrains = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        // Áp dụng NSLayoutConstraint cho các style trên
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstrains)
        NSLayoutConstraint.activate(titleLabelConstrains)
        NSLayoutConstraint.activate(playTitleButtonConstrains)
    }
    
    public func configure(with model: TitleViewModel){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
            return
        }
        
        titlesPosterUIImageView.sd_setImage(with: url , completed: nil)
        titleLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
