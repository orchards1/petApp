//
//  HomeTableViewController.swift
//  petApp
//
//  Created by Michael Louis on 24/12/20.
//

import UIKit
import CoreData


class HomeTableViewController: UITableViewController {
    
    var Pets: [NSManagedObject] = []
    var arrayImages: [UIImage] = []
    var selectedID: UUID = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func reloadTableView(){
        fetchPets()
        self.tableView.reloadData()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPets()
        
        
    }
    
    
    //    func fetchImage() -> [UIImage]
    //    {
    //    var fetchingImage = [UIImage]()
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pets")
    //    do {
    //    fetchingImage = try context.fetch(fetchRequest) as! [UIImage]
    //    } catch {
    //    print("Error while fetching the image")
    //    }
    //    return fetchingImage
    //    }
    
    
    func fetchPets()
    {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Pets")
        //3
        do {
            Pets = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //    func saveImage()
    //    {
    //        let data = (profileimg?.image)!.pngData()
    //        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    //        let petImage = NSEntityDescription.insertNewObject(forEntityName: "Pet", into: context!)
    //        petImage.setValue(data, forKey: "petImage")
    //
    //        do {
    //            try context?.save()
    //        }
    //    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(Pets.count == 0)
        {
            tableView.setEmptyView(title: "You don't have any pets.", message: "Add your pets from the add button.")
            return 0
            
        }
        else
        {
            
            tableView.setEmptyView(title: "", message: "")
            return Pets.count
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
            monthtext = " Months "
        }
        else
        {
            monthtext = " Month "
        }
        return String(year) + yeartext + String(month) + monthtext
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        let pet = Pets[indexPath.row]
        cell.nameLabel.text = pet.value(forKeyPath: "petName") as? String
        cell.ageLabel.text = calcAge(birthdate: pet.value(forKey: "petDOB") as! Date)
        
        if(pet.value(forKey: "petImage") as? Data != nil)
        {
            if(imagesFromCoreData(object: pet.value(forKey: "petImage") as! Data)!.count > 0)
            {
                cell.petImage.image =  imagesFromCoreData(object: pet.value(forKey: "petImage") as? Data)![0]
            }
        }
        
        if(pet.value(forKey: "petSex") as! String == "Male")
        {
            cell.petSexSymbol.image = #imageLiteral(resourceName: "maleIcon")
        }
        else
        {
            cell.petSexSymbol.image = #imageLiteral(resourceName: "femaleIcon")
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedId = Pets[indexPath.row].value(forKey: "PetID")
        
        selectedID = selectedId as! UUID
        performSegue(withIdentifier: "toDetail", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"
        {
            if let destinationViewController = segue.destination as? PetDetailsViewController {
                destinationViewController.selectedID = selectedID
                destinationViewController.text = "Hohoho"
                }
        }
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
