//
//  FluxITMainViewController.swift
//  FluxIT
//
//  Created by Gastón Pena on 26/1/17.
//  Copyright © 2017 Gastón Pena. All rights reserved.
//

import UIKit

class FluxITMainViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moviesCountLabel: UILabel!
    @IBOutlet weak var seriesCountLabel: UILabel!
    
    var series = [Tv]()
    var movies = [Tv]()
    var type:String!
    var getDetailCall:String!
    var details:Details!
    var isKindOfMovie = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJsonDataAllCategories()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    //CLOSE HEADERVIEW
    @IBAction func closeMainHeaderView(_ sender: UIButton) {
        print("CLOSE BUTTON")
        headerView.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:0)
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                            self.tableView.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
        }, completion: { (finished) -> Void in
        
        })
        
    }
    
    //CALL SERVICE ALL_CATEGORIES
    func getJsonDataAllCategories() {
        let url = URL(string: BASE_URL + ALL_CATEGORIES)!
        
        let request = URLRequest(url: url)
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data, error == nil {
                DispatchQueue.main.sync {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    
                    let seriesArray = jsonData["Tv Series"] as! [[String: AnyObject]]
                
                    for serieDictionary in seriesArray {
                        let serie = Tv(dictionary: serieDictionary)
                        self.series.append(serie)
                    }
                    
                    let moviesArray = jsonData["Movies"] as! [[String: AnyObject]]
                    
                    for movieDictionary in moviesArray {
                        let movie = Tv(dictionary: movieDictionary)
                        self.movies.append(movie)
                    }
                    
                    self.moviesCountLabel.text = "Cantidad de Peliculas Encontradas: \(self.movies.count)"
                    self.seriesCountLabel.text = "Cantidad de Series Encontradas: \(self.series.count)"
                    
                    self.tableView.reloadData()
                }
                
            } else {
                print(error ?? "error")
            }
            
            }.resume()
    }
    
    
    //CALL SERVICE DETAILS
    func getJsonDataDetails() {
        let url = URL(string: BASE_URL + type + getDetailCall)!
        
        let request = URLRequest(url: url)
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data, error == nil {
                DispatchQueue.main.sync {
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]

                    self.details = Details(dictionary:jsonData)
                    
                self.performSegue(withIdentifier: "MainIdentifier", sender: nil)
                }
                
            } else {
                print(error ?? "error")
            }
            
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MainIdentifier") {
            
            if let vc: DetailsViewController = segue.destination as? DetailsViewController {
                //vc.detailsDict = self.detailsDict
                vc.details = details
                vc.getDetailToFavorite = getDetailCall
                vc.isKindOfMovie = isKindOfMovie
            }
            
        }
    }
}

//IMPLEMENT UITABLEVIEW DATASOURCE METHODS
extension FluxITMainViewController: UITableViewDataSource {
    
    //SET NUMBER OF SECTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //SET NUMBER OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numRows:Int
        if section == 0 {
            numRows = series.count
        } else {
            numRows = movies.count
            //numRows = 3
        }
        return numRows
    }
    
    //SET VALUES OF EACH ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FluxITMainCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! FluxITMainCell
        
        if indexPath.section == 0 {
            if self.series[indexPath.row].name != "" {
                cell.nameLabel.text = self.series[indexPath.row].name
            } else {
                cell.nameLabel.text = "Título a definir"
            }
            if self.series[indexPath.row].description != "" {
                cell.descriptionLabel.text = self.series[indexPath.row].description
            } else {
                cell.descriptionLabel.text = "Descripcion a Definir"
            }
            
        } else {
            if self.movies[indexPath.row].name != "" {
                cell.nameLabel.text = self.movies[indexPath.row].name
            } else {
                cell.nameLabel.text = "Título a definir"
            }
            if self.movies[indexPath.row].description != "" {
                cell.descriptionLabel.text = self.movies[indexPath.row].description
            } else {
                cell.descriptionLabel.text = "Descripcion a Definir"
            }
            
        }
        
        return cell
    }
    
    //SET CUSTOM HEADER
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 14)
        header.textLabel?.textColor = UIColor.red
    }
    
    //SET TITLE HEADER
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Tv Series"
        } else {
            return "Movies"
        }
    }
    
    //SET HEIGHT FOR HEADER
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

}

//IMPLEMENT UITABLEVIEW DELEGATE METHODS
extension FluxITMainViewController: UITableViewDelegate {

    //SET ACTION TO SELECTABLE CELLS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            isKindOfMovie = false
            type = "series/"
            getDetailCall = self.series[indexPath.row].getDetail
        } else {
            isKindOfMovie = true
            type = "movies/"
            getDetailCall = self.movies[indexPath.row].getDetail
        }
        
        getJsonDataDetails()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

