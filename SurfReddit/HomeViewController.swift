//
//  ViewController.swift
//  SurfReddit
//
//  Created by Jake Sulkoske on 2/5/20.
//  Copyright © 2020 Jake Sulkoske. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
    }

    func getPosts() {
        let postServices = PostServices()
        postServices.getPosts { (error, posts) in
            if let error = error {
                print(error)
            } else {
                guard let posts = posts else {
                    print("NO")
                    return
                }
                print(posts)
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
}
