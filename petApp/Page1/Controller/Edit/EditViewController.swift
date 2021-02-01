//
//  EditViewController.swift
//  petApp
//
//  Created by Michael Louis on 12/01/21.
//

import UIKit
import CoreData
class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var selectedID : UUID = UUID()
    var selectedPet: [Pets] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet var tableViewHeightConstraint2: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var sections = [[String]]()
    var animalPickerData: [String] = [String]()
    var sexPickerData: [String] = [String]()
    var animalPicker: UIPickerView!
    var sexPicker: UIPickerView!
    var datePicker = UIDatePicker()
    var imagePicker = UIImagePickerController()
    var images: [UIImage] = [UIImage]()
    let section1 = ["Name","Animal","Sex" , "Date of birth" , "Breed" , "Color"]
    let section2 = ["ID No.", "Born name" , "Breeder", "Address"]
    
    var isNameEmpty = false
    var isTypeEmpty = false
    var isSexEmpty = false
    var isColorEmpty = false
    var isReplacing = false
    var selectedPhotoIndex = 0
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if(isReplacing == false)
        {
        if let pickedImage = info[.editedImage] as? UIImage {
            images.append(pickedImage)
            displayImage()
           }
        }
        else
        {
            if let pickedImage = info[.editedImage] as? UIImage {
                images[selectedPhotoIndex] = pickedImage
                displayImage()
               }
        }
        
        picker.dismiss(animated: true, completion: nil)
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
        
    }
    func displayImage()
    {
        for i in 0...5
        {
            let index = IndexPath(row: i, section: 0)
            let cellImage: AddImageCollectionViewCell = collectionView.cellForItem(at: index) as! AddImageCollectionViewCell
            cellImage.addButton.setImage(#imageLiteral(resourceName: "􀅼 (1)"), for: .normal)
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
            cellImage.addButton.setImage(nil, for: .normal)
            
        }
        }
        
    }
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
            imagePicker.delegate = self
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        fetch(with: selectedID)
        images = imagesFromCoreData(object: selectedPet.first?.value(forKey: "petImage")as? Data)!
        
        setupTableView()
        setUpPicker()
       
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
            let index2 = IndexPath(row: 0, section: 1)
            let type: AddPetTableViewCell = self.tableView1.cellForRow(at: index2) as! AddPetTableViewCell
            type.valueLabel.text = animalPickerData[row]
            
        }
        else
        {
            let index2b = IndexPath(row: 0, section: 2)
            let sex: AddPetTableViewCell = self.tableView1.cellForRow(at: index2b) as! AddPetTableViewCell
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
        let index3 = IndexPath(row: 0, section: 3)
        let date: AddPetTableViewCell = self.tableView1.cellForRow(at: index3) as! AddPetTableViewCell
        print(datePicker.date)
        date.valueLabel.text = formatter.string(from: datePicker.date)
 
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
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func addPhoto(sender : UIButton)
    {
        
        if(images.count == 0)
        {
            self.isReplacing = false
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.openCamera()
                }))

                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                    self.openGallery()
                }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))

                self.present(alert, animated: true, completion: nil)
        }
        else if(sender.tag > images.count - 1)
        {
            self.isReplacing = false
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                        self.openCamera()
                    }))

                    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                        self.openGallery()
                    }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))

                    self.present(alert, animated: true, completion: nil)
        }
        else
        {
            selectedPhotoIndex = sender.tag
            let alert = UIAlertController(title: "Change Image", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                        self.isReplacing = true
                        self.openCamera()
                    }))

                    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                        self.isReplacing = true
                        
                        self.openGallery()
                    }))
            alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { _ in
                self.delPhoto(sender: sender)
            }))

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))

                    self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupTableView()
    {   let section1 = ["Name","Animal","Sex"]
        let section2 = ["Date of birth" , "Age" , "Breed" , "Color"]
        let section3 = ["ID No.", "Born name" , "Breeder", "Address"]
     
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView1.dataSource = self
        tableView1.delegate = self
        
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView2.dataSource = self
        tableView2.delegate = self
    }
    
    func save(name: String,bornName: String, type: String ,date: Date, breeder: String, sex: String, color: String, breed: String, regisId: String, address: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pets")
        
        fetchRequest.predicate = NSPredicate(format: "petID == %@", selectedID as CVarArg)

        do {
            let pet = try context.fetch(fetchRequest) as? [Pets]
            if pet?.count != 0 { // Atleast one was returned

                // In my case, I only updated the first item in results
                pet?.first!.setValue(name, forKeyPath: "petName")
                pet?.first!.setValue(bornName, forKey: "petBornName")
                pet?.first!.setValue(type, forKey: "petType")
                pet?.first!.setValue(breed, forKey: "petBreed")
                pet?.first!.setValue(color, forKey: "petColor")
                pet?.first!.setValue(breeder, forKey: "petBreeder")
                pet?.first!.setValue(date, forKey: "petDOB")
                pet?.first!.setValue(selectedID, forKey: "petID")
                pet?.first!.setValue(sex, forKey: "petSex")
                pet?.first!.setValue(regisId, forKey: "petRegistrationID")
                pet?.first!.setValue(address, forKey: "petAddress")
                
                if(images.count == 0)
                {
                    var imageArray: [UIImage] = [UIImage]()
                    imageArray.append(#imageLiteral(resourceName: "Rectangle 2"))
                    pet?.first!.setValue(coreDataObjectFromImages(images: imageArray), forKey: "petImage")
                }
                else
                {
                pet?.first!.setValue(coreDataObjectFromImages(images: images), forKey: "petImage")
                }
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try context.save()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
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
        let name: AddPetTableViewCell = self.tableView1.cellForRow(at: index1) as! AddPetTableViewCell
        
        let index2 = IndexPath(row: 0, section: 1)
        let type: AddPetTableViewCell = self.tableView1.cellForRow(at: index2) as! AddPetTableViewCell
        
        let index2b = IndexPath(row:0 ,section: 2)
        let sex: AddPetTableViewCell = self.tableView1.cellForRow(at: index2b) as! AddPetTableViewCell
        
        let index3 = IndexPath(row: 0, section: 3)
        let date: AddPetTableViewCell = self.tableView1.cellForRow(at: index3) as! AddPetTableViewCell
        
        let index4 = IndexPath(row: 0, section: 4)
        let breed: AddPetTableViewCell = self.tableView1.cellForRow(at: index4) as! AddPetTableViewCell
        
        let index5 = IndexPath(row: 0, section: 5)
        let color: AddPetTableViewCell = self.tableView1.cellForRow(at: index5) as! AddPetTableViewCell
        
        let index6 = IndexPath(row: 0, section: 0)
        let regisId: AddPetTableViewCell = self.tableView2.cellForRow(at: index6) as! AddPetTableViewCell

        let index7 = IndexPath(row: 0, section: 1)
        let bornName: AddPetTableViewCell = self.tableView2.cellForRow(at: index7) as! AddPetTableViewCell

        let index8 = IndexPath(row: 0, section: 2)
        let breeder: AddPetTableViewCell = self.tableView2.cellForRow(at: index8) as! AddPetTableViewCell

        let index9 = IndexPath(row: 0, section: 3)
        let address: AddPetTableViewCell = self.tableView2.cellForRow(at: index9) as! AddPetTableViewCell
        
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

extension EditViewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : AddImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "editimagecell", for: indexPath) as! AddImageCollectionViewCell
        if(images.count > indexPath.row)
        {
        cell.imageView.image = images[indexPath.row]
            cell.addButton.setImage(nil, for: .normal)
        }
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self,
                                    action: #selector(self.addPhoto(sender:)),
                                    for: .touchUpInside)
    
        return cell
    }
    
    
}
extension EditViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
         return 1
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableView1)
        {
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
            let datedoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datedonePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
            
            
            let section = indexPath.section
            let cell : AddPetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addcell", for: indexPath) as! AddPetTableViewCell
            
            if(indexPath.section
             == 0)
            {
                cell.valueLabel.placeholder = "Pet's Name"
                cell.valueLabel.text = selectedPet.first?.petName
            }
            else if(indexPath.section == 1) //Pick animal
            {
                toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
                cell.accessoryType = .disclosureIndicator
                cell.valueLabel.tintColor = .clear
                cell.valueLabel.inputView = animalPicker
                cell.valueLabel.inputAccessoryView = toolbar
                cell.valueLabel.placeholder = "Choose Animal Type"
                cell.valueLabel.text = selectedPet.first?.petType
            }
            else if(indexPath.section == 2) //Pick sex
            {
                toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
                cell.accessoryType = .disclosureIndicator
                cell.valueLabel.tintColor = .clear
                cell.valueLabel.inputView = sexPicker
                cell.valueLabel.inputAccessoryView = toolbar
                cell.valueLabel.placeholder = "Pet's Gender"
                cell.valueLabel.text = selectedPet.first?.petSex
                
            }
            else if(indexPath.section == 3)
            {
                toolbar.setItems([cancelButton,spaceButton,datedoneButton], animated: false)
                cell.valueLabel.tintColor = .clear
                cell.valueLabel.inputView = datePicker
                cell.valueLabel.inputAccessoryView = toolbar
                cell.valueLabel.placeholder = "Select date"
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let conditionDate = formatter.string(from: (selectedPet.first?.petDOB)!)
                cell.valueLabel.text = conditionDate
                
                if #available(iOS 13.4, *) {
                    datePicker.preferredDatePickerStyle = .wheels
                    datePicker.datePickerMode = .date
                    datePicker.date = (selectedPet.first?.petDOB)!
                    datePicker.maximumDate = Date()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            else if(indexPath.section == 4)
            {
                cell.valueLabel.placeholder = "Pet's Breed"
                cell.valueLabel.text = selectedPet.first?.petBreed
            }
            else if(indexPath.section == 5)
            {
                cell.valueLabel.placeholder = "Pet's Color"
                cell.valueLabel.text = selectedPet.first?.petColor
            }
            tableViewHeightConstraint.constant = tableView1.contentSize.height
            return cell
        }
        else
        {
            let section = indexPath.section
            let cell : AddPetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addcell", for: indexPath) as! AddPetTableViewCell
            
            if(indexPath.section
             == 0)
            {
                cell.valueLabel.placeholder = "Pet's ID Number"
                cell.valueLabel.text = selectedPet.first?.petRegistrationID
            }
            else if(indexPath.section == 1) //Pick animal
            {
                cell.valueLabel.placeholder = "Pet’s Born Name"
                cell.valueLabel.text = selectedPet.first?.petBornName
            }
            else if(indexPath.section == 2) //Pick sex
            {
                cell.valueLabel.placeholder = "Breeder's Name"
                cell.valueLabel.text = selectedPet.first?.petBreeder
            }
            else if(indexPath.section == 3)
            {
                cell.valueLabel.placeholder = "Breeder's Address"
                cell.valueLabel.text = selectedPet.first?.petAddress
            }
            tableViewHeightConstraint2.constant = tableView2.contentSize.height
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == tableView1)
        {
        return section1.count
        }
        else
        {return section2.count}
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let section = indexPath?.section
        
    }
}
