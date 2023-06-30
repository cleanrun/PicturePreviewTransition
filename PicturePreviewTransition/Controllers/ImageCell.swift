//
//  ImageCell.swift
//  PicturePreviewTransition
//
//  Created by cleanmac on 29/06/23.
//

import UIKit

final class ImageCell: UITableViewCell {
    
    static let REUSE_IDENTIFIER = "ImageCell"
    static let CELL_HEIGHT: CGFloat = 210
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let imageViewSize: CGFloat = 200
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard/XIB initializations are not supported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImageView.image = nil
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        contentView.addSubview(contentImageView)
        
        NSLayoutConstraint.activate([
            contentImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            contentImageView.widthAnchor.constraint(equalToConstant: imageViewSize),
            contentImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func setImage(named: String) {
        if let image = UIImage(named: named) {
            contentImageView.image = image
        }
    }
    
}
