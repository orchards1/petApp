//
//  ConditionDetailViewController.swift
//  petApp
//
//  Created by Michael Louis on 20/01/21.
//

import UIKit
import CoreData

class ConditionDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var datePicker1 = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var selectedID:UUID = UUID()
    var selectedMedicalCondition: MedicalRecords = MedicalRecords()
    var selectedOtherCondition: OtherRecords = OtherRecords()
    var selectedGeneralCondition: GeneralRecords = GeneralRecords()
    
    var generalText : [String] = ["Weight in Kg","Temperature in Celcius","Condition","Vet","Doctor","Date"]
    var medicalText : [String] = ["Body Part","Date","Condition","Vet","Doctor","Next Visit"]
    var otherText : [String] = ["Title","Date","Location","Next Visit"]
    var isMedical = false
    var isGeneral = false
    var isOther = false
    
    @IBAction func deleteButtonDidTapped(_ sender: Any) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        if(isMedical)
        {
            let medicalRecord = selectedMedicalCondition
            managedContext.delete(medicalRecord)
        }
        else if(isOther)
        {
            let otherRecord = selectedOtherCondition
            managedContext.delete(otherRecord)
        }
        else if(isGeneral)
        {
            let generalRecord = selectedGeneralCondition
            managedContext.delete(generalRecord)
        }
        
        do {
            try managedContext.save()
        } catch {
            // Do something... fatalerror
        }
        let vc = presentingViewController.self
        let alert = UIAlertController(title: "Data deleted!", message: "Data has been deleted successfully", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            
            self.navigationController?.popViewController(animated: true)
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    override func viewDidLoad() {
        
        if(isMedical)
        {
            self.title = selectedMedicalCondition.bodypart
        }
        else if(isOther)
        {
            self.title = selectedOtherCondition.title
        }
        else if(isGeneral)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let conditionDate = formatter.string(from: selectedGeneralCondition.date!)
            self.title =      conditionDate   }
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
        notesTextView.text = ""
        notesTextView.textColor = UIColor.lightGray
        notesTextView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        if(isMedical)
        {
            notesTextView.textColor = .black
            notesTextView.text = selectedMedicalCondition.notes
        }
        else if(isOther)
        {
            notesTextView.textColor = . black
            notesTextView.text = selectedOtherCondition.notes
        }
        else if(isGeneral)
        {
            notesTextView.textColor = . black
            notesTextView.text = selectedGeneralCondition.notes
        }
        notesTextView.isEditable = false
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
        let date: DetailConditionTableViewCell = self.tableView.cellForRow(at: index3) as! DetailConditionTableViewCell
        date.textField.text = formatter.string(from: datePicker1.date)
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
            let date: DetailConditionTableViewCell = self.tableView.cellForRow(at: index3) as! DetailConditionTableViewCell
            date.textField.text = formatter.string(from: datePicker2.date)
        }
        else
        {
            let index3 = IndexPath(row: 3 , section: 0)
            let date: DetailConditionTableViewCell = self.tableView.cellForRow(at: index3) as! DetailConditionTableViewCell
            date.textField.text = formatter.string(from: datePicker2.date)
        }
        
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
extension ConditionDetailViewController: UITableViewDelegate,UITableViewDataSource{
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
        let cell : DetailConditionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailconditioncell", for: indexPath) as! DetailConditionTableViewCell
        
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
                cell.textField.placeholder = "Input Body Weight"
                cell.textField.text = selectedGeneralCondition.weight
            }
            else if(isMedical)
            {
                cell.textField.placeholder = "Input Body Part"
                cell.textField.text = selectedMedicalCondition.bodypart
            }
            else if(isOther)
            {
                cell.textField.placeholder = "Input Title"
                cell.textField.text = selectedOtherCondition.title
            }
        }
        else if(indexPath.row == 1)
        {
            if(isGeneral)
            {
                cell.textField.placeholder = "Input Body Temperature"
                cell.textField.text = selectedGeneralCondition.temperature
            }
            else if(isMedical)
            {
               
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let conditionDate = formatter.string(from: selectedMedicalCondition.date!)
                cell.tintColor = .clear
                cell.textField.inputView = datePicker1
                cell.textField.inputAccessoryView = toolbar
                cell.textField.text = conditionDate
                if #available(iOS 13.4, *) {
                    datePicker1.preferredDatePickerStyle = .wheels
                    datePicker1.datePickerMode = .date
                    datePicker1.maximumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
            }
            else if(isOther == true)
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let conditionDate = formatter.string(from: selectedOtherCondition.date!)
                cell.tintColor = .clear
                cell.textField.inputView = datePicker1
                cell.textField.inputAccessoryView = toolbar
                cell.textField.text = conditionDate
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
            if(isMedical)
            {
                cell.textField.text = selectedMedicalCondition.condition
                cell.textField.placeholder = "Healthy / Unhealthy"
            }
            else if(isGeneral)
            {
                cell.textField.text = selectedGeneralCondition.condition
                cell.textField.placeholder = "Healthy / Unhealthy"
            }
            else
            {
                cell.textField.text = selectedOtherCondition.location
                cell.textField.placeholder = "Input Location"
            }
        }
        else if(indexPath.row == 3)
        {
            if(isOther)
            {
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
              
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                if(selectedOtherCondition.nextvisit != nil)
                {
                    let conditionDate = formatter.string(from: selectedOtherCondition.nextvisit!)
                    cell.textField.text = conditionDate
                }
                cell.tintColor = .clear
                cell.textField.inputView = datePicker2
                cell.textField.inputAccessoryView = toolbar
                datePicker2.date = Date()
                cell.textField.placeholder = "Optional"
                if #available(iOS 13.4, *) {
                    datePicker2.preferredDatePickerStyle = .wheels
                    datePicker2.datePickerMode = .date
                    datePicker2.minimumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
            }
            else if(isGeneral)
            {
                cell.textField.placeholder = "Optional"
                cell.textField.text = selectedGeneralCondition.vet
            }
            else
            {
                cell.textField.placeholder = "Optional"
                if(isMedical)
                {
                cell.textField.text = selectedMedicalCondition.vet
                }
            }
        }
        else if(indexPath.row == 4)
        {
            if(isMedical)
            {
                cell.textField.placeholder = "Optional"
                if(selectedMedicalCondition.doctor == "")
                {
                    
                }
                else
                {
                cell.textField.text = selectedMedicalCondition.doctor
                }
            }
            else if(isGeneral)
            {
                cell.textField.text = selectedGeneralCondition.doctor
                cell.textField.placeholder = "Optional"
            }
        }
        else if(indexPath.row == 5)
        {
            if(isMedical == true)
            {
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                if(selectedMedicalCondition.nextdate != nil)
                {
                    let conditionDate = formatter.string(from: selectedMedicalCondition.nextdate!)
                    cell.textField.text = conditionDate
                }
                
                cell.tintColor = .clear
                cell.textField.inputView = datePicker2
                cell.textField.inputAccessoryView = toolbar
                
                datePicker2.date = Date()
                cell.textField.placeholder = "Optional"
                if #available(iOS 13.4, *) {
                    datePicker2.preferredDatePickerStyle = .wheels
                    datePicker2.datePickerMode = .date
                    datePicker2.minimumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            else if(isGeneral == true)
            {
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                if(selectedGeneralCondition.date != nil)
                {
                    let conditionDate = formatter.string(from: selectedGeneralCondition.date!)
                    cell.textField.text = conditionDate
                }
                
                cell.tintColor = .clear
                cell.textField.inputView = datePicker2
                cell.textField.inputAccessoryView = toolbar
                
                datePicker2.date = Date()
                cell.textField.placeholder = "Optional"
                if #available(iOS 13.4, *) {
                    datePicker2.preferredDatePickerStyle = .wheels
                    datePicker2.datePickerMode = .date
                    datePicker2.minimumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            else {
                toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let conditionDate = formatter.string(from: selectedMedicalCondition.nextdate!)
                cell.tintColor = .clear
                cell.textField.inputView = datePicker1
                cell.textField.inputAccessoryView = toolbar
                datePicker1.date = Date()
                cell.textField.text = conditionDate
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
            cell.textField.placeholder = "Optional"
        }
        
        cell.textField.isEnabled = false
        heightConstraint.constant = tableView.contentSize.height
        return cell
        
    }
}
