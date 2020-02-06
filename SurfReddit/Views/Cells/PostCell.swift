//
//  PostCell.swift
//  SurfReddit
//
//  Created by Jake Sulkoske on 2/5/20.
//  Copyright © 2020 Jake Sulkoske. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    
    var post: PostData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        guard let post = post else { return }
        postTitle.text = post.title
        postAuthor.text = post.author
        if post.thumbnail != "self" {
            postImage.getPostImagesAsync(urlString: post.thumbnail)
            postImage.clipsToBounds = true
        } else {
            postImage.image = UIImage(named: "discussion_icon")
            postImage.contentMode = .center
        }
        postImage.layer.cornerRadius = 3.0
    }

}
