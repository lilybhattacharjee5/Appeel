//
//  IngredientChoicesViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Clarifai

class IngredientChoicesViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var ingredientChoices: UITableView!
    @IBOutlet var ingredientsLabel: UILabel!
    var ingredientChoicesData: [[String: Any]] = []
    @IBOutlet var nextToGen: UIButton!
    
    var imageData: UIImage!
    var clarifaiApp: ClarifaiApp = ApiKeys.getClarifaiApp()
    
    var query: String!
    
    var selectedCells: [PhotoResultsTableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ingredientsLabel.font = ColorScheme.cochinItalic50
        ingredientsLabel.textColor = ColorScheme.red
        ingredientsLabel.text = "Ingredients"
        
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        self.nextToGen.setTitle(">", for: .normal)
        self.nextToGen.setTitleColor(ColorScheme.black, for: .normal)
        self.nextToGen.layer.cornerRadius = borderRadius
        self.nextToGen.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.nextToGen.titleLabel!.font = ColorScheme.pingFang24
        self.nextToGen.backgroundColor = ColorScheme.blue
        
        self.ingredientChoices.delegate = self
        self.ingredientChoices.dataSource = self
        self.ingredientChoices.allowsMultipleSelection = true
        
        createIngredList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientChoicesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientChoices.dequeueReusableCell(withIdentifier: "photoResult") as! PhotoResultsTableViewCell
        cell.conceptName.text = ingredientChoicesData[indexPath.row]["concept"] as? String ?? ""
        cell.conceptName.font = ColorScheme.pingFang18b
        cell.probability.text = (ingredientChoicesData[indexPath.row]["probability"] as? String ?? "0") + "%"
        cell.probability.font = ColorScheme.pingFang18
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = ingredientChoices.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = ColorScheme.green
        selectedCells.append(selectedCell as! PhotoResultsTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = ingredientChoices.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.clear
        if let index = selectedCells.index(of: cellToDeSelect as! PhotoResultsTableViewCell) {
            selectedCells.remove(at: index)
        }
    }
    
    func createIngredList() {
        predictIngredients(image: ClarifaiImage(image: imageData)) { response in
            self.ingredientChoicesData = response
            DispatchQueue.main.async {
                self.ingredientChoices.reloadData()
            }
        }
    }
    
    func predictIngredients(image: ClarifaiImage, completionHandler: @escaping ([[String: Any]]) -> Void) {
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
    
    @IBAction func goToGeneral(_ sender: Any) {
        self.query = composeQuery()
        if self.query != "" {
            performSegue(withIdentifier: "searchByPhoto", sender: sender)
        }
    }
    
    private func composeQuery() -> String {
        var returnedQuery: String = ""
        var counter = 0
        for selectedCell in selectedCells {
            let currVal = selectedCell.conceptName.text ?? ""
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
