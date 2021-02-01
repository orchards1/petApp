//
//  VaccineDetailViewController.swift
//  petApp
//
//  Created by Michael Louis on 24/01/21.
//

import UIKit

class VaccineDetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var heightConstant2: NSLayoutConstraint!
    @IBOutlet var heightConstant1: NSLayoutConstraint!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var tableView1: UITableView!
    
    var datePicker1 = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var selectedVaccineRecord: VaccineRecords  = VaccineRecords()
    
    var vaccineText : [String] = ["Vaccine Name","Date Given","Vet","Doctor","Next Visit"]
    
    var catVaccineList : [String] = ["Rhinotracheitis","Calivirus","Panleukopenia","Rabies","Chlamydia","Leukimia","Infectious Peritonitis"]
    
    var dogVaccineList : [String] = ["Parvo","Distemper","ParaInfluenza","Hepatitis CAV-2","Coronavirus","Leptospirosis 2/4","Bordotella","Rabies"]
    
    var selectedVaccineIndex : [String] = []
    
    var selectedVaccineList : [String] = []
    var isCat = true
    var selectedID:UUID = UUID()
    var selectedPet: [Pets] = []
    
    @IBAction func deleteButtonDidTapped(_ sender: Any) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
       
            managedContext.delete(selectedVaccineRecord)
        
        
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
        super.viewDidLoad()
        prepareTableView()
        setupTextView()
        checkSelectedVaccine()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    func checkSelectedVaccine()
    {
        var arrayVaccineType = selectedVaccineRecord.type as? [String]
        if (isCat == true)
        {
            for i in 0...arrayVaccineType!.count - 1
            {
                for j in 0...catVaccineList.count - 1
                {
                    if(arrayVaccineType![i] == catVaccineList[j])
                    {
                        selectedVaccineIndex.append(catVaccineList[j])
                        break
                    }
                    else
                    {
                        
                    }
                }
            }
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

}
extension VaccineDetailViewController: UITableViewDelegate,UITableViewDataSource{
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
        let cell : AddMedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addmedcell", for: indexPath) as! AddMedTableViewCell
            cell.titleLabel.text = vaccineText[indexPath.row]
        if(indexPath.row == 0)
        {
                
                cell.inputTextField.placeholder = "Input Vaccine Name"
                cell.inputTextField.isEnabled = false
            cell.inputTextField.text = selectedVaccineRecord.name
            
        }
        else if(indexPath.row == 1)
        {
            cell.inputTextField.isEnabled = false
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let conditionDate = formatter.string(from: selectedVaccineRecord.date!)
            cell.inputTextField.text = conditionDate
                
        }
        else if(indexPath.row == 2)
        {
           
                cell.inputTextField.placeholder = "Input Vet"
            cell.inputTextField.text = selectedVaccineRecord.vet
            cell.inputTextField.isEnabled = false
          
        }
        else if(indexPath.row == 3)
        {
                cell.inputTextField.placeholder = "Input Doctor Name"
            cell.inputTextField.text = selectedVaccineRecord.doctor
            cell.inputTextField.isEnabled = false
          
        }
        else if(indexPath.row == 4)
        {
            cell.inputTextField.placeholder = "Optional"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let conditionDate = formatter.string(from: selectedVaccineRecord.nextvisit!)
            cell.inputTextField.text = conditionDate
            cell.inputTextField.isEnabled = false
            
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
                for i in 0...selectedVaccineIndex.count - 1
                {
                    if(catVaccineList[indexPath.row] == selectedVaccineIndex[i])
                    {
                        cell.radioButton.isSelected = true
                    }
                }
                cell.isUserInteractionEnabled = false
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
