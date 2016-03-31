//
//  ViewController.swift
//  checkin.washlet
//
//  Created by 和田 俊輔 on 2016/03/31.
//  Copyright © 2016年 com.jellyfish85. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        samplePost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func samplePost() {
        let urlString = "http://localhost:4000/washlets/checkin"
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params: [String: AnyObject] =  [
            "key": "value"
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.init(rawValue: 2))
        } catch {
            // Error Handling
            print("NSJSONSerialization Error")
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
            if (error == nil) {
                let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(result)
            } else {
                print(error)
            }
        })
        
        task.resume()
    }


}

