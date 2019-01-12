//
//  RatingsPieViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/12/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Charts
import UIKit
import FirebaseDatabase
import FirebaseAuth

class RatingsPieViewController: ViewController {

    @IBOutlet var pieChartView: PieChartView!
    
    var pieChartData: [String: Int] = [:]
    var userRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pieChartView.noDataText = "You have no rated recipes."
        pieChartView.noDataFont = ColorScheme.pingFang18
        
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        pieChartUpdate()
    }
    
    func pieChartUpdate() {
        getRatingData() { pieChartData in
            let dataEntries: [PieChartDataEntry] = [
                PieChartDataEntry(value: Double(pieChartData["1"]!), label: "1"),
                PieChartDataEntry(value: Double(pieChartData["2"]!), label: "2"),
                PieChartDataEntry(value: Double(pieChartData["3"]!), label: "3"),
                PieChartDataEntry(value: Double(pieChartData["4"]!), label: "4"),
                PieChartDataEntry(value: Double(pieChartData["5"]!), label: "5")
            ]
            let dataSet = PieChartDataSet(values: dataEntries, label: "Recipe Ratings")
            dataSet.colors = ChartColorTemplates.joyful()
            let data = PieChartData(dataSet: dataSet)
            self.pieChartView.data = data
            self.pieChartView.legend.font = ColorScheme.pingFang18!
            self.pieChartView.chartDescription?.font = ColorScheme.pingFang18b!
            self.pieChartView.chartDescription?.text = "Your Recipe Ratings from 1-5 Stars"
            self.pieChartView.chartDescription?.xOffset = 320
            self.pieChartView.chartDescription?.yOffset = self.pieChartView.frame.height * (4/5)
            self.pieChartView.legend.xOffset = 70
            self.pieChartView.chartDescription?.textAlign = NSTextAlignment.left
            
            //All other additions to this function will go here
            
            //This must stay at end of function
            self.pieChartView.notifyDataSetChanged()
        }
    }
    
    private func getRatingData(completionHandler: @escaping ([String: Int]) -> Void) {
        userRef.child("ratedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                var snapshotDict = snapshot.value as! [String: Int]
                var ratingDict = ["1": 0, "2": 0, "3": 0, "4": 0, "5": 0]
                for (url, rating) in snapshotDict {
                    ratingDict[String(rating)] = ratingDict[String(rating)]! + 1
                }
                completionHandler(ratingDict)
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
