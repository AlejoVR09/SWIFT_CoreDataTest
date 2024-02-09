//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Alejandro Vanegas Rondon on 6/02/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var myCountries: [Country]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "MyCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "mycustomcell")
        
        retrieveData()
        
    }

    func retrieveData(){
        do{
            self.myCountries = try context.fetch(Country.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Error")
        }
    }
    @IBAction func add(_ sender: Any) {
        
        let alertButton = UIAlertController(title: "Add country", message: "Add Country", preferredStyle: .alert)
        alertButton.addTextField()
        
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let textField = alertButton.textFields![0]
            
            let country = Country(context: self.context)
            country.name = textField.text
            
            do {
                try self.context.save()
                self.retrieveData()
            }
            catch{
                print("error 2")
            }
            
            
        }
        
        alertButton.addAction(alertAction)
        self.present(alertButton, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Celdas simples"
        }
        return "Celdas custom"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Footer para celdas simples"
        }
        return "Footer para celdas custom"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCountries!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
                cell?.backgroundColor = .gray
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                cell?.accessoryType = .disclosureIndicator
            }
            cell!.textLabel?.text = myCountries![indexPath.row].name
            return cell!
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycustomcell", for: indexPath) as? MyCustomTableViewCell
        
        cell?.myFirstLabel.text = String(indexPath.row + 1)
        cell!.mySecondLabel.text = myCountries![indexPath.row].name
        
        if indexPath.row == 2 {
            cell!.mySecondLabel.text = "ajsldkjaklsjd kjajkjsdlk jas kajsdkl jakj akljsdkaljs kjaskdjaskj dkaljsdka jskdjaklsjdalksjdklajsdka jksjdaklj sd"
        }

        return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(myCountries![indexPath.row].name!)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action, view, completionHandler) in
            let deletedCountry = self.myCountries![indexPath.row]
            self.context.delete(deletedCountry)
            do {
                try self.context.save()
                self.retrieveData()
            }
            catch{
                print("error 3")
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

