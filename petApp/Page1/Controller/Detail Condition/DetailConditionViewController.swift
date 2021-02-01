//
//  DetailConditionViewController.swift
//  petApp
//
//  Created by Michael Louis on 14/01/21.
//

import UIKit
import CoreData

class DetailConditionViewController: UIViewController {
    
    @IBAction func GeneralDidPressed(_ sender: Any) {
        performSegue(withIdentifier: "toGeneralList", sender: nil)
    }
    @IBAction func segmentedControlDidChanged(_ sender: Any) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {//Medical
            tableViewIndex = 0
            tableView.reloadData()
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {//Vaccine
            tableViewIndex = 1
            tableView.reloadData()
        }
        else
        {//Other
            tableViewIndex = 2
            tableView.reloadData()
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var selectedSection:Int = 0
    var medicalRecord: [MedicalRecords] = []
    var vaccineRecord: [VaccineRecords] = []
    var otherRecord: [OtherRecords] = []
    var generalRecord: [GeneralRecords] = []
    var selectedID : UUID = UUID()
    var selectedPet: [Pets] = []
    var selectedButton = ""
    var tableViewIndex = 0
    var isCat = false
    var isDog = false
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Medical Condition", message: "Choose data type", preferredStyle: UIAlertController.Style.alert)
        
        let general = UIAlertAction(title: "General", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectedButton = "General"
            self.performSegue(withIdentifier: "toMedical", sender: nil)
        }
        let med = UIAlertAction(title: "Medical", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectedButton = "Medical"
            self.performSegue(withIdentifier: "toMedical", sender: nil)
        }
        let vac = UIAlertAction(title: "Vaccine", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "toVaccine", sender: nil)
            
        }
        let other = UIAlertAction(title: "Other", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectedButton = "Other"
            self.performSegue(withIdentifier: "toMedical", sender: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
        }
        
        // Add the actions
        alert.addAction(general)
        alert.addAction(med)
        alert.addAction(vac)
        alert.addAction(other)
        alert.addAction(cancel)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fetch(with: selectedID)
        if(selectedPet.first?.value(forKey: "petType") as! String == "Cat")
        {
            print("INI KUCING")
            isCat = true
        }
        else
        {
            print("BUKAN KUCING")
            isCat = false
        }
        print("lihat")
        print(medicalRecord.count)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    func setupView()
    {
        medicalRecord = medicalRecord.reversed()
        otherRecord = otherRecord.reversed()
        vaccineRecord = vaccineRecord.reversed()
        if(generalRecord.count == 0)
        {
            weightLabel.text = "-"
            tempLabel.text = "-"
            dateLabel.text = "-"
        }
        else
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            var dateString = formatter.string(from: (generalRecord.last?.date)!)
            weightLabel.text = generalRecord.last?.weight
            tempLabel.text = generalRecord.last?.temperature
            dateLabel.text = dateString
        }
    }
    @objc func reloadTableView()
    {
        print("JALANNNNNNNN")
        fetch(with: selectedID)
        setupView()
        tableView.reloadData()
    }
    func fetch(with identifier: UUID) {
        medicalRecord.removeAll()
        otherRecord.removeAll()
        generalRecord.removeAll()
        vaccineRecord.removeAll()
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
        for medicalrecord in selectedPet.first!.medicalRecord! {
            medicalRecord.append((medicalrecord as? MedicalRecords)!)
        }
        
        for vaccinerecord in selectedPet.first!.vaccineRecord! {
            vaccineRecord.append((vaccinerecord as? VaccineRecords)!)
        }
        
        for otherrecord in selectedPet.first!.otherRecord! {
            otherRecord.append((otherrecord as? OtherRecords)!)
        }
        
        for generalrecord in selectedPet.first!.generalRecord! {
            generalRecord.append((generalrecord as? GeneralRecords)!)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMedical")
        {
            let navController = segue.destination as! UINavigationController
            if let editVC = navController.topViewController as? AddMedViewController{
                if(selectedButton == "Medical")
                {
                    editVC.isMedical = true
                    editVC.selectedID = selectedID
                }
                else if(selectedButton == "General")
                {
                    editVC.isGeneral = true
                    editVC.selectedID = selectedID
                }
                else
                {
                    editVC.isOther = true
                    editVC.selectedID = selectedID
                }
            }
        }
        else if(segue.identifier == "toGeneralList")
        {
            if let destinationViewController = segue.destination as? GeneralListViewController {
                destinationViewController.selectedID = selectedID
            }
        }
        else if(segue.identifier == "toVaccine")
        {
            let navController = segue.destination as! UINavigationController
            if let editVC = navController.topViewController as? AddVacViewController{
                if(isCat == true)
                {
                    editVC.isCat = true
                    editVC.selectedID = selectedID
                }
                else if(isCat == false)
                {
                    editVC.isCat = false
                    editVC.selectedID = selectedID
                }
            }
        }
        else if(segue.identifier == "toVaccineDetail")
        {
            let destinationViewController = segue.destination as? VaccineDetailViewController
            destinationViewController?.selectedVaccineRecord =  vaccineRecord[selectedSection]
            if(selectedPet[0].petType == "Cat")
            {
                destinationViewController?.isCat = true
            }
            else
            {
                destinationViewController?.isCat = false
            }
        }
        else if(segue.identifier == "toConditionDetail")
        {
                if(tableViewIndex == 0)
                {
                    let destinationViewController = segue.destination as? ConditionDetailViewController
                    destinationViewController!.selectedMedicalCondition =  medicalRecord[selectedSection]
                    destinationViewController!.isMedical = true
                }
                else if(tableViewIndex == 2)
                {
                    let destinationViewController = segue.destination as? ConditionDetailViewController
                    destinationViewController!.selectedOtherCondition =  otherRecord[selectedSection]
                    destinationViewController!.isOther = true
                }
                
                
            }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     */
    
}
extension DetailConditionViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableViewIndex == 0)
        {
            return (selectedPet.first?.medicalRecord!.count)!
        }
        else if(tableViewIndex == 1)
        {
            return (selectedPet.first?.vaccineRecord!.count)!
        }
        else
        {
            return (selectedPet.first?.otherRecord!.count)!
        }
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
        let cell : ConditionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "conditioncell", for: indexPath) as! ConditionTableViewCell
        if(tableViewIndex == 0)
        {
            cell.titleLabel.text = medicalRecord[indexPath.section].bodypart
            cell.descriptionLabel.text = medicalRecord[indexPath.section
            ].condition
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: medicalRecord[indexPath.section].date!)
            cell.dateLabel.text = dateString
        }
        else if(tableViewIndex == 1)
        {//Vaccine
            var strings = vaccineRecord[indexPath.section
            ].type as? [String]
            var types: String = strings![0]
            if(vaccineRecord.count > 1)
            {
                for i in 1...vaccineRecord.count - 1
                {
                    types = types + ", " + strings![i]
                }
            }
            cell.titleLabel.text = vaccineRecord[indexPath.section].name
            cell.descriptionLabel.text = types
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            var dateString = formatter.string(from: vaccineRecord[indexPath.section].date!)
            cell.dateLabel.text = dateString
        }
        else if(tableViewIndex == 2)
        {//Other
            
            cell.titleLabel.text = otherRecord[indexPath.section].title
            cell.descriptionLabel.text = otherRecord[indexPath.section
            ].location
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            var dateString = formatter.string(from: otherRecord[indexPath.section].date!)
            cell.dateLabel.text = dateString
            
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableViewIndex == 0)
        {//medical
            selectedSection = indexPath.section
            performSegue(withIdentifier: "toConditionDetail", sender: nil)
        }
        else if(tableViewIndex == 1)
        {//Vaccine
            selectedSection = indexPath.section
            performSegue(withIdentifier: "toVaccineDetail", sender: nil)
        }
        else if(tableViewIndex == 2)
        {//Other
            selectedSection = indexPath.section
            performSegue(withIdentifier: "toConditionDetail", sender: nil)
        }
    }
    
}
