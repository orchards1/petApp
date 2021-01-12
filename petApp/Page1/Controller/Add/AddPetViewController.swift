//
//  AddPetViewController.swift
//  petApp
//
//  Created by Michael Louis on 24/12/20.
//

import UIKit
import CoreData

class AddPetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var sections = [[String]]()
    var animalPickerData: [String] = [String]()
    var sexPickerData: [String] = [String]()
    var animalPicker: UIPickerView!
    var sexPicker: UIPickerView!
    var datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    var images: [UIImage] = [UIImage]()
    
    var isNameEmpty = false
    var isTypeEmpty = false
    var isSexEmpty = false
    var isColorEmpty = false
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            //            let index = IndexPath(row: currPic, section: 0)
            //            let cellImage: AddImageCollectionViewCell = self.collectionView.cellForItem(at: index) as! AddImageCollectionViewCell
            //
            images.append(pickedImage)
            displayImage()
        }
        //
        
        self.dismiss(animated: true, completion: nil)
    }
    func displayImage()
    {
        
        for i in 0...5
        {
            let index = IndexPath(row: i, section: 0)
            let cellImage: AddImageCollectionViewCell = self.collectionView.cellForItem(at: index) as! AddImageCollectionViewCell
            cellImage.deleteButton.isHidden = true
            cellImage.addButton.isHidden = false
            cellImage.imageView.image = nil
        }
        if(images.count != 0)
        {
        for i in 0...images.count-1
        {
            let index = IndexPath(row: i, section: 0)
            let cellImage: AddImageCollectionViewCell = self.collectionView.cellForItem(at: index) as! AddImageCollectionViewCell
            
            cellImage.imageView.image = images[i]
            cellImage.imageView.contentMode = .scaleAspectFit
            cellImage.addButton.isHidden = true
            cellImage.deleteButton.isHidden = false
        }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        images.removeAll()
        setupTableView()
        setUpPicker()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(addPhoto), name: NSNotification.Name(rawValue: "addPhoto"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func delPhoto(sender : UIButton){
        images.remove(at: sender.tag)
        displayImage()
    }
    
    @objc func addPhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    
    func setUpPicker()
    {
        animalPickerData = ["Cat", "Dog", "Hamster", "Bird"]
        animalPicker = UIPickerView()
        
        animalPicker.dataSource = self
        animalPicker.delegate = self
        
        
        sexPickerData = ["Male", "Female"]
        sexPicker = UIPickerView()
        
        sexPicker.dataSource = self
        sexPicker.delegate = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == animalPicker)
        {
            return animalPickerData.count
        }
        else
        {
            
            return sexPickerData.count
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == animalPicker)
        {
            return animalPickerData[row]
        }
        else
        {
            return sexPickerData[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView == animalPicker)
        {
            let index2 = IndexPath(row: 1, section: 0)
            let type: AddPetTableViewCell = self.tableView.cellForRow(at: index2) as! AddPetTableViewCell
            type.valueLabel.text = animalPickerData[row]
            
        }
        else
        {
            let index2b = IndexPath(row: 2, section: 0)
            let sex: AddPetTableViewCell = self.tableView.cellForRow(at: index2b) as! AddPetTableViewCell
            sex.valueLabel.text = sexPickerData[row]
            sex.valueLabel.placeholder = "Choose"
        }
    }
    
    @objc func donePicker() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func datedonePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let index3 = IndexPath(row: 0, section: 1)
        let date: AddPetTableViewCell = self.tableView.cellForRow(at: index3) as! AddPetTableViewCell
        print(datePicker.date)
        date.valueLabel.text = formatter.string(from: datePicker.date)
        
        let index4 = IndexPath(row: 1, section: 1)
        let age: AddPetTableViewCell = self.tableView.cellForRow(at: index4) as! AddPetTableViewCell
        
        age.valueLabel.text = calcAge(birthdate: datePicker.date)
        self.view.endEditing(true)
        
    }
    func calcAge(birthdate: Date) -> String {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let age = calendar.components([.year, .month], from: birthdate, to: now, options: [])
        var yeartext = ""
        var monthtext = ""
        let year = age.year!
        let month = age.month!
        
        if(year > 1)
        {
            yeartext = " Years "
        }
        else
        {
            yeartext = " Year "
        }
        
        if(month > 1)
        {
            monthtext = " Months"
        }
        else
        {
            monthtext = " Month"
        }
        return String(year) + yeartext + String(month) + monthtext
    }
    
    
    func setupTableView()
    {   let section1 = ["Name","Animal","Sex"]
        let section2 = ["Date of birth" , "Age" , "Breed" , "Color"]
        let section3 = ["ID No.", "Born name" , "Breeder", "Address"]
        
        sections.append(section1)
        sections.append(section2)
        sections.append(section3)
    }
    
    func save(name: String,bornName: String, type: String ,date: Date, breeder: String, sex: String, color: String, breed: String, regisId: String, address: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Pets",
                                       in: managedContext)!
        
        let pet = NSManagedObject(entity: entity,
                                  insertInto: managedContext)
        
        // 3
        pet.setValue(name, forKeyPath: "petName")
        pet.setValue(bornName, forKey: "petBornName")
        pet.setValue(type, forKey: "petType")
        pet.setValue(breed, forKey: "petBreed")
        pet.setValue(color, forKey: "petColor")
        pet.setValue(breeder, forKey: "petBreeder")
        pet.setValue(date, forKey: "petDOB")
        let uuid = UUID()
        pet.setValue(uuid, forKey: "petID")
        pet.setValue(sex, forKey: "petSex")
        pet.setValue(regisId, forKey: "petRegistrationID")
        pet.setValue(address, forKey: "petAddress")
        
        if(images.count == 0)
        {
            var imageArray: [UIImage] = [UIImage]()
            imageArray.append(#imageLiteral(resourceName: "Rectangle 2"))
            pet.setValue(coreDataObjectFromImages(images: imageArray), forKey: "petImage")
        }
        else
        {
        pet.setValue(coreDataObjectFromImages(images: images), forKey: "petImage")
        }
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
        for img in images {
            if let data = img.pngData() {
                dataArray.add(data)
            }
        }
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
        catch
        {
            print ("There was an error")
        }
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        
        var success = false
        
        let index1 = IndexPath(row: 0, section: 0)
        let name: AddPetTableViewCell = self.tableView.cellForRow(at: index1) as! AddPetTableViewCell
        
        let index2 = IndexPath(row: 1, section: 0)
        let type: AddPetTableViewCell = self.tableView.cellForRow(at: index2) as! AddPetTableViewCell
        
        let index2b = IndexPath(row:2 ,section: 0)
        let sex: AddPetTableViewCell = self.tableView.cellForRow(at: index2b) as! AddPetTableViewCell
        
        let index3 = IndexPath(row: 0, section: 1)
        let date: AddPetTableViewCell = self.tableView.cellForRow(at: index3) as! AddPetTableViewCell
        
        let index4 = IndexPath(row: 2, section: 1)
        let breed: AddPetTableViewCell = self.tableView.cellForRow(at: index4) as! AddPetTableViewCell
        
        let index5 = IndexPath(row: 3, section: 1)
        let color: AddPetTableViewCell = self.tableView.cellForRow(at: index5) as! AddPetTableViewCell
        
        let index6 = IndexPath(row: 0, section: 2)
        let regisId: AddPetTableViewCell = self.tableView.cellForRow(at: index6) as! AddPetTableViewCell
        
        let index7 = IndexPath(row: 1, section: 2)
        let bornName: AddPetTableViewCell = self.tableView.cellForRow(at: index7) as! AddPetTableViewCell
        
        let index8 = IndexPath(row: 2, section: 2)
        let breeder: AddPetTableViewCell = self.tableView.cellForRow(at: index8) as! AddPetTableViewCell
        
        let index9 = IndexPath(row: 3, section: 2)
        let address: AddPetTableViewCell = self.tableView.cellForRow(at: index9) as! AddPetTableViewCell
        
        //Validation
        if(name.valueLabel.text == "")
        {
            isNameEmpty = true
        }
        else
        {
            isNameEmpty = false
        }
        
        if(type.valueLabel.text == "")
        {
            isTypeEmpty = true
        }
        else
        {
            isTypeEmpty = false
        }
        if(sex.valueLabel.text == "")
        {
            isSexEmpty = true
        }
        else
        {
            isSexEmpty = false
        }
        
        if(color.valueLabel.text == "")
        {
            isColorEmpty = true
        }
        else
        {
            isColorEmpty = false
        }
    
        if(isNameEmpty)
        {
            // create the alert
                    let alert = UIAlertController(title: "Data incomplete", message: "Please input the pet's name", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
        }
        else if (isTypeEmpty)
        {
            // create the alert
                    let alert = UIAlertController(title: "Data incomplete", message: "Please input the pet's animal type", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
        }
        else if (isSexEmpty)
        {
            // create the alert
                    let alert = UIAlertController(title: "Data incomplete", message: "Please input the pet's sex", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
        }
        else if(isColorEmpty == true)
        {
            // create the alert
                    let alert = UIAlertController(title: "Data incomplete", message: "Please input the pet's color", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
        }
        else
        {
                
            save(name: name.valueLabel.text!,bornName: bornName.valueLabel.text!, type: type.valueLabel.text!, date: datePicker.date, breeder: breeder.valueLabel.text!, sex: sex.valueLabel.text!, color: color.valueLabel.text!, breed: breed.valueLabel.text!, regisId: regisId.valueLabel.text! , address: address.valueLabel.text!)
                
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
extension AddPetViewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : AddImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addimagecell", for: indexPath) as! AddImageCollectionViewCell
        cell.deleteButton.isHidden = true
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self,
                                    action: #selector(self.delPhoto(sender: )),
                                    for: .touchUpInside)
        tableViewHeightConstraint.constant = tableView.contentSize.height
        return cell
    }
    
    
}
extension AddPetViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        let datedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datedonePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        
        
        let section = indexPath.section
        let cell : AddPetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addcell", for: indexPath) as! AddPetTableViewCell
        cell.leftLabel.text = sections[section][indexPath.row]
        if(indexPath == IndexPath(row: 1, section: 0)) //Pick animal
        {
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            cell.accessoryType = .disclosureIndicator
            cell.valueLabel.tintColor = .clear
            cell.valueLabel.inputView = animalPicker
            cell.valueLabel.inputAccessoryView = toolbar
            cell.valueLabel.placeholder = "Choose"
        }
        else if(indexPath == IndexPath(row: 2, section: 0)) //Pick sex
        {
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            cell.accessoryType = .disclosureIndicator
            cell.valueLabel.tintColor = .clear
            cell.valueLabel.inputView = sexPicker
            cell.valueLabel.inputAccessoryView = toolbar
            cell.valueLabel.placeholder = "Choose"
            
            
        }
        else if(indexPath == IndexPath(row: 0,section: 1))
        {
            toolbar.setItems([cancelButton,spaceButton,datedoneButton], animated: false)
            cell.valueLabel.tintColor = .clear
            cell.valueLabel.inputView = datePicker
            cell.valueLabel.inputAccessoryView = toolbar
            cell.valueLabel.placeholder = "Select date"
        
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.datePickerMode = .date
                datePicker.maximumDate = Date()
            } else {
                // Fallback on earlier versions
            }
            
        }
        else if(indexPath == IndexPath(row: 1, section: 1))
        {
            cell.valueLabel.isEnabled = false
            cell.valueLabel.placeholder = ""
            
        }
        else if(indexPath == IndexPath(row:2, section: 1))
        {
            cell.valueLabel.placeholder = "Pet's breed"
        }
        else if(indexPath == IndexPath(row: 0, section: 0))
        {
            cell.valueLabel.placeholder = "Pet's name"
        }
        else
        {
            cell.valueLabel.placeholder = "Optional"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let section = indexPath?.section
        
    }
}
