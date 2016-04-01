import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var washletDetail: UILabel!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let num = String(appDelegate.washletId!)
        washletDetail.text = String(appDelegate.washletsMap.valueForKey(num)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}