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
        setupView()
        setupRefreshControl()
        getPosts()
    }
    
    func setupView() {
        //Set footer view so default seperator insets do not show when there are no posts
        self.tableView.tableFooterView = UIView()
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func getPosts() {
        refreshControl.beginRefreshing()
        let postServices = PostServices()
        postServices.getPosts { (error, posts) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.setErrorBackground()
                }
            } else {
                guard let posts = posts else { return }
                self.posts = []
                for post in posts {
                    self.posts.append(post.data)
                }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.backgroundView = nil
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setErrorBackground() {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noDataLabel.text = "Please try again later"
        noDataLabel.textColor = .gray
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0
        self.tableView.backgroundView = noDataLabel
    }
    
}

// MARK: UITableViewDelegate/DataSource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.post = posts[indexPath.row]
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
