//
//  ViewController.swift
//  SurfReddit
//
//  Created by Jake Sulkoske on 2/5/20.
//  Copyright © 2020 Jake Sulkoske. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PostData]()
    
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
                guard let posts = posts else { return }
                for post in posts {
                    self.posts.append(post.data)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

// MARK: UITableViewDataSource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
    
}
