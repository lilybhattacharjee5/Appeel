//
//  DietBarViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/12/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase
import FirebaseAuth

class DietBarViewController: ViewController {

    @IBOutlet var barChartView: BarChartView!
    
    // maps to firebase database references
    private var userRef: DatabaseReference!
    private var recipeRef: DatabaseReference!
    
    // all diet types that can be displayed in the bar chart
    private var dietTypes: [String] = ["balanced", "high-protein", "high-fiber", "low-fat", "low-carb", "low-sodium"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.barChartView.noDataText = "You have no saved recipes."
        self.barChartView.noDataFont = ColorScheme.pingFang18
        
        self.userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        self.recipeRef = Database.database().reference().child("recipes")
        
        self.barChartUpdate()
    }
    
    func barChartUpdate() {
        getRecipeData() { recipeData in
            var dataEntries: [BarChartDataEntry] = []
            var i = 0
            for (dietType, numRecipes) in recipeData {
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(numRecipes))
                dataEntries.append(dataEntry)
                i += 1
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Diet Label Type (Saved Recipes)")
            let chartData = BarChartData(dataSet: chartDataSet)
            self.barChartView.data = chartData
            self.barChartView.chartDescription?.text = ""
            self.barChartView.xAxis.labelPosition = .bottom
            self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dietTypes)
        }
    }
    
    // returns a dictionary mapping diet types to the number of times they occur in the user's saved recipe list
    func getRecipeData(completionHandler: @escaping ([String: Int]) -> Void) {
        // accesses user's saved recipe list
        userRef.child("savedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                var dietData: [String: Int] = [
                    "balanced": 0,
                    "high-protein": 0,
                    "high-fiber": 0,
                    "low-fat": 0,
                    "low-carb": 0,
                    "low-sodium": 0
                ]
                var userSavedRecipes: [String] = snapshot.value as! [String]
                for counter in 0..<userSavedRecipes.count {
                    // gets each recipe id from the saved list and searches for its diet label attribute in the recipe branch
                    // of the database
                    self.recipeRef.child(userSavedRecipes[counter]).child("Diet Labels").observeSingleEvent(of: .value, with: { (recipeSnapshot) in
                        if recipeSnapshot.exists() {
                            // diet labels have been concatenated into string form, so this splits them back into an array of strings
                            let splitDietLabels: [String] = (recipeSnapshot.value as! String).components(separatedBy: ", ")
                            if (recipeSnapshot.value as! String) != "" {
                                for label in splitDietLabels {
                                    dietData[label.lowercased()] = dietData[label.lowercased()]! + 1
                                }
                            }
                        }
                        if counter == userSavedRecipes.count - 1 {
                            completionHandler(dietData)
                        }
                    })
                }
            }
        })
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
