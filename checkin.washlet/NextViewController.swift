import UIKit
import LTMorphingLabel
import GaugeKit

class NextViewController: UIViewController, LTMorphingLabelDelegate {

    var textArray = [
        "tripleW",
        "DFree",
        "Go Go!"
    ]
    
    var i = 0
    
    var text:String {
        get {
            if i >= textArray.count {
                i = 0
            }
            return textArray[i++]
        }
    }

    @IBOutlet weak var gauge_in: Gauge!
    @IBOutlet weak var gauge_mid: Gauge!
    @IBOutlet weak var gauge_out: Gauge!
    
    @IBAction func changeColor(sender: UISlider) {
        gauge_in.rate = CGFloat(sender.value * 4)
        gauge_mid.rate = CGFloat(sender.value * 8)
        gauge_out.rate = CGFloat(sender.value * 12)
    }
    
    @IBOutlet weak var washletDetail: LTMorphingLabel!
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let num = String(appDelegate.washletId!)
        washletDetail.text = String(appDelegate.washletsMap.valueForKey(num)!)
        
    }
    @IBAction func changeText(sender: AnyObject) {
        washletDetail.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}