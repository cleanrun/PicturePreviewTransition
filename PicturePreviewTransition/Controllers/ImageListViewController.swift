//
//  ImageListViewController.swift
//  PicturePreviewTransition
//
//  Created by cleanmac on 29/06/23.
//

import UIKit

final class ImageListViewController: UITableViewController {
    
    private var imageNames: [String] = [
        "image-1",
        "image-2",
        "image-3",
        "image-4",
        "image-5",
        "image-6",
        "image-7",
        "image-8",
        "image-9",
        "image-10",
    ]
    
    private(set) var selectedCell: ImageCell? = nil
    
    private let transitionManager = TransitionManager(duration: 0.3)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard/XIB initializations are not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.REUSE_IDENTIFIER)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }

}

extension ImageListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.REUSE_IDENTIFIER) as! ImageCell
        cell.setImage(named: imageNames[indexPath.row])
        return cell
    }
}

extension ImageListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ImageCell.CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as? ImageCell
        
        let imagePreviewVC = ImagePreviewViewController(imageName: imageNames[indexPath.row])
        navigationController?.delegate = transitionManager
        navigationController?.pushViewController(imagePreviewVC, animated: true)
    }
}
