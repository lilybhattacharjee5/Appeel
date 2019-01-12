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
    
    var userRef: DatabaseReference!
    var recipeRef: DatabaseReference!
    
    var dietTypes: [String]!
    var unitsSold: [Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barChartView.noDataText = "You have no saved recipes."
        barChartView.noDataFont = ColorScheme.pingFang18
        
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        recipeRef = Database.database().reference().child("recipes")
        
        dietTypes = ["balanced", "high-protein", "high-fiber", "low-fat", "low-carb", "low-sodium"]
        
        barChartUpdate()
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
    
    func getRecipeData(completionHandler: @escaping ([String: Int]) -> Void) {
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
                    print(userSavedRecipes[counter])
                    self.recipeRef.child(userSavedRecipes[counter]).child("Diet Labels").observeSingleEvent(of: .value, with: { (recipeSnapshot) in
                        if recipeSnapshot.exists() {
                            let splitDietLabels: [String] = (recipeSnapshot.value as! String).components(separatedBy: ", ")
                            print(splitDietLabels)
                            if (recipeSnapshot.value as! String) != "" {
                                for label in splitDietLabels {
                                    dietData[label.lowercased()] = dietData[label.lowercased()]! + 1
                                }
                            }
                        }
                        print(counter)
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
