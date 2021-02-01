//
//  AddVacViewController.swift
//  petApp
//
//  Created by Michael Louis on 18/01/21.
//

import UIKit
import CoreData

class AddVacViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var heightConstant2: NSLayoutConstraint!
    @IBOutlet var heightConstant1: NSLayoutConstraint!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var tableView1: UITableView!
    
    
    var datePicker1 = UIDatePicker()
    var datePicker2 = UIDatePicker()
    
    var vaccineText : [String] = ["Vaccine Name","Date Given","Vet","Doctor","Next Visit"]
    
    var catVaccineList : [String] = ["Rhinotracheitis","Calivirus","Panleukopenia","Rabies","Chlamydia","Leukimia","Infectious Peritonitis"]
    
    var dogVaccineList : [String] = ["Parvo","Distemper","ParaInfluenza","Hepatitis CAV-2","Coronavirus","Leptospirosis 2/4","Bordotella","Rabies"]
    
    var selectedVaccineList : [String] = []
    var isCat = true
    var selectedID:UUID = UUID()
    var selectedPet: [Pets] = []
    var isNameEmpty = false
    var isDoctorEmpty = false
    var isVetEmpty = false
    var isVaccineTypeEmpty = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        prepareTableView()
        setupTextView()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @IBAction func saveDidTapped(_ sender: Any) {
        selectedVaccineList.removeAll()
        if(isCat == true)
        {
            for i in 0...catVaccineList.count - 1
            {
                let index = IndexPath(row: i, section: 0)
                let vaccineType: AddVaccineTableViewCell = self.tableView2.cellForRow(at: index) as! AddVaccineTableViewCell
                if(vaccineType.radioButton.isSelected == true)
                {
                    selectedVaccineList.append(catVaccineList[index.row])
                }
                else
                {
                    
                }
            }
        }
        else if(isCat == false)
        {
            for i in 0...dogVaccineList.count - 1
            {
                let index = IndexPath(row: i, section: 0)
                let vaccineType: AddVaccineTableViewCell = self.tableView2.cellForRow(at: index) as! AddVaccineTableViewCell
                if(vaccineType.radioButton.isSelected == true)
                {
                    selectedVaccineList.append(dogVaccineList[index.row])
                }
                else
                {
                    
                }
            }
        }
        
        let index1 = IndexPath(row: 0, section: 0)
        let name: AddMedTableViewCell = self.tableView1.cellForRow(at: index1) as! AddMedTableViewCell
        let index3 = IndexPath(row: 2, section: 0)
        let vet: AddMedTableViewCell = self.tableView1.cellForRow(at: index3) as! AddMedTableViewCell
        let index4 = IndexPath(row: 3, section: 0)
        let doctor: AddMedTableViewCell = self.tableView1.cellForRow(at: index4) as! AddMedTableViewCell
        if(name.inputTextField.text == "")
        {
            isNameEmpty = true
        }
        else
        {
            isNameEmpty = false
        }
        
        if(doctor.inputTextField.text == "")
        {
            isDoctorEmpty = true
        }
        else
        {
            isDoctorEmpty = false
        }
        
        if(selectedVaccineList.count == 0)
        {
            isVaccineTypeEmpty = true
        }
        else
        {
            isVaccineTypeEmpty = false
        }
        
        if(vet.inputTextField.text == "")
        {
            isVetEmpty = true
        }
        else
        {
            isVetEmpty = false
        }
        if(isNameEmpty == true)
        {
            let alert = UIAlertController(title: "Data incomplete", message: "Please input the Vaccine Name", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if (isVetEmpty == true)
        {
            let alert = UIAlertController(title: "Data incomplete", message: "Please input the Vet Location", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if (isDoctorEmpty == true)
        {
            let alert = UIAlertController(title: "Data incomplete", message: "Please input the Doctor Name", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if (isVaccineTypeEmpty == true)
        {
            let alert = UIAlertController(title: "Data incomplete", message: "Please input the Vaccine Type", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            saveVaccine(name: name.inputTextField.text!, doctor: doctor.inputTextField.text!, vet: vet.inputTextField.text!, note: notesTextView.text!)
            
            let vc = presentingViewController.self
            let alert = UIAlertController(title: "Data saved!", message: "Data has been saved successfully", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                
                vc!.dismiss(animated: true, completion: nil)
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
        
        
        
        
    }
    
    func saveVaccine(name: String,doctor: String, vet: String,note: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "VaccineRecords",
                                       in: managedContext)!
        
        //fetch pets
        let fetchRequest = NSFetchRequest<Pets>(entityName: "Pets")
        fetchRequest.predicate = NSPredicate(format: "petID == %@", selectedID as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            selectedPet = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let vaccineRecord = VaccineRecords(entity: entity, insertInto: managedContext)
        
        // 3
        vaccineRecord.ofPets = selectedPet.first
        vaccineRecord.setValue(name, forKey: "name")
        vaccineRecord.setValue(datePicker1.date, forKey: "date")
        vaccineRecord.setValue(doctor, forKey: "doctor")
        vaccineRecord.setValue(vet, forKey: "vet")
        vaccineRecord.setValue(datePicker2.date, forKey: "nextvisit")
        vaccineRecord.setValue(notesTextView.text, forKey: "notes")
        vaccineRecord.setValue(selectedVaccineList, forKey: "type")
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func prepareTableView()
    {
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView2.delegate = self
        tableView2.dataSource = self
    }
    
    func setupTextView()
    {
        notesTextView.delegate = self
        notesTextView.text = "Add Notes"
        notesTextView.textColor = UIColor.lightGray
        notesTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == UIColor.lightGray {
            notesTextView.text = ""
            notesTextView.textColor = UIColor.black
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
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    @objc func nextdatedonePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let index4 = IndexPath(row: 4, section: 0)
        let date: AddMedTableViewCell = self.tableView1.cellForRow(at: index4) as! AddMedTableViewCell
        date.inputTextField.text = formatter.string(from: datePicker2.date)
        
        self.view.endEditing(true)
        
    }
    @objc func datedonePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let index3 = IndexPath(row: 1, section: 0)
        let date: AddMedTableViewCell = self.tableView1.cellForRow(at: index3) as! AddMedTableViewCell
        date.inputTextField.text = formatter.string(from: datePicker1.date)
        self.view.endEditing(true)
        
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
extension AddVacViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tableView1)
        {
            return vaccineText.count
        }
        else
        {
            if(isCat == true)
            {
                return catVaccineList.count
            }
            else
            {
                return dogVaccineList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableView1)
        {
            
            let datedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datedonePicker));
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let nextdatedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(nextdatedonePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
            let cell : AddMedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addmedcell", for: indexPath) as! AddMedTableViewCell
            cell.titleLabel.text = vaccineText[indexPath.row]
            if(indexPath.row == 0)
            {
                
                cell.inputTextField.placeholder = "Input Vaccine Name"
                
            }
            else if(indexPath.row == 1)
            {
                
                toolbar.setItems([cancelButton,spaceButton,datedoneButton], animated: false)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let todayDate = formatter.string(from: Date())
                cell.tintColor = .clear
                cell.inputTextField.text = todayDate
                cell.inputTextField.inputView = datePicker1
                cell.inputTextField.inputAccessoryView = toolbar
                if #available(iOS 13.4, *) {
                    datePicker1.preferredDatePickerStyle = .wheels
                    datePicker1.datePickerMode = .date
                    datePicker1.maximumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
                
                
            }
            else if(indexPath.row == 2)
            {
                
                cell.inputTextField.placeholder = "Input Vet"
                
            }
            else if(indexPath.row == 3)
            {
                
                cell.inputTextField.placeholder = "Input Doctor Name"
                
            }
            else if(indexPath.row == 4)
            {
                
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                
                cell.tintColor = .clear
                cell.inputTextField.inputView = datePicker2
                cell.inputTextField.inputAccessoryView = toolbar
                datePicker2.date = Date()
                cell.inputTextField.placeholder = "Optional"
                if #available(iOS 13.4, *) {
                    datePicker2.preferredDatePickerStyle = .wheels
                    datePicker2.datePickerMode = .date
                    datePicker2.minimumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
            }
            else
            {
                cell.inputTextField.placeholder = "Optional"
            }
            
            
            heightConstant1.constant = tableView.contentSize.height
            return cell
            
        }
        else
        {
            heightConstant2.constant = tableView.contentSize.height
            let cell : AddVaccineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addvaccell", for: indexPath) as! AddVaccineTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if(isCat)
            {
                cell.label.text = catVaccineList[indexPath.row]
                return cell
            }
            else
            {
                cell.label.text = dogVaccineList[indexPath.row]
                return cell
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tableView2)
        {
            let cell: AddVaccineTableViewCell = self.tableView2.cellForRow(at: indexPath) as! AddVaccineTableViewCell
            
            if(cell.radioButton.isSelected == true)
            {
                cell.radioButton.isSelected = false
            }
            else
            {
                cell.radioButton.isSelected = true
            }
        }
    }
}
