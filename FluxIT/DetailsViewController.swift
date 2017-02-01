//
//  DetailsViewController.swift
//  FluxIT
//
//  Created by Gastón Pena on 28/1/17.
//  Copyright © 2017 Gastón Pena. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController:UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var headerCollellectionView: UICollectionView!
    var details:Details!
    var getDetailToFavorite:String!
    var imageSeason:UIImage!
    var isKindOfMovie:Bool!
    var favoriteResponseDict:[String:String]!
    var popUpMessage:String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        bringImageFromURL()
        view.backgroundColor = UIColor.black
        
        //SET TABLEVIEW DELEGATE &DATASOURCE
        detailTableView.dataSource = self
        detailTableView.delegate = self
        
        //SET COLLECTIONVIEW DATASOURCE
        headerCollellectionView.dataSource = self
    }
    
    //ADD TO FAVORITE BUTTON ACTION
    @IBAction func addFavorite(_ sender: UIButton) {
        print("ADD TO FAVORITE")
        
        getJsonfavorite()
        //showPopUpAddToFavorite()
    }
    
    //CALL SERVICE
    func getJsonfavorite() {
        let url = URL(string: BASE_URL + ADD_FAVORITE + getDetailToFavorite)!
        
        let request = URLRequest(url: url)
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data, error == nil {
                DispatchQueue.main.sync {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: String
                    ]
                    self.favoriteResponseDict = jsonData
                    
                    if self.favoriteResponseDict["message"] != "" {
                        self.popUpMessage = self.favoriteResponseDict["message"]
                    } else {
                        self.popUpMessage = "Mensaje a definir"
                    }
                    self.showPopUpAddToFavorite(message: self.popUpMessage)
                }
            } else {
                print(error ?? "error")
            }
            
            }.resume()
    }
    
    //SHOW POP UP
    func showPopUpAddToFavorite(message:String){
        let popOverVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "PopUpVC") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        popOverVC.messagePopUp.text = message
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    func bringImageFromURL() {
        let session = URLSession(configuration: .default)
        
        if details.image != "" {
            _ = session.dataTask(with: URL(string:details.image
                )!) { (data, response, error) in
                    if let e = error {
                        print("Error downloading cat picture: \(e)")
                    } else {
                        if (response as? HTTPURLResponse) != nil {
                            if let imageData = data {
                                
                                DispatchQueue.main.async {
                                    self.imageSeason = UIImage(data: imageData)
                                    
                                    self.headerCollellectionView.reloadData()
                                    self.detailTableView.reloadData()
                                }
                            } else {
                                print("Couldn't get image: Image is nil")
                            }
                        } else {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }.resume()
        }
    }
}

//IMPLEMENT UITABLEVIEW DATASOURCE METHODS
extension DetailsViewController: UITableViewDataSource {
    
    //SET NUMBER OF SECTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //SET NUMBER OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    //SET VALUES OF EACH ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let cellOne:DetailsFirstSectionCell = tableView.dequeueReusableCell(withIdentifier: "DetailCellOne", for:indexPath) as! DetailsFirstSectionCell
            
            if indexPath.row != 0 {
                if cellOne.addButton != nil {
                    cellOne.addButton .removeFromSuperview()
                }
            }
            cellOne.nameCellLabel.text = details.title
            cellOne.detailLabel.text = details.getDetail
            cellOne.imageCellView.image = self.imageSeason
            
            cell = cellOne
        } else {
            if isKindOfMovie == true {
                let cellTwo:DetailsSecondSectionCellMovies = tableView.dequeueReusableCell(withIdentifier: "DetailCellThree", for:indexPath) as! DetailsSecondSectionCellMovies
                
                cellTwo.nameLabel.text = self.details.actors[indexPath.row]["name"] as! String?
                cellTwo.detailsLabel.text = self.details.actors[indexPath.row]["description"] as! String?
                
                cell = cellTwo
            } else {
                let cellTwo:DetailsSecondSectionCell = tableView.dequeueReusableCell(withIdentifier: "DetailCellTwo", for:indexPath) as! DetailsSecondSectionCell
                
                cellTwo.nameLabel.text = details.seasons[indexPath.row]["name"] as! String?
                cell = cellTwo
            }
        }
        
        
        return cell
    }
    
}

//IMPLEMENT UITABLEVIEW DELEGATE METHODS
extension DetailsViewController: UITableViewDelegate {
    
    //SET CUSTOM HEADER
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 14)
        header.textLabel?.textColor = UIColor.red
    }
    
    //SET HEIGHT FOR HEADER
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var heightRow = 0
        if indexPath.section == 0 {
            heightRow = 100
        } else {
            if isKindOfMovie == true {
                heightRow = 100
            } else {
                heightRow = 44
            }
        }
        return CGFloat(heightRow)
    }
}

//IMPLEMENT UICOLLECTIONVIEW DATASOURCE METHODS
extension DetailsViewController:UICollectionViewDataSource {
    
    //SET NUMBER OF ITEMS IN SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isKindOfMovie == true {
            return details.actors.count
        } else {
            return details.seasons.count
        }
    }
    
    //SET VALUE OF ITEM
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell:UICollectionViewCell!
        
        if self.isKindOfMovie == true {
            let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellTwo", for: indexPath) as! DetailsCollectionViewCellTwo
            cellTwo.titleLabel.text = self.details.actors[indexPath.row]["name"] as! String?
            
            if self.details.actors[indexPath.row]["description"] as? String != nil {
                cellTwo.descriptionLabel.text = self.details.actors[indexPath.row]["description"] as! String?
            } else {
                cellTwo.descriptionLabel.text = "Este Actor no posee descripción"
            }
            if details.image != "" {
                cellTwo.image.image = self.imageSeason
            }
            cell = cellTwo
            
        } else {
            let cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellOne", for: indexPath) as! DetailsCollectionViewCell
            cellOne.nameLabel.text = self.details.seasons[indexPath.row]["name"] as! String?
            
            if details.image != "" {
                cellOne.image.image = self.imageSeason
            }
            cell = cellOne
        }
        return cell
    }
}
