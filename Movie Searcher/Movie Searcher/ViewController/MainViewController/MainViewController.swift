//
//  MainViewController.swift
//  Movie Searcher
//
//  Created by Ramon Augusto on 13/12/21.
//  Copyright © 2021 Ramon Augusto. All rights reserved.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet  var table: UITableView!
    @IBOutlet  var field: UITextField!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.rowHeight = 160
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies(){
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else{
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "&")
        
        movies.removeAll()
        
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=b2cdfc84938b558628eeec1931e7e66d&query=\(query)"
        
        URLSession.shared.dataTask (with: URL(string: urlString)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else{
                return
            }
            
            var result: MovieResult?
            do{
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch{
                print("error")
            }
            guard let finalResult = result else{
                return
            }
            
            //update movie array
            let newMovies  = finalResult.results
            self.movies.append(contentsOf: newMovies)
            
            //refresh our table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }).resume()
        
    }
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = "https://www.themoviedb.org/movie/\(movies[indexPath.row].id)"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
    struct MovieResult: Codable{
        let results: [Movie]
    }
}

struct Movie: Codable{
    
    let title, release_date: String
    let poster_path: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey{
        case title, release_date, id, poster_path
        
    }
}
