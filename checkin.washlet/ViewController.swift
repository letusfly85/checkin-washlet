//
//  ViewController.swift
//  checkin.washlet
//
//  Created by 和田 俊輔 on 2016/03/31.
//  Copyright © 2016年 com.jellyfish85. All rights reserved.
//

import UIKit

//var washletsMap: NSMutableDictionary = NSMutableDictionary()

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var washletsMap: NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showWashlets() {
        let urlString = "http://localhost:4000/washlets/list"
        
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

        let semaphore = dispatch_semaphore_create(0)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
            if (error == nil) {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!,
                        options: NSJSONReadingOptions.MutableContainers) as?NSMutableDictionary
                    
                    var i = 0
                    for (_, value) in json! {
                        self.washletsMap.setValue(value, forKey: String(i))
                        i += 1
                    }
                    
                
                } catch {
                    return
                }
                
                

            } else {
                print(error)
            }
        dispatch_semaphore_signal(semaphore)
        })
        
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            showWashlets()
            return self.washletsMap.count
            
        } else {
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let num = String(indexPath.row)
        cell.textLabel!.text = String(self.washletsMap.valueForKey(num)!.valueForKey("status"))
        cell.detailTextLabel!.text = String(self.washletsMap.valueForKey(num)!.valueForKey("name"))
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section" + section.description
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("section \(indexPath, section())'s cell\(indexPath.row) selected")
        let num = String(indexPath.row)
        print(String(self.washletsMap.valueForKey(num)))
    }

}

