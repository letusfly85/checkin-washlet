//
//  ViewController.swift
//  checkin.washlet
//
//  Created by 和田 俊輔 on 2016/03/31.
//  Copyright © 2016年 com.jellyfish85. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //var washletsMap: NSMutableDictionary = NSMutableDictionary()
    @IBOutlet var washletName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findWashlets() {
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
                        if (String(value) != nil) {
                            self.appDelegate.washletsMap.setValue(value, forKey: String(i))
                            i += 1
                        }
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

    //curl -H "Accept: application/json" -H "Content-type: application/json" -XPOST http://localhost:4000/washlets/register -d '{"name":"shinjuku", "latitude":"35.7015898","longitude":"139.6741875","status":"unused"}'
    @IBAction func registerWashlet(sender: AnyObject) {
        let urlString = "http://localhost:4000/washlets/register"
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params: [String: AnyObject] =  [
            "name": (self.washletName.text)!,
            "latitude": "",  //todo
            "longitude": "", //todo
            "status": "unused"
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.init(rawValue: 2))
        } catch {
            // Error Handling
            print("NSJSONSerialization Error")
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
        if (error == nil) {
            print("success")
        }
                
        }).resume()
        self.washletName.text = ""
        self.tableView.reloadData()
            
        
        print("registered")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            findWashlets()
            return appDelegate.washletsMap.count
            
        } else {
            return 5
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let num = String(indexPath.row)
        cell.textLabel!.text = String(appDelegate.washletsMap.valueForKey(num)!.valueForKey("status"))
        cell.detailTextLabel!.text = String(appDelegate.washletsMap.valueForKey(num)!.valueForKey("name"))
        
        let button : UIButton = UIButton.init(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(40, 60, 100, 24)
        let cellHeight: CGFloat = 44.0
        button.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
        button.backgroundColor = UIColor.redColor()
        button.addTarget(self, action: #selector(ViewController.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = indexPath.row
        button.setTitle("Click Me !", forState: UIControlState.Normal)
        
        cell.addSubview(button)

        return cell
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        //print(sender.titleLabel!.description)
        print(sender.tag)
        appDelegate.washletId = String(sender.tag)
        
        print("clicked")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("NextViewController") 
        self.presentViewController(nextViewController, animated:true, completion:nil)
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
        print(String(appDelegate.washletsMap.valueForKey(num)))
    }

}

