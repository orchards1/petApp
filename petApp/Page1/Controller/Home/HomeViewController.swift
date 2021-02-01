//
//  HomeViewController.swift
//  petApp
//
//  Created by Michael Louis on 21/01/21.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var collectioncell: [HomeCollectionViewCell] = []
    var Pets: [Pets] = []
    var Activities: [Activities] = []
    var arrayImages: [UIImage] = []
    var selectedID: UUID = UUID()
    
    var week = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var date:[String] = []
    var currMonth:String = ""
    var todayDate:String = ""
    var thisWeekActivity: [Activities] = []
    var activityDates: [String] = []
    var mondayInWeek:Date = Date()
    var sundayInWeek:Date = Date()
    var collectionviewIndex = 0
    
    @IBOutlet var currentMonthLabel: UILabel!
    @IBOutlet var heightConstraint2: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        collectionView.reloadData()
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        var visibleRect = CGRect()
//
//        visibleRect.origin = tableView1.contentOffset
//        visibleRect.size = tableView1.bounds.size
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        guard let indexPath = tableView1.indexPathForRow(at: visiblePoint)
//        else { return }
//
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//                    generator.impactOccurred()
//
//        tableView1.scrollToRow(at: indexPath, at: .middle, animated: true)
//    }
//    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
       if decelerate == false
       {
           self.centerTable()
       }
     }

     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.centerTable()
    }

    func centerTable()
    {
       let midX:CGFloat = self.tableView1.bounds.midX
       let midY:CGFloat = self.tableView1.bounds.midY
       let midPoint:CGPoint = CGPoint(x: midX, y: midY)

       if let pathForCenterCell:IndexPath = self.tableView1.indexPathForRow(at: midPoint)
        {
          self.tableView1.scrollToRow(at: pathForCenterCell, at: .middle, animated: true)
        }
    }
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        super.viewDidLoad()
        
        date = formattedDaysInThisWeek()
        fetchPets()
        fetchActivities()
        checkthisweekActivity()
        
        currentMonthLabel.text = currMonth
        setupTableView()
        setupCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func setupTableView()
    {
        self.tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        
        self.tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
    }
    func setupCollectionView()
    {
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    @objc func reloadTableView()
    {
        date = formattedDaysInThisWeek()
        fetchPets()
        fetchActivities()
        checkthisweekActivity()
        
        self.collectionView.reloadData()
        
        self.tableView2.reloadData()
        self.tableView1.reloadData()
    }
    
    func checkthisweekActivity()
    {
        thisWeekActivity.removeAll()
        activityDates.removeAll()
        for activity in Activities
        {
            var activitydate = activity.date! as Date
            if(activitydate.isBetween(mondayInWeek, and: sundayInWeek))
            {
                thisWeekActivity.append(activity)
                activityDates.append(formatDate(date: activity.date! as NSDate))
            }
        }
        
    }
    func fetchActivities()
    {
        Activities.removeAll()
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<Activities>(entityName: "Activities")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        //3
        do {
            self.Activities = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    func fetchPets()
    {
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
    func resetAllRecords(in entity : String)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"
        {
            if let destinationViewController = segue.destination as? PetDetailsViewController {
                destinationViewController.selectedID = selectedID
            }
        }
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
            return String(year) + yeartext + String(month) + monthtext
        }
        else if(isYearExist && isDayExist)
        {
            return String(year) + yeartext
        }
        else if(isYearExist && isMonthExist)
        {
            return String(year) + yeartext + String(month) + monthtext
        }
        else if(isMonthExist && isDayExist)
        {
            return String(month) + monthtext
        }
        else if(isYearExist && isDayExist)
        {
            return String(year) + yeartext
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
    func formatDate(date: NSDate) -> String {
        let format = "dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    func formatDay(date: NSDate) -> String {
        let format = "EEEE"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func formattedDaysInThisWeek() -> [String] {
        // create calendar
        let calendar = Calendar(identifier: .gregorian)
        
        // today's date
        var today = Date()
        let format = "dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        var todayDate2 = formatter.string(from: Date())
        todayDate = todayDate2
        //curr Month
        let currMonthformat = "MMMM yyyy"
        let newformatter = DateFormatter()
        newformatter.dateFormat = currMonthformat
        currMonth = newformatter.string(from: Date())
        
        let weekday = calendar.component(.weekday, from: today)
        let beginningOfWeek : Date
        if weekday != 2 { // if today is not Monday, get back
            let weekDateConponent = DateComponents(weekday: 2)
            beginningOfWeek = calendar.nextDate(after: today, matching: weekDateConponent, matchingPolicy: .nextTime, direction: .backward)!
            
        } else { // today is Monday
            beginningOfWeek = calendar.startOfDay(for: today)
        }
        
        var formattedDays = [String]()
        for i in 0..<7 {
            if(i == 0)
            {
                mondayInWeek = beginningOfWeek
                
            }
            
            let date = calendar.date(byAdding: .day, value: i, to: beginningOfWeek)!
            
            if(i == 6)
            {
               
                let lastdate = calendar.date(byAdding: .day, value: 7, to: beginningOfWeek)!
                sundayInWeek = lastdate
                
            }
            formattedDays.append(formatDate(date: date as NSDate))
        }
        return formattedDays
    }
}
extension HomeViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == tableView2)
        {
            
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
        else
        {
            if(thisWeekActivity.count == 0)
            {
                return 1
            }
            else
            {
                return thisWeekActivity.count
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == tableView2)
        {
            return 10
            
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableView2)
        {
            let cell : HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! HomeTableViewCell
            let pet = Pets[indexPath.section]
            cell.nameLabel.text = pet.value(forKeyPath: "petName") as? String
            cell.ageLabel.text = calcAge(birthdate: pet.value(forKey: "petDOB") as! Date)
            
            if(pet.value(forKey: "petImage") as? Data != nil)
            {
                if(imagesFromCoreData(object: pet.value(forKey: "petImage") as? Data)!.count > 0)
                {
                    cell.petImage.image =  imagesFromCoreData(object: pet.value(forKey: "petImage") as? Data)![0]
                }
            }
            cell.layer.cornerRadius = 15.0
            cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1
            cell.layer.masksToBounds = false //<-
            
            heightConstraint2.constant = tableView2.contentSize.height
            return cell
        }
        else
        {
            let cell : HomeKecilTableViewCell = tableView.dequeueReusableCell(withIdentifier: "homecellkecil", for: indexPath) as! HomeKecilTableViewCell
            if thisWeekActivity.count == 0
            {
                cell.valueLabel.text = "No activities this week"
            }
            else
            {
                if(Pets.count != 0)
                {
                    let string = String((thisWeekActivity[indexPath.section].ofPets?.petName)! + " " + String(thisWeekActivity[indexPath.section].title! + " Day On " + formatDay(date: thisWeekActivity[indexPath.section].date! as NSDate)))
                    cell.valueLabel.text = string
                }
                
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        for item in tableView1.indexPathsForVisibleRows!{
//          if tableView1.bounds.contains(tableView1.rectForRow (at: item)){
//
//
//          }
//        }
//      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == tableView2)
        {
            
            let selectedId = Pets[indexPath.section].value(forKey: "PetID")
            
            selectedID = selectedId as! UUID
            performSegue(withIdentifier: "toDetail", sender: nil)
            
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == tableView2)
        {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            
            return headerView
        }
        else
        {
            return nil
        }
    }
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

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //TAMPILAN//////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return date.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 36 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        
    }
    ///////////////////////////////////////////////////////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecollectioncell", for: indexPath) as! HomeCollectionViewCell
        
        var flag = false
        if(indexPath.row == 0)
        {
            cell.dateLabel.textColor = .white
            cell.buletan.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
        }

        cell.dateLabel.text = date[indexPath.row]
        cell.dayLabel.text = week[indexPath.row]

        if(activityDates.count > 0)
        {
            for i in 0...activityDates.count - 1
            {
                if(cell.dateLabel.text == activityDates[i] && cell.dateLabel.text?.isEmpty == false)
                {
                    flag = true
                }
            }
        }
        if(flag == true)
        {
            cell.dayLabel.textColor = #colorLiteral(red: 0.9411764706, green: 0.4039215686, blue: 0.09411764706, alpha: 1)
        }
        else
        {
            cell.dayLabel.textColor = .lightGray
        }
        return cell
    }
    
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)) ~= self
    }
}
