//
//  Post.swift
//  SurfReddit
//
//  Created by Jake Sulkoske on 2/5/20.
//  Copyright © 2020 Jake Sulkoske. All rights reserved.
//

import Foundation

struct Response: Decodable {
    var data: Data
}

struct Data: Decodable {
    var children: [Post]
}

struct Post: Decodable {
    var data: PostData
}

struct PostData: Decodable {
    var title: String
}
