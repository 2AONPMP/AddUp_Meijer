//=================================
import UIKit
//=================================
class ViewController: UIViewController {
    //# MARK: - IBOutlets
    @IBOutlet weak var labelNumberToDisplay: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusSign: UILabel!
    @IBOutlet weak var taxesButton: UIButton!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var deviceHeight: UIView!
    
    //# MARK: - Properties
    var numberToDisplay: String = ""
    var decimalClicked: Bool = false
    var decimalCounter: Int = -1
    var totalAmount: Float = 0.00
    var h: CGFloat! = 0.0
    var w: CGFloat! = 0.0
    
    //# MARK: - Instances
    var michiganTaxesObj: MichiganTaxe!
    
    //# MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.michiganTaxesObj = MichiganTaxe()
        self.labelNumberToDisplay.text = self.informationToDisplay(theSum: self.addUpArray())
        self.totalAmount = self.addUpArray()
        if self.plusButton.alpha == 0.2 {
            self.plusSign.alpha = 1.0
        }
        self.h = self.deviceHeight.frame.size.height
        self.w = self.deviceHeight.frame.size.width + 170
    }
    
    //# MARK: - informationToDisplay
    func informationToDisplay(theSum: Float) -> String {
        let sum: Float = theSum
        let bud: Float = Float(Singleton.sharedInstance.theBudget)
        let budgetLeft: Float = (bud - sum)
        let b: String = String(format: "Budget = $%.2f", budgetLeft)
        let s: String = String(format: "Total = $%.2f", sum)
        return "\(b)\n\(s)"
    }
    
    //# MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# MARK: - buttonsManager
    @IBAction func buttonsManager(_ sender: UIButton) {
        switch sender.tag {
        case 10 :
            if !self.decimalClicked {
                self.decimalClicked = true
                self.displayAmount(theString: ".")
            }
        case 11 :
            if sender.alpha != 0.2 {
                self.addingTotal()
                sender.alpha = 0.2
                self.taxesButton.alpha = 0.2
            }
        case 12 :
            if sender.alpha != 0.2 {
                self.addingTotalWithTaxes()
                sender.alpha = 0.2
                self.plusButton.alpha = 0.2
            }
        default:
            self.plusButton.alpha = 1.0
            self.taxesButton.alpha = 1.0
            self.plusSign.alpha = 0.0
            self.displayAmount(theString: String(sender.tag))
        }
    }
    
    //# MARK: - displayAmount
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
    
    //# MARK: - erase
    @IBAction func erase(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Message", message: "Do you really want to erase everything?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.numberToDisplay = ""
            self.labelNumberToDisplay.text = self.informationToDisplay(theSum: 0.00)
            self.decimalClicked = false
            self.decimalCounter = -1
            self.totalAmount = 0.00
            self.plusButton.alpha = 0.2
            self.taxesButton.alpha = 0.2
            self.plusSign.alpha = 0.0
            Singleton.sharedInstance.emptyArray()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //# MARK: - addingTotal
    private func addingTotal() {
        if self.numberToDisplay == "" {
            return
        }
        Singleton.sharedInstance.addToArray(theNumber: Float(self.numberToDisplay)!)
        self.totalAmount = self.addUpArray()
        self.numberToDisplay = ""
        self.labelNumberToDisplay.text = self.informationToDisplay(theSum: self.totalAmount)
        self.decimalClicked = false
        self.decimalCounter = -1
        self.plusSign.alpha = 1.0
    }
    
    //# MARK: - addingTotalWithTaxes
    private func addingTotalWithTaxes() {
        let amountWithTaxes = self.michiganTaxesObj.getAmountWithTaxes(initialAmount: Float(self.numberToDisplay)!)
        Singleton.sharedInstance.addToArray(theNumber: Float(amountWithTaxes)!)
        self.totalAmount = self.addUpArray()
        self.numberToDisplay = ""
        self.labelNumberToDisplay.text = self.informationToDisplay(theSum: self.totalAmount)
        self.decimalClicked = false
        self.decimalCounter = -1
        self.plusSign.alpha = 1.0
    }
    
    //# MARK: - addUpArray
    private func addUpArray() -> Float {
        var amountToReturn: Float = 0.00
        for i in 0 ..< Singleton.sharedInstance.arrayOfItems.count {
            amountToReturn += Singleton.sharedInstance.arrayOfItems[i]
        }
        return amountToReturn
    }
}
//=================================


