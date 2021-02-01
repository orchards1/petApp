//
//  AddMedViewController.swift
//  petApp
//
//  Created by Michael Louis on 14/01/21.
//

import UIKit
import CoreData

class AddMedViewController: UIViewController, UITextViewDelegate{
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var datePicker1 = UIDatePicker()
    var datePicker2 = UIDatePicker()
    //Medical
    var isMedical = false
    var isGeneral = false
    var isOther = false
    var nextdate:Date? = nil
    
    var generalText : [String] = ["Weight in Kg","Temperature in Celcius","Condition","Vet","Doctor","Date"]
    var medicalText : [String] = ["Body Part","Date","Condition","Vet","Doctor","Next Visit"]
    var otherText : [String] = ["Title","Date","Location","Next Visit"]
    var isBodyPartEmpty = false
    var isConditionEmpty = false
    var isWeightEmpty = false
    var isTemperatureEmpty = false
    var isTitleEmpty = false
    var isDateEmpty = false
    var isLocationEmpty = false
    
    var selectedID:UUID = UUID()
    var selectedPet: [Pets] = []
    
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
    func saveMedical(bodypart: String,date: Date, condition: String, vet: String, doctor: String,note: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "MedicalRecords",
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
        
        let medicalRecord = MedicalRecords(entity: entity, insertInto: managedContext)
        
        // 3
        medicalRecord.ofPets = selectedPet.first
        medicalRecord.setValue(bodypart, forKey: "bodypart")
        medicalRecord.setValue(condition, forKey: "condition")
        medicalRecord.setValue(date, forKey: "date")
        if(nextdate == nil)
        {
            medicalRecord.setValue(nil, forKey: "nextdate")
        }
        else
        {
            medicalRecord.setValue(datePicker2.date, forKey: "nextdate")
        }
        medicalRecord.setValue(doctor, forKey: "doctor")
        medicalRecord.setValue(vet, forKey: "vet")
        medicalRecord.setValue(notesTextView.text, forKey: "notes")
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveGeneral(weight: String,date: Date, condition: String, vet: String, doctor: String, temperature: String,note: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "GeneralRecords",
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
        
        let generalRecord = GeneralRecords(entity: entity, insertInto: managedContext)
        
        // 3
        generalRecord.ofPets = selectedPet.first
        generalRecord.setValue(weight + String(" Kg"), forKey: "weight")
        generalRecord.setValue(condition, forKey: "condition")
        generalRecord.setValue(date, forKey: "date")
        generalRecord.setValue(temperature + String(" Celcius"), forKey: "temperature")
        generalRecord.setValue(doctor, forKey: "doctor")
        generalRecord.setValue(vet, forKey: "vet")
        generalRecord.setValue(notesTextView.text, forKey: "notes")
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveOther(title: String,date: Date, location: String,note: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "OtherRecords",
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
        
        let otherRecord = OtherRecords(entity: entity, insertInto: managedContext)
        
        // 3
        otherRecord.ofPets = selectedPet.first
        otherRecord.setValue(title, forKey: "title")
        otherRecord.setValue(location, forKey: "location")
        otherRecord.setValue(date, forKey: "date")
        if(nextdate == nil)
        {
            otherRecord.setValue(nil, forKey: "nextvisit")
        }
        else
        {
            otherRecord.setValue(datePicker2.date, forKey: "nextvisit")
        }
        otherRecord.setValue(notesTextView.text, forKey: "notes")
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        
        if(isMedical)
        {
        let index1 = IndexPath(row: 0, section: 0)
        let bodypart: AddMedTableViewCell = self.tableView.cellForRow(at: index1) as! AddMedTableViewCell
        let index2 = IndexPath(row: 1, section: 0)
        let date: AddMedTableViewCell = self.tableView.cellForRow(at: index2) as! AddMedTableViewCell
        let index3 = IndexPath(row: 2, section: 0)
        let condition: AddMedTableViewCell = self.tableView.cellForRow(at: index3) as! AddMedTableViewCell
        let index4 = IndexPath(row: 3, section: 0)
        let vet: AddMedTableViewCell = self.tableView.cellForRow(at: index4) as! AddMedTableViewCell
        let index5 = IndexPath(row: 4, section: 0)
        let doctor: AddMedTableViewCell = self.tableView.cellForRow(at: index5) as! AddMedTableViewCell
        let index6 = IndexPath(row: 5, section: 0)
        let nextdate: AddMedTableViewCell = self.tableView.cellForRow(at: index6) as! AddMedTableViewCell
            
        let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let nextdatevalue = dateFormatter.date(from: nextdate.inputTextField.text!) ?? nil
                
                
                if(bodypart.inputTextField.text == "")
                {
                    isBodyPartEmpty = true
                }
                else
                {
                    isBodyPartEmpty = false
                }
                
                if(condition.inputTextField.text == "")
                {
                    isConditionEmpty = true
                }
                else
                {
                    isConditionEmpty = false
                }
                
                if(isBodyPartEmpty == true)
                {
                    let alert = UIAlertController(title: "Data incomplete", message: "Please input the body part", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                else if (isConditionEmpty == true)
                {
                    let alert = UIAlertController(title: "Data incomplete", message: "Please input the condition", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    saveMedical(bodypart: bodypart.inputTextField.text!, date: datePicker1.date, condition: condition.inputTextField.text!, vet: vet.inputTextField.text!, doctor: doctor.inputTextField.text!, note: notesTextView.text)
                    let vc = presentingViewController.self
                    let alert = UIAlertController(title: "Data saved!", message: "Data has been saved successfully", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        
                        vc!.dismiss(animated: true, completion: nil)
                        
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
            
        }
        else if (isGeneral)
        {
            let index1 = IndexPath(row: 0, section: 0)
            let weight: AddMedTableViewCell = self.tableView.cellForRow(at: index1) as! AddMedTableViewCell
            let index2 = IndexPath(row: 1, section: 0)
            let temperature: AddMedTableViewCell = self.tableView.cellForRow(at: index2) as! AddMedTableViewCell
            let index3 = IndexPath(row: 2, section: 0)
            let condition: AddMedTableViewCell = self.tableView.cellForRow(at: index3) as! AddMedTableViewCell
            let index4 = IndexPath(row: 3, section: 0)
            let vet: AddMedTableViewCell = self.tableView.cellForRow(at: index4) as! AddMedTableViewCell
            let index5 = IndexPath(row: 4, section: 0)
            let doctor: AddMedTableViewCell = self.tableView.cellForRow(at: index5) as! AddMedTableViewCell
            let index6 = IndexPath(row: 5, section: 0)
            let date: AddMedTableViewCell = self.tableView.cellForRow(at: index6) as! AddMedTableViewCell
            
            
            if(weight.inputTextField.text == "")
            {
                isWeightEmpty = true
            }
            else
            {
                isWeightEmpty = false
            }
            
            if(condition.inputTextField.text == "")
            {
                isConditionEmpty = true
            }
            else
            {
                isConditionEmpty = false
            }
            
            if(temperature.inputTextField.text == "")
            {
                isTemperatureEmpty = true
            }
            else
            {
                isTemperatureEmpty = false
            }
            
            
            if(isBodyPartEmpty == true)
            {
                let alert = UIAlertController(title: "Data incomplete", message: "Please input the body part", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else if (isConditionEmpty == true)
            {
                let alert = UIAlertController(title: "Data incomplete", message: "Please input the condition", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else if (isTemperatureEmpty == true)
            {
                let alert = UIAlertController(title: "Data incomplete", message: "Please input the temperature", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                saveGeneral(weight: weight.inputTextField.text!, date: datePicker1.date, condition: condition.inputTextField.text!, vet: vet.inputTextField.text!, doctor: doctor.inputTextField.text!, temperature: temperature.inputTextField.text!, note: notesTextView.text)
                let vc = presentingViewController.self
                let alert = UIAlertController(title: "Data saved!", message: "Data has been saved successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    
                    vc!.dismiss(animated: true, completion: nil)
                    
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
            
            
            
            
        }
        else if(isOther)
        {
            let index1 = IndexPath(row: 0, section: 0)
            let title: AddMedTableViewCell = self.tableView.cellForRow(at: index1) as! AddMedTableViewCell
            let index2 = IndexPath(row: 1, section: 0)
            let date: AddMedTableViewCell = self.tableView.cellForRow(at: index2) as! AddMedTableViewCell
            let index3 = IndexPath(row: 2, section: 0)
            let location: AddMedTableViewCell = self.tableView.cellForRow(at: index3) as! AddMedTableViewCell
            let index4 = IndexPath(row: 3, section: 0)
            let nextvisit: AddMedTableViewCell = self.tableView.cellForRow(at: index4) as! AddMedTableViewCell
            let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let nextdatevalue = dateFormatter.date(from: nextvisit.inputTextField.text!) ?? nil
            
            if(title.inputTextField.text == "")
            {
                isTitleEmpty = true
            }
            else
            {
                isTitleEmpty = false
            }
            
            if(date.inputTextField.text == "")
            {
                isDateEmpty = true
            }
            else
            {
                isDateEmpty = false
            }
            
            if(location.inputTextField.text == "")
            {
                isLocationEmpty = true
            }
            else
            {
                isLocationEmpty = false
            }
            
            
            if(isTitleEmpty == true)
            {
                let alert = UIAlertController(title: "Data incomplete", message: "Please input the title", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else if (isLocationEmpty == true)
            {
                let alert = UIAlertController(title: "Data incomplete", message: "Please input the location", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else if (isDateEmpty == true)
            {
                let alert = UIAlertController(title: "Data incomplete", message: "Please input the date", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                saveOther(title: title.inputTextField.text!, date: datePicker1.date, location: location.inputTextField.text!, note: notesTextView.text)
                let vc = presentingViewController.self
                let alert = UIAlertController(title: "Data saved!", message: "Data has been saved successfully", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    
                    vc!.dismiss(animated: true, completion: nil)
                    
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if(isMedical)
        {
            self.title = "Medical"
        }
        else if(isOther)
        {
            self.title = "Other"
        }
        else if(isGeneral)
        {
            self.title = "General"
        }
        super.viewDidLoad()
        setupTableView()
        setupTextView()
        
    }
    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func setupTextView()
    {
        notesTextView.delegate = self
        notesTextView.text = "Add Notes"
        notesTextView.textColor = UIColor.lightGray
        notesTextView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
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
    @objc func datedonePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let index3 = IndexPath(row: 1, section: 0)
        let date: AddMedTableViewCell = self.tableView.cellForRow(at: index3) as! AddMedTableViewCell
        date.inputTextField.text = formatter.string(from: datePicker1.date)
        self.view.endEditing(true)
        
    }
    @objc func nextdatedonePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        if(!isOther)
        {
            let index3 = IndexPath(row: 5, section: 0)
            let date: AddMedTableViewCell = self.tableView.cellForRow(at: index3) as! AddMedTableViewCell
            date.inputTextField.text = formatter.string(from: datePicker2.date)
            nextdate = datePicker2.date
        }
        else
        {
            let index3 = IndexPath(row: 3 , section: 0)
            let date: AddMedTableViewCell = self.tableView.cellForRow(at: index3) as! AddMedTableViewCell
            date.inputTextField.text = formatter.string(from: datePicker2.date)
            nextdate = datePicker2.date
        }
        
        self.view.endEditing(true)
        
    }
}
extension AddMedViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isMedical == true)
        {
            return medicalText.count
        }
        else if(isGeneral)
        {
            return generalText.count
        }
        else if(isOther)
        {
            return otherText.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let datedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datedonePicker));
        let nextdatedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(nextdatedonePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        let cell : AddMedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addmedcell", for: indexPath) as! AddMedTableViewCell
        
        if(isMedical)
        {
            cell.titleLabel.text = medicalText[indexPath.row]
        }
        else if(isGeneral)
        {
            cell.titleLabel.text = generalText[indexPath.row]
        }
        else if(isOther)
        {
            cell.titleLabel.text = otherText[indexPath.row]
        }
        
        
        
        if(indexPath.row == 0)
        {
            if(isGeneral)
            {
                cell.inputTextField.placeholder = "Input Body Weight"
            }
            else if(isMedical)
            {
            cell.inputTextField.placeholder = "Input Body Part"
            }
            else if(isOther)
            {
                cell.inputTextField.placeholder = "Input Title"
            }
        }
        else if(indexPath.row == 1)
        {
            if(isGeneral)
            {
                cell.inputTextField.placeholder = "Input Body Temperature"
            }
            else if(isMedical || isOther)
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
            
        }
        else if(indexPath.row == 2)
        {
            if(isMedical || isGeneral)
            {
                cell.inputTextField.placeholder = "Healthy / Unhealthy"
            }
            else
            {
                cell.inputTextField.placeholder = "Input Location"
            }
        }
        else if(indexPath.row == 3)
        {
            if(isOther)
            {
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                
                cell.tintColor = .clear
                cell.inputTextField.inputView = datePicker2
                cell.inputTextField.inputAccessoryView = toolbar
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
        }
        else if(indexPath.row == 5)
        {
            if(isMedical == true)
            {
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                
                cell.tintColor = .clear
                cell.inputTextField.inputView = datePicker2
                cell.inputTextField.inputAccessoryView = toolbar
                
                cell.inputTextField.placeholder = "Optional"
                if #available(iOS 13.4, *) {
                    datePicker2.preferredDatePickerStyle = .wheels
                    datePicker2.datePickerMode = .date
                    datePicker2.minimumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            else{
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                
                cell.tintColor = .clear
                cell.inputTextField.inputView = datePicker1
                cell.inputTextField.inputAccessoryView = toolbar
                datePicker1.date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let todayDate = formatter.string(from: Date())
                cell.inputTextField.text = todayDate
                if #available(iOS 13.4, *) {
                    datePicker1.preferredDatePickerStyle = .wheels
                    datePicker1.datePickerMode = .date
                    datePicker1.minimumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else
        {
            cell.inputTextField.placeholder = "Optional"
        }
        
        
        heightConstraint.constant = tableView.contentSize.height
        return cell
        
    }
}
