//
//  ImagePreviewViewController.swift
//  PicturePreviewTransition
//
//  Created by cleanmac on 29/06/23.
//

import UIKit

final class ImagePreviewViewController: UIViewController {
    
    private(set) lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.alpha = 0
        return button
    }()
    
    private let imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard/XIB initializations are not supported")
    }

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .black
        
        contentImageView.image = UIImage(named: imageName)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(contentImageView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.closeButton.alpha = 1
        }
    }
    
    @objc private func closeAction() {
        navigationController?.popViewController(animated: true)
    }

}
