//
//  PetDetailsViewController.swift
//  petApp
//
//  Created by Michael Louis on 09/01/21.
//

import UIKit
import CoreData

class PetDetailsViewController: UIViewController {
    
    var selectedID : UUID = UUID()
    var text = ""
    var selectedPet: [NSManagedObject] = []
    var images : [UIImage] = []
    var currPage = 0
    var sections = [[String]]()
    
    @IBAction func editButtonDidTapped(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEdit")
        {
            if let destinationViewController = segue.destination as? EditViewController {
                destinationViewController.selectedID = selectedID
                }
        }
    }
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch(with: selectedID)
        self.title = selectedPet.first?.value(forKey: "petName") as! String
        setUpTableView()
        setUpCollectionView()
        
    }
    func setUpTableView()
    {
        let section1 = ["Date of birth","Age","Animal","Breed","Color"]
        let section2 = ["ID No.", "Born name" , "Breeder", "Address"]
        let section3 = ["Medical Condition"]
            sections.append(section1)
            sections.append(section2)
            sections.append(section3)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func setUpCollectionView()
    {
        pageController.numberOfPages = (imagesFromCoreData(object: selectedPet.first!.value(forKey: "petImage") as? Data)?.count)!
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        let age = calendar.components([.year, .month,.day], from: birthdate, to: now, options: [])
        var yeartext = ""
        var monthtext = ""
        var daytext = ""
        let year = age.year!
        let month = age.month!
        let day = age.day!
        var isYearExist = false
        var isMonthExist = false
        var isDayExist = false
        
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
        
        if(day > 1)
        {
            daytext = " Days"
        }
        else
        {
            daytext = " Day"
        }
        
        if(month != 0)
        {isMonthExist = true}
        
        if(year != 0)
        {isYearExist = true}
        
        if(day != 0)
        {isDayExist = true}
        
        if(isYearExist && isMonthExist && isDayExist)
        {
            return String(year) + yeartext + String(month) + monthtext + String(day) + daytext
        }
        else if(isYearExist && isDayExist)
        {
            return String(year) + yeartext + String(day) + daytext
        }
        else if(isYearExist && isMonthExist)
        {
            return String(year) + yeartext + String(month) + monthtext
        }
        else if(isMonthExist && isDayExist)
        {
            return String(month) + monthtext + String(day) + daytext
        }
        else if(isYearExist && isDayExist)
        {
            return String(year) + yeartext + String(day) + daytext
        }
        else if(isYearExist)
        {
            return String(year) + yeartext
        }
        else if(isMonthExist)
        {
            return String(month) + monthtext
        }
        else
        {
            if(day == 0)
            {
                return "Born today"
            }
            else
            {
            return String(day) + daytext
            }
        }
        
    }
    func fetch(with identifier: UUID) {
        let appDelegate =
                UIApplication.shared.delegate as? AppDelegate
        
        let managedContext =
            appDelegate!.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pets")
            fetchRequest.predicate = NSPredicate(format: "petID == %@", identifier as CVarArg)
            fetchRequest.fetchLimit = 1
        do {
            selectedPet = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
extension PetDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = (imagesFromCoreData(object: selectedPet.first!.value(forKey: "petImage") as? Data)?.count)!
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = imagesFromCoreData(object: selectedPet.first!.value(forKey: "petImage") as? Data)?[indexPath.row]
        tableViewHeightConstraint.constant = tableView.contentSize.height
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width
                      , height: collectionView.frame.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currPage = Int(scrollView.contentOffset.x / collectionView.frame.width)
        pageController.currentPage = currPage
    }
    
}

extension PetDetailsViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailscell", for: indexPath) as! DetailsTableViewCell
        cell.leftLabel.text = sections[indexPath.section][indexPath.row]
        //DOB
        if(indexPath == IndexPath(row: 0, section: 0))
        {
            var DOB = selectedPet.first?.value(forKey: "petDOB") as? Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            var DobString = formatter.string(from: DOB!)
            print(DobString)
            cell.rightLabel.text = DobString
        }
        else if(indexPath == IndexPath(row: 1, section: 0))
        {
            var DOB = selectedPet.first?.value(forKey: "petDOB") as? Date
            cell.rightLabel.text = calcAge(birthdate: DOB!)
        }
        else if(indexPath == IndexPath(row: 2, section: 0))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petType") as? String
        }
        else if(indexPath == IndexPath(row:3, section: 0))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petBreed") as? String
        }
        else if(indexPath == IndexPath(row:4, section: 0))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petColor") as? String
        }
        else if(indexPath == IndexPath(row:0, section: 1))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petRegistrationID") as? String
        }
        else if(indexPath == IndexPath(row:1, section: 1))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petBornName") as? String
        }
        else if(indexPath == IndexPath(row:2, section: 1))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petBreeder") as? String
        }
        else if(indexPath == IndexPath(row:3, section: 1))
        {
            cell.rightLabel.text = selectedPet.first?.value(forKey: "petAddress") as? String
        }
        else if(indexPath == IndexPath(row:0, section: 2))
        {
            cell.accessoryType = .disclosureIndicator
            cell.rightLabel.text = ""
            cell.selectionStyle = .default
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
