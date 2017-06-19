//
//  JobsViewController.swift
//  investHR
//
//  Created by mac on 26/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchResultsUpdating
{

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var savedJobsArray:[Int] = []
    
    @IBOutlet weak var saveJobImage: UIImageView!
    func saveJobButtonClicked(_ sender: UIButton)
    {
        let hint = Int(sender.accessibilityHint! as String)!
        
        if let elementIndex = savedJobsArray.index(of: hint)
        {
            savedJobsArray.remove(at: elementIndex)
        }
        else
        {
            savedJobsArray.append(hint)
        }
        self.collectionView.reloadData()
    }
    var jobsArray:[String] = ["abc","bcd","cde","ghj"]
    
    
    var searchController:UISearchController = UISearchController()
    
    @IBOutlet weak var searchBarView: UIView!
//    @property (nonatomic, strong) NSArray *search;
    override func viewDidLoad()
    {
    
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        let barButtonItem = UIBarButtonItem(image:UIImage(named:"BackButton"), style: UIBarButtonItemStyle.done, target: self, action: #selector(popViewController))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Jobs"
        
        let numberOfJobsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
        numberOfJobsLabel.textColor = UIColor(colorLiteralRed: 241/255.0, green: 141/255.0, blue: 90/255.0, alpha: 1)
        numberOfJobsLabel.text = "108 jobs"
        numberOfJobsLabel.textAlignment = NSTextAlignment.right
        let rightBarButtonItem = UIBarButtonItem(customView: numberOfJobsLabel)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
//self.navigationItem.rightBarButtonItem.
        self.setSearchController()
        // Do any additional setup after loading the view.
    }
    
    func popViewController() -> Void
    {
        //self.revealViewController().revealToggle(animated: true)
        
        self.navigationController?.popViewController(animated: true)
    }

    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        let view = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
//                                                                        withReuseIdentifier:"header", for: indexPath)
//        
//        
//
//        //let view1 = UIView(frame: CGRect(x: 10, y: 10, width: 300, height: 200))
//        //view1.backgroundColor = UIColor.blue
////        self.searchController.searchBar.delegate = self
////        self.searchController.searchBar.frame = CGRect(x: 0, y: 10, width: 300, height: 200)
////        view.addSubview(self.searchController.searchBar)
//        
//        //let serachBar:UICollectionReusableView = self.searchController.searchBar as! UICollectionReusableView
//        
//        return view
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize(width: self.collectionView.frame.size.width, height: 100)
//    }
    func setSearchController() -> Void
    {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self;
        self.searchController = UISearchController();
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.delegate = self;
        //self.collectionView.tableHeaderView = self.searchController.searchBar;
        self.definesPresentationContext = true;
        self.searchController.obscuresBackgroundDuringPresentation = true;
        self.searchController.hidesNavigationBarDuringPresentation=true;
        self.definesPresentationContext = true;
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false // Optional
        self.searchController.searchBar.delegate = self
        //self.searchController.searchBar.barTintColor = UIColor.white
        // Add the search bar as a subview of the UIView you added above the table view
        self.searchBarView.addSubview(self.searchController.searchBar)
        // Call sizeToFit() on the search bar so it fits nicely in the UIView
        //self.searchController.searchBar.sizeToFit()
        // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
        self.searchController.searchBar.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 50)
        //self.searchController.searchBar.frame.size.width = self.view.frame.size.width
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
//        let predicate1 = [NSPredicate predicateWithFormat:"soNumber CONTAINS [cd] %@", self.searchController.searchBar.text];
        
      let predicate = NSPredicate(format: "SELF CONTAINS [cd] %@", self.searchController.searchBar.text!)
        
       let resultArray = jobsArray.filter { predicate.evaluate(with: $0) };

        //jobsArray.filter(predicate)
        print(resultArray)
        
        }
    
//    - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//    {
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    return view;
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        let companyNameLabel = cell.viewWithTag(101) as! UILabel
        let companyWebSiteLabel = cell.viewWithTag(102) as! UILabel
        let applyButton = cell.viewWithTag(103) as! UIButton
        let saveButton = cell.viewWithTag(104) as! UIButton
        let saveImageView = cell.viewWithTag(105) as! UIImageView

        saveButton.accessibilityHint = String(indexPath.row)
        
        if savedJobsArray.contains(indexPath.row)
        {
            saveImageView.image = UIImage(named: "SideMenuSavedJob")
        }
        else
        {
            saveImageView.image = UIImage(named: "SavedUnselected")
        }
        //saveButton.tag = indexPath.row
        saveButton.addTarget(self, action: #selector(saveJobButtonClicked), for: UIControlEvents.touchUpInside)
        applyButton.layer.borderColor = UIColor(red: 77/255.0, green: 150/255.0, blue: 241/255.0, alpha: 1).cgColor
//        applyButton.layer.cornerRadius = 3.0

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: self.view.frame.size.width*0.95, height: 200)
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
