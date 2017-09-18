//
//  WebserviceManager.swift
//  MusicSearch
//
//  Created by Srinivas Kasanna on 9/16/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import Foundation

struct RestAPIWebserviceManager {

    static func getTracksData(requestURL: URL,  completionHandler:@escaping (Any?,_ error:Error?)->Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: requestURL)
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            completionHandler(data,error)
        })
        task.resume()
    }
 
}
