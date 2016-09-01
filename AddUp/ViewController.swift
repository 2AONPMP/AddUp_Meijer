//=================================
import UIKit
//=================================
class ViewController: UIViewController {
    
    @IBOutlet weak var labelNumberToDisplay: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusSign: UILabel!
    @IBOutlet weak var taxesButton: UIButton!
    
    var numberToDisplay: String = ""
    var decimalClicked: Bool = false
    var decimalCounter: Int = -1
    var totalAmount: Float = 0.00
    
    var quebecTaxesObj: QuebecTaxes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quebecTaxesObj = QuebecTaxes()
        self.labelNumberToDisplay.text = String(format: "$%.2f", self.addUpArray())
        self.totalAmount = self.addUpArray()
        if self.plusButton.alpha == 0.5 {
            self.plusSign.alpha = 1.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonsManager(_ sender: UIButton) {
        switch sender.tag {
            case 10 :
                if !self.decimalClicked {
                    self.decimalClicked = true
                    self.displayAmount(theString: ".")
                }
            case 11 :
                if sender.alpha != 0.5 {
                    self.addingTotal()
                    sender.alpha = 0.5
                    self.taxesButton.alpha = 0.5
                }
            case 12 :
                if sender.alpha != 0.5 {
                    self.addingTotalWithTaxes()
                    sender.alpha = 0.5
                    self.plusButton.alpha = 0.5
                }
            default:
                self.plusButton.alpha = 1.0
                self.taxesButton.alpha = 1.0
                self.plusSign.alpha = 0.0
                self.displayAmount(theString: String(sender.tag))
        }
    }
    
    private func displayAmount(theString: String) {
        if self.decimalClicked {
            self.decimalCounter += 1
            if self.decimalCounter <= 2 {
                self.numberToDisplay += theString
                self.labelNumberToDisplay.text = "$\(self.numberToDisplay)"
            }
        } else {
            self.numberToDisplay += theString
            self.labelNumberToDisplay.text = "$\(self.numberToDisplay)"
        }
    }
    
    @IBAction func erase(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Message", message: "Do you really want to erase everything?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
                self.numberToDisplay = ""
                self.labelNumberToDisplay.text = "$0.00"
                self.decimalClicked = false
                self.decimalCounter = -1
                self.totalAmount = 0.00
                self.plusButton.alpha = 0.5
                self.taxesButton.alpha = 0.5
                self.plusSign.alpha = 0.0
                Singleton.sharedInstance.arrayOfItems = []
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func addingTotal() {
        Singleton.sharedInstance.arrayOfItems.append(Float(self.numberToDisplay)!)
        self.totalAmount = self.addUpArray()
        self.numberToDisplay = ""
        self.labelNumberToDisplay.text = String(format: "Total = $%.2f", self.totalAmount)
        self.decimalClicked = false
        self.decimalCounter = -1
        self.plusSign.alpha = 1.0
    }
    
    private func addingTotalWithTaxes() {
        let amountWithTaxes = self.quebecTaxesObj.getAmountWithTaxes(initialAmount: Float(self.numberToDisplay)!)
        Singleton.sharedInstance.arrayOfItems.append(Float(amountWithTaxes)!)
        self.totalAmount = self.addUpArray()
        self.numberToDisplay = ""
        self.labelNumberToDisplay.text = String(format: "Total = $%.2f", self.totalAmount)
        self.decimalClicked = false
        self.decimalCounter = -1
        self.plusSign.alpha = 1.0
    }
    
    private func addUpArray() -> Float {
        var amountToReturn: Float = 0.00
        for i in 0 ..< Singleton.sharedInstance.arrayOfItems.count {
            amountToReturn += Singleton.sharedInstance.arrayOfItems[i]
        }
        return amountToReturn
    }
}
//=================================












