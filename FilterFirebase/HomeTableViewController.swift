//
//  HomeTableViewController.swift
//  
//
//  Created by Wesley Mota on 06/06/16.
//
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var ref = FIRDatabase.database().reference()
    
    var nome: String!
    var items = [GroceryItem]()
    var sobrenome: String!
    var filteredItems = [GroceryItem]()
    
    
    var detailViewController: DetailViewController? = nil
    
    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ref.child("Cadastro").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var newItems = [GroceryItem]()
            
            for item in snapshot.children {
                
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return items.count
        
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            return self.filteredItems.count
        } else{
            return items.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let groceryItem = items[indexPath.row]
        var items1: GroceryItem
        
        cell.nameLbl.text = groceryItem.nome
        cell.lastNameLbl.text = groceryItem.sobrenome

        
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            items1 = self.filteredItems[indexPath.row]
            
        } else {
            items1 = self.items[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var items1: GroceryItem
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            items1 = self.filteredItems[indexPath.row]
        } else {
            items1 = self.items[indexPath.row]
        }
        
        print(items1.nome)
        
    }
    
    func filterContetnForSearchText(searchText: String, scope: String = "All") {
    
        self.filteredItems = self.items.filter({ (friend: GroceryItem) -> Bool in
            var categoryMatch = (scope == "All")
            var stringMatch = friend.nome.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
        })
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool
        
    {
        self.filterContetnForSearchText(searchString!, scope: "All")
        return true
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
        
    {
        
        self.filterContetnForSearchText(self.searchDisplayController!.searchBar.text!, scope: "All")
        return true
        
    }

}
