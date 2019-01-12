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

// displays a pie chart of the number of times the user gave a particular rating to different recipes
class RatingsPieViewController: ViewController {

    @IBOutlet var pieChartView: PieChartView!
    
    private var pieChartData: [String: Int] = [:]
    
    // firebase database reference
    private var userRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // default pie chart display before data loaded
        pieChartView.noDataText = "You have no rated recipes."
        pieChartView.noDataFont = ColorScheme.pingFang18
        
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        pieChartUpdate() // populates the pie chart
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
            
            // formatting the pie chart display
            self.pieChartView.data = data
            self.pieChartView.legend.horizontalAlignment = .center
            self.pieChartView.legend.font = ColorScheme.pingFang18!
            self.pieChartView.chartDescription?.font = ColorScheme.pingFang18b!
            self.pieChartView.chartDescription?.text = "Your Recipe Ratings from 1-5 Stars"
            self.pieChartView.chartDescription?.xOffset = 190
            self.pieChartView.chartDescription?.yOffset = self.pieChartView.frame.height * (4/5)
            self.pieChartView.chartDescription?.textAlign = NSTextAlignment.center

            self.pieChartView.notifyDataSetChanged()
        }
    }
    
    // gets dictionary mapping rated recipe ids to rating values in database, counts up number of each rating value
    private func getRatingData(completionHandler: @escaping ([String: Int]) -> Void) {
        userRef.child("ratedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let snapshotDict = snapshot.value as! [String: Int]
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
