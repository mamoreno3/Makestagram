//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        // remove seperator for empty cells
        tableView.tableFooterView = UIView()
        // remove seperator from cells
        tableView.separatorStyle = .none
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
        let post = posts[indexPath.row]
        let imageUrl = URL(string: post.imageUrl)
        
        cell.postImageView.kf.setImage(with: imageUrl)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        return post.imageHeight
    }
}
