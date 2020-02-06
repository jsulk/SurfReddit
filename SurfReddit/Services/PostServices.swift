//
//  PostServices.swift
//  SurfReddit
//
//  Created by Jake Sulkoske on 2/5/20.
//  Copyright © 2020 Jake Sulkoske. All rights reserved.
//

import Foundation

class PostServices {
    
    private let baseUrl = "https://www.reddit.com/r/surfing/top.json"
    
    func getPosts(callback: @escaping (_ error: NSError?, _ posts: [Post]?) -> Void) -> Void{
        
        var callbackError: NSError?
        
        guard let url = URL(string: self.baseUrl) else {
            callbackError = NSError(domain: "POST SERVICE ERROR: cannot create URL", code: 1, userInfo: nil)
            callback(callbackError, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                callbackError = NSError(domain: "POST SERVICE ERROR: \(error.debugDescription)", code: 1, userInfo: nil)
                callback(callbackError, nil)
                return
            }
            guard let responseData = data else {
                callbackError = NSError(domain: "POST SERVICE ERROR: did not receive data", code: 1, userInfo: nil)
                callback(callbackError, nil)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let jsonObject = try jsonDecoder.decode(Response.self, from: responseData)
                callback(nil, jsonObject.data.children)
            }
            catch {
                callbackError = NSError(domain: "POST SERVICE ERROR: \(error)", code: 1, userInfo: nil)
                callback(callbackError, nil)
            }
        }
        task.resume()
    }
    
}
