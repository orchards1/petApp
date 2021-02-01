//
//  AddCalendarViewController.swift
//  petApp
//
//  Created by Michael Louis on 27/01/21.
//

import UIKit
import CoreData

class AddCalendarViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let index2 = IndexPath(row: 0, section: 4)
        let category: AddPetTableViewCell = self.tableView.cellForRow(at: index2) as! AddPetTableViewCell
        category.valueLabel.text = categoryPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerData[row]
    }
    
    var Pets: [Pets] = []
    var arrayImages: [UIImage] = []
    var selectedID: UUID = UUID()
    var placeholders = ["Activity Title","Choose Date","Activity Location","Doctor's Name","Choose Category"]
    var selectedPet: [Pets] = []
    var selectedIndex = 0
    var datePicker2 = UIDatePicker()
    var categoryPicker = UIPickerView()
    var categoryPickerData: [String] = []
    
    var isTitleEmpty = true
    var isDateEmpty = true
    var isDoctorEmpty = true
    var isLocationEmpty = true
    var isCategoryEmpty = true
    var belumpilih = true
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addButtonDidTapped(_ sender: Any) {
        let index1 = IndexPath(row: 0, section: 0)
        let title: AddPetTableViewCell = self.tableView.cellForRow(at: index1) as! AddPetTableViewCell
        
        let index2 = IndexPath(row: 0, section: 1)
        let date: AddPetTableViewCell = self.tableView.cellForRow(at: index2) as! AddPetTableViewCell
        
        let index3 = IndexPath(row:0 ,section: 2)
        let location: AddPetTableViewCell = self.tableView.cellForRow(at: index3) as! AddPetTableViewCell
        
        let index4 = IndexPath(row: 0, section: 3)
        let doctor: AddPetTableViewCell = self.tableView.cellForRow(at: index4) as! AddPetTableViewCell
        
        let index5 = IndexPath(row: 0, section: 4)
        let category: AddPetTableViewCell = self.tableView.cellForRow(at: index5) as! AddPetTableViewCell
        
        if(title.valueLabel.text != nil)
        {
            isTitleEmpty = false
        }
        
        if(location.valueLabel.text != nil)
        {
            isLocationEmpty = false
        }
        
        if(doctor.valueLabel.text != nil)
        {
            isDoctorEmpty = false
        }
        if(date.valueLabel.text != nil)
        {
            isDateEmpty = false
        }
        
        if(category.valueLabel.text != "")
        {
            isCategoryEmpty = false
        }
        
        
        if(isTitleEmpty || isCategoryEmpty || isDoctorEmpty || isDateEmpty || isLocationEmpty || belumpilih)
        {
            let alert = UIAlertController(title: "Data incomplete", message: "Please input all the field", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            saveActivities(title: title.valueLabel.text!, location: location.valueLabel.text!, doctor: doctor.valueLabel.text!, date: datePicker2.date, category: category.valueLabel.text!)
            let alert = UIAlertController(title: "Data saved!", message: "Data has been saved successfully", preferredStyle: UIAlertController.Style.alert)
            let vc = presentingViewController.self
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
              
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismiss"), object: nil)
                vc!.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func saveActivities(title: String,location: String,doctor: String, date: Date, category: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Activities",
                                       in: managedContext)!
        
        let activity = Activities(entity: entity, insertInto: managedContext)
        
        activity.ofPets = selectedPet.first
        activity.setValue(title, forKey: "title")
        activity.setValue(date, forKey: "date")
        activity.setValue(doctor, forKey: "doctor")
        activity.setValue(location, forKey: "location")
        activity.setValue(category, forKey: "category")
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCollectionView()
        fetchPets()
        setupPicker()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    func imagesFromCoreData(object: Data?) -> [UIImage]? {
        var retVal = [UIImage]()
        
        guard let object = object else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        
        return retVal
    }
    func fetchPets(){
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    let fetchRequest =
        NSFetchRequest<Pets>(entityName: "Pets")
    //3
    do {
        self.Pets = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
}
    func setupPicker(){
        categoryPickerData = ["Medical", "Vaccine", "Other"]
        categoryPicker = UIPickerView()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellcategoryPicker")
    }
    func setupCollectionView(){
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
}
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    @objc func nextdatedonePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
            let index4 = IndexPath(row: 0, section: 1)
        let date: AddPetTableViewCell = tableView.cellForRow(at: index4) as! AddPetTableViewCell
        date.valueLabel.text = formatter.string(from: datePicker2.date)
        
        self.view.endEditing(true)
        
    }
    @objc func donePicker() {
        
        self.view.endEditing(true)
        
    }
}
extension AddCalendarViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pets.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 20
       }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AddCalendarCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "choosepetcell", for: indexPath) as! AddCalendarCollectionViewCell
        let pet = Pets[indexPath.row]
        if(pet.value(forKey: "petImage") as? Data != nil)
        {
            if(imagesFromCoreData(object: pet.value(forKey: "petImage") as! Data)!.count > 0)
            {
                cell.petImage.image =  imagesFromCoreData(object: pet.value(forKey: "petImage") as? Data)![0]
            }
        }
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action:#selector(btnPressed(sender:)), for: .touchUpInside)
        cell.petNameLabel.text = pet.petName
        if(indexPath.row == selectedIndex && belumpilih == false)
        {
            cell.borderImage.image = #imageLiteral(resourceName: "border")
            cell.petNameLabel.textColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
            cell.button.isSelected = true
        }
        else
        {
            cell.borderImage.image = #imageLiteral(resourceName: "whiteborder")
            cell.petNameLabel.textColor = .lightGray
            cell.button.isSelected = false
        }
        return cell
    }
    
    @objc func btnPressed(sender: UIButton)
    {
        belumpilih = false
        selectedIndex = sender.tag
        selectedPet.removeAll()
        selectedPet.append(Pets[sender.tag])
        collectionView.reloadData()
    }
}

extension AddCalendarViewController: UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return placeholders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddPetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addpetcell", for: indexPath) as! AddPetTableViewCell
        cell.valueLabel.placeholder = placeholders[indexPath.section]
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        doneButton.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        cancelButton.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
        if(indexPath.section == 0)
        {
            
        }
        else if(indexPath.section == 1)
        {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let nextdatedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(nextdatedonePicker));
            nextdatedoneButton.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
            toolbar.setItems([cancelButton,spaceButton,nextdatedoneButton], animated: false)
            
            cell.tintColor = .clear
            cell.accessoryType = .disclosureIndicator
            cell.valueLabel.inputView = datePicker2
            cell.valueLabel.inputAccessoryView = toolbar
            datePicker2.date = Date()
            cell.valueLabel.placeholder = "Choose Date"
            
            if #available(iOS 13.4, *) {
                datePicker2.preferredDatePickerStyle = .wheels
                datePicker2.datePickerMode = .date
                datePicker2.minimumDate = Date()
            } else {
                // Fallback on earlier versions
            }
        }
        else if(indexPath.section == 2)
        {
            
        }
        else if(indexPath.section == 3)
        {
        }
        else if(indexPath.section == 4)
        {
                
                toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
                cell.accessoryType = .disclosureIndicator
                cell.valueLabel.tintColor = .clear
                cell.valueLabel.inputView = categoryPicker
                cell.valueLabel.inputAccessoryView = toolbar
        }
        heightConstraint.constant = tableView.contentSize.height
        return cell
    }
    
    
}
