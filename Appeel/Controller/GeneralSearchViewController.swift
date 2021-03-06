//
//  GeneralSearchViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/8/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class GeneralSearchViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var generalSearch: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var generalSearchLabel: UILabel!
    @IBOutlet var queryLabel: UILabel!
    @IBOutlet var rankingLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var maxIngredientsLabel: UILabel!
    @IBOutlet var dietLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var minTimeLabel: UILabel!
    @IBOutlet var maxTimeLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var minCalLabel: UILabel!
    @IBOutlet var maxCalLabel: UILabel!
    @IBOutlet var excludedLabel: UILabel!
    
    @IBOutlet var queryField: UITextField!
    @IBOutlet var minRankField: UITextField!
    @IBOutlet var maxRankField: UITextField!
    @IBOutlet var maxIngredientsField: UITextField!
    @IBOutlet var minTimeField: UITextField!
    @IBOutlet var maxTimeField: UITextField!
    @IBOutlet var minCalField: UITextField!
    @IBOutlet var maxCalField: UITextField!
    @IBOutlet var excludedField: UITextField!
    
    @IBOutlet var dietPicker: UIPickerView!
    
    private let padding: CGFloat = 7.0
    private let borderRadius: CGFloat = 5.0
    
    // populates diet picker with possible diet options
    private let dietPickerData: [String] = ["none", "balanced", "high-protein", "high-fiber", "low-fat", "low-carb", "low-sodium"]
    
    var query: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // formats go back button
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        // formates general search button
        generalSearch.setTitle("Search", for: .normal)
        generalSearch.backgroundColor = ColorScheme.yellow
        generalSearch.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        generalSearch.layer.cornerRadius = borderRadius
        generalSearch.titleLabel!.font = ColorScheme.pingFang24
        generalSearch.setTitleColor(ColorScheme.black, for: .normal)
        
        // formats title label
        generalSearchLabel.text = "General Search"
        generalSearchLabel.textColor = ColorScheme.red
        generalSearchLabel.font = ColorScheme.cochinItalic50
        
        // formats query label & field
        queryLabel.text = "Query"
        queryLabel.font = ColorScheme.pingFang18b
        queryField.font = ColorScheme.pingFang18
        if query != nil {
            queryField.text = query
        }
        
        // formats ranking label
        rankingLabel.text = "Ranking"
        rankingLabel.font = ColorScheme.pingFang18b
        
        // formats ranking lower bound label
        fromLabel.text = "From"
        fromLabel.font = ColorScheme.pingFang18
        minRankField.font = ColorScheme.pingFang18
        
        // formats ranking higher bound label
        toLabel.text = "To"
        toLabel.font = ColorScheme.pingFang18
        maxRankField.font = ColorScheme.pingFang18
        
        // formats max num ingredients label
        maxIngredientsLabel.text = "Max Ingredients"
        maxIngredientsLabel.font = ColorScheme.pingFang18b
        maxIngredientsField.font = ColorScheme.pingFang18
        
        // formats diet label
        dietLabel.text = "Diet"
        dietLabel.font = ColorScheme.pingFang18b
        
        // formats time of preparation label
        timeLabel.text = "Time (min)"
        timeLabel.font = ColorScheme.pingFang18b
        
        // formats time lower bound label
        minTimeLabel.text = "Min"
        minTimeLabel.font = ColorScheme.pingFang18
        minTimeField.font = ColorScheme.pingFang18
        
        // formats time upper bound label
        maxTimeLabel.text = "Max"
        maxTimeLabel.font = ColorScheme.pingFang18
        maxTimeField.font = ColorScheme.pingFang18
        
        // formats calories label
        caloriesLabel.text = "Calories"
        caloriesLabel.font = ColorScheme.pingFang18b
        
        // formats calories lower bound label
        minCalLabel.text = "Min"
        minCalLabel.font = ColorScheme.pingFang18
        minCalField.font = ColorScheme.pingFang18
        
        // formats calories upper bound label
        maxCalLabel.text = "Max"
        maxCalLabel.font = ColorScheme.pingFang18
        maxCalField.font = ColorScheme.pingFang18
        
        // formats excluded ingredients label
        excludedLabel.text = "Excluded"
        excludedLabel.font = ColorScheme.pingFang18b
        excludedField.font = ColorScheme.pingFang18
        
        self.dietPicker.delegate = self
        self.dietPicker.dataSource = self
        
        // prevents keyboard from blocking lowermost fields
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    // pickerview methods for the diet picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dietPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textAlignment = .center
        label.font = ColorScheme.pingFang18
        label.text = dietPickerData[row]
        return label
    }
    
    // go the next view controller to view search recipe results
    @IBAction func seeSearchResults(_ sender: Any) {
        performSegue(withIdentifier: "generalSearchResults", sender: sender)
    }
    
    // sends form data to next controller via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "generalSearchResults" {
            let newSearch: SearchRecipesViewController = segue.destination as! SearchRecipesViewController
            
            let query: String = queryField.text ?? ""
            let minRank: String = minRankField.text ?? ""
            let maxRank: String = maxRankField.text ?? ""
            let ingr: String = maxIngredientsField.text ?? ""
            let diet: String = dietPickerData[dietPicker.selectedRow(inComponent: 0)]
            let minCal: String = minCalField.text ?? ""
            let maxCal: String = maxCalField.text ?? ""
            let minTime: String = minTimeField.text ?? ""
            let maxTime: String = maxTimeField.text ?? ""
            let excluded: String = excludedField.text ?? ""
            
            if query == "" {
                newSearch.query = "kale"
            } else {
                newSearch.query = query
            }
            
            if isStringAnInt(string: minRank) {
                newSearch.from = Int(minRank)! - 1 // rank entered by user starts from 1
            } else {
                newSearch.from = 0
            }
            
            if isStringAnInt(string: maxRank) {
                newSearch.to = Int(maxRank)!
            } else {
                newSearch.to = 10
            }
            
            if newSearch.from > newSearch.to {
                newSearch.to = newSearch.from + 10
            }
            
            if ingr != "" && isStringAnInt(string: ingr) {
                newSearch.ingr = Int(ingr)!
            } else {
                newSearch.ingr = Int.max
            }
            
            if diet != "none" {
                newSearch.diet = diet
            } else {
                newSearch.diet = ""
            }
            
            if minCal == "" {
                if maxCal == "" {
                    newSearch.calories = ""
                } else {
                    newSearch.calories = maxCal
                }
            } else {
                if maxCal == "" {
                    newSearch.calories = minCal + "+"
                } else {
                    newSearch.calories = minCal + "-" + maxCal
                }
            }
            
            if minTime == "" {
                if maxTime == "" {
                    newSearch.time = ""
                } else {
                    newSearch.time = maxTime
                }
            } else {
                if maxTime == "" {
                    newSearch.time = minTime + "+"
                } else {
                    newSearch.time = minTime + "-" + maxTime
                }
            }
            
            if excluded == "" {
                newSearch.excluded = []
            } else {
                newSearch.excluded = excluded.components(separatedBy: [","])
            }
 
        }
    }
    
    // checks to see if a string can be converted to an int
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    // checks to see if a string can be converted to a boolean
    func isStringAFloat(string: String) -> Bool {
        return Float(string) != nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
