//
//  IngredientChoicesViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Clarifai

// allows user to view all ingredients that might have been used to make a dish displayed in an image
class IngredientChoicesViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var ingredientChoices: UITableView!
    @IBOutlet var ingredientsLabel: UILabel!
    @IBOutlet var nextToGen: UIButton!
    
    private var ingredientChoicesData: [[String: Any]] = [] // helps populate ingredients table
    private var selectedCells: [String] = [] // keeps track of selected cells
    
    var imageData: UIImage! // stores image that the user uploads
    
    private var clarifaiApp: ClarifaiApp = ApiKeys.getClarifaiApp()
    
    private var query: String! // composes query for general search controller
    
    private let padding: CGFloat = 7.0
    private let borderRadius: CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // formats title label
        ingredientsLabel.font = ColorScheme.cochinItalic50
        ingredientsLabel.textColor = ColorScheme.red
        ingredientsLabel.text = "Ingredients"
        
        // formats button to general controller
        self.nextToGen.setTitle(">", for: .normal)
        self.nextToGen.setTitleColor(ColorScheme.black, for: .normal)
        self.nextToGen.layer.cornerRadius = borderRadius
        self.nextToGen.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.nextToGen.titleLabel!.font = ColorScheme.pingFang24
        self.nextToGen.backgroundColor = ColorScheme.blue
        
        // sets up tableview options
        self.ingredientChoices.delegate = self
        self.ingredientChoices.dataSource = self
        self.ingredientChoices.allowsMultipleSelection = true
        
        createIngredList() // asynchronously populates tableview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientChoicesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientChoices.dequeueReusableCell(withIdentifier: "photoResult") as! PhotoResultsTableViewCell
        
        // name of concept returned by Clarifai
        cell.conceptName.text = ingredientChoicesData[indexPath.row]["concept"] as? String ?? ""
        cell.conceptName.font = ColorScheme.pingFang18b
        
        // probability that the concept is displayed in the image
        cell.probability.text = (ingredientChoicesData[indexPath.row]["probability"] as? String ?? "0") + "%"
        cell.probability.font = ColorScheme.pingFang18
        
        return cell
    }
    
    // colors the cell green if it has been selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: PhotoResultsTableViewCell = ingredientChoices.cellForRow(at: indexPath as IndexPath) as! PhotoResultsTableViewCell
        selectedCell.contentView.backgroundColor = ColorScheme.green
        selectedCells.append(selectedCell.conceptName.text!)
    }
    
    // makes the cell clear if it is deselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:PhotoResultsTableViewCell = ingredientChoices.cellForRow(at: indexPath) as! PhotoResultsTableViewCell
        cellToDeSelect.contentView.backgroundColor = UIColor.clear
        if let index = selectedCells.index(of: cellToDeSelect.conceptName.text!) {
            selectedCells.remove(at: index)
        }
    }
    
    // fills up table of ingredient guesses
    private func createIngredList() {
        predictIngredients(image: ClarifaiImage(image: imageData)) { response in
            self.ingredientChoicesData = response
            DispatchQueue.main.async {
                self.ingredientChoices.reloadData()
            }
        }
    }
    
    // accesses Clarifai's food model and parses the json result returned by the image as input
    private func predictIngredients(image: ClarifaiImage, completionHandler: @escaping ([[String: Any]]) -> Void) {
        clarifaiApp.getModelByID("bd367be194cf45149e75f01d59f77ba7", completion: { (model: ClarifaiModel?, error: Error?) in
            model!.predict(on: [image], completion: { (outputs, error) in
                guard let finalOutputs = outputs else {
                    print("prediction failed")
                    return
                }
                var conceptMatches: [[String: Any]] = []
                if let finalOutput = finalOutputs.first {
                    for concept in finalOutput.concepts {
                        conceptMatches.append([
                            "concept": (concept.conceptName ?? ""),
                            "probability": String(format: "%.1f", concept.score * 100)
                        ])
                    }
                }
                completionHandler(conceptMatches)
            })
        })
    }
    
    // goes to general controller, sets query value so the field is populated in the new screen
    @IBAction func goToGeneral(_ sender: Any) {
        self.query = composeQuery()
        if self.query != "" {
            performSegue(withIdentifier: "searchByPhoto", sender: sender)
        }
    }
    
    // separates concepts by spaces to create query
    private func composeQuery() -> String {
        var returnedQuery: String = ""
        var counter = 0
        for selectedCell in selectedCells {
            let currVal = selectedCell
            if counter < selectedCells.count - 1 {
                if currVal != "" {
                    returnedQuery += (currVal + " ")
                }
            } else {
                returnedQuery += currVal
            }
            counter += 1
        }
        return returnedQuery
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "searchByPhoto" {
            let photoToGen: GeneralSearchViewController = segue.destination as! GeneralSearchViewController
            photoToGen.query = self.query
        }
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
