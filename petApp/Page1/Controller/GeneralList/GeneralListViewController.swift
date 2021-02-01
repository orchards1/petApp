//
//  GeneralListViewController.swift
//  petApp
//
//  Created by Michael Louis on 16/01/21.
//

import UIKit
import CoreData

class GeneralListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedID: UUID = UUID()
    var selectedPet: [Pets] = []
    var selectedSection = 0
    var generalRecord: [GeneralRecords] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetch(with: selectedID)
        generalRecord.reverse()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reloadTableView()
    {
        generalRecord.removeAll()
        fetch(with: selectedID)
        generalRecord.reverse()
        tableView.reloadData()
    }
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        performSegue(withIdentifier: "generalToAdd", sender: nil)
    }
    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetch(with identifier: UUID) {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Pets>(entityName: "Pets")
        fetchRequest.predicate = NSPredicate(format: "petID == %@", identifier as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            selectedPet = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for generalrecord in selectedPet.first!.generalRecord! {
            generalRecord.append((generalrecord as? GeneralRecords)!)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "generalToAdd")
        {
            let navController = segue.destination as! UINavigationController
            if let editVC = navController.topViewController as? AddMedViewController{
                editVC.isGeneral = true
                editVC.selectedID = selectedID
                
            }
            
        }
        else if(segue.identifier == "generalToDetail")
        {
            if let destinationViewController = segue.destination as? ConditionDetailViewController {
                
                
                destinationViewController.selectedGeneralCondition =  generalRecord[selectedSection]
                destinationViewController.isGeneral = true
    
                destinationViewController.selectedID = selectedID
                
            }
            
        }
        
    }
}
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

extension GeneralListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return generalRecord.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : GeneralListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "generalcell", for: indexPath) as! GeneralListTableViewCell
        cell.weightLabel.text = generalRecord[indexPath.section].weight
        cell.tempLabel.text = generalRecord[indexPath.section].temperature
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let generalDate = formatter.string(from: generalRecord[indexPath.row].date!)
        cell.dateLabel.text = generalDate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSection = indexPath.section
        performSegue(withIdentifier: "generalToDetail", sender: nil)
    }
    
}
