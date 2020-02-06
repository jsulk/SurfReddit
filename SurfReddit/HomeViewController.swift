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
    
    var refreshControl: UIRefreshControl!
    var posts = [PostData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupRefreshControl()
        getPosts()
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = .blue
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    func getPosts() {
        refreshControl.beginRefreshing()
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
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh(_ sender: Any) {
        getPosts()
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
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = post.title
        if post.thumbnail != "self" {
            cell.imageView?.getPostImagesAsync(urlString: post.thumbnail)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
