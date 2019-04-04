//
//  MasterViewController.swift
//  MyApp
//
//  Created by Faizan Ali Siddiqui on 4/4/19.
//  Copyright © 2019 Faizan Ali Siddiqui. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SDWebImage

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var newsDataArray = [Any]()
    var newsDataDict = Dictionary<String, Any>()
    let dateFormatterPrint = DateFormatter()
     let dateFormatterGet = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.isHidden = true
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        self.getNewsData()
        
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    //MARK: GET News data
    func getNewsData() {
        print("--Fetching News data--")
        SVProgressHUD.show()
        
        let baseUrl = String(format : "%@",constant.apiUrl)
        
      
        Alamofire.request(baseUrl ,method : .get ,parameters : nil
            ).responseJSON { response in
                
                SVProgressHUD.dismiss();
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                  
                    var dict = json as! [String : Any]
                    
                  
                    let status  = dict["status"] as? String
                    
                    if  (status == "ok") {
                        
                        if let resultDict = dict["articles"]{
                            print(resultDict)
                            
                            self.newsDataArray = (resultDict as? [Any])!
                            print("Array --->\(self.newsDataArray)----Count : \(self.newsDataArray.count)")
                            
                            self.tableView.reloadData()
                            self.tableView.isHidden = false
                        }
                      
                    }
                    else{
                        let alert = UIAlertController(title:"Alert" , message:"Unable to get status ok from  server. Please retry.", preferredStyle:.alert)
                        alert.addAction(UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil))
                        self.present(alert,animated: true)
                    }
                }
                else{
                    print("Unable to connect to server.")
                    let alert = UIAlertController(title:"Alert" , message:"Unable to connect to server. Please retry.", preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil))
                    self.present(alert,animated: true)
                }
                
        }
        
        
    }

   
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = newsDataArray[indexPath.row] as! [String : Any]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.selectedNewsDict = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        let dict = self.newsDataArray[indexPath.row] as? [String : Any]
        
        cell.titleLabel.text = dict!["title"] as? String
         cell.descLabel.text = dict!["description"] as? String
        
        let date: NSDate? = dateFormatterGet.date(from:dict!["publishedAt"] as! String) as NSDate?
        
        cell.dateLabel.text = dateFormatterPrint.string(from: date! as Date)
        
        if let imgURL = dict!["urlToImage"] as? String {
            cell.imgView.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "placeholder"))
        }
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2
        cell.imgView.clipsToBounds = true
        
       
        
        return cell
    }


}

