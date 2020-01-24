//
//  FoodTableViewController.swift
//  Fridge Tracker
//
//  Created by Nurin Izzati Jafri on 2020/01/19.
//  Copyright © 2020 Nurin Izzati Jafri. All rights reserved.
//
import os.log
import UIKit

class FoodTableViewController: UITableViewController {
    //MARK: Properties
    var foods = [Food]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem
        
        // Load the sample data.

       // loadSampleFoods()
        
        // Load any saved meals, otherwise load sample data.
        if let savedFoods = loadFoods() {
            foods += savedFoods
            
        }
        else {
            // Load the sample data.
            loadSampleFoods()
        }
       
    }

   // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FoodTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as? FoodTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FoodTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let food = foods[indexPath.row]
        cell.nameLabel.text = food.name
        cell.photoImageView.image = food.photo
        cell.dateLabel.text = food.expirydate
        return cell
        
    }
    

  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            foods.remove(at: indexPath.row)
            saveFoods()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
    
    

    
  // Override to support rearranging the table view.
    //override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 //let sortedArray = foods.sort { $0.expirydate < $1.expirydate }
 //   }
//
//
//
//    // Override to support conditional rearranging of the table view.
   //override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
     //  return true
    //}
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new food.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let foodDetailViewController = segue.destination as? FoodViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedFoodCell = sender as? FoodTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedFoodCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedFood = foods[indexPath.row]
            foodDetailViewController.food = selectedFood
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToFoodList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FoodViewController, let food = sourceViewController.food {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                foods[selectedIndexPath.row] = food
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
            // Add a new meal.
            let newIndexPath = IndexPath(row: foods.count, section: 0)
            foods.append(food)
            //position after save button is clicked
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
            // Save the meals.
           let sortedArray = foods.sort { $0.expirydate < $1.expirydate }
            saveFoods()
           
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleFoods() {
        let photo1 = UIImage(named: "food1")
        let photo2 = UIImage(named: "food2")
        let photo3 = UIImage(named: "food3")
        
        guard let food1 = Food(name: "ヨーグルト", photo: photo1, expirydate: "2020年10月10日" ) else {
            fatalError("Unable to instantiate food1")
        }
        
        guard let food2 = Food(name: "牛乳", photo: photo2, expirydate: "2019年10月03日") else {
            fatalError("Unable to instantiate food2")
        }
        
        guard let food3 = Food(name: "パン", photo: photo3, expirydate: "2020年11月04日") else {
            fatalError("Unable to instantiate food3")
        }
        
//        foods.sort {
//            $0.expirydate < $1.expirydate
//        }
        foods += [food1, food2, food3]
        //expirydate; ＝; expirydate.sort { $0 < $1 }
//        let sortedArray = foods.sort{ $0.expirydate.compare($1.expirydate) == ComparisonResult.orderedAscending }
        let sortedArray = foods.sort { $0.expirydate > $1.expirydate }
        }
    
    private func saveFoods() {
         //let sortedArray = foods.sort { $0.expirydate < $1.expirydate }
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(foods, toFile: Food.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Foods successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save foods...", log: OSLog.default, type: .error)
        }
    }
    private func loadFoods() -> [Food]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Food.ArchiveURL.path) as? [Food]
    }
}




