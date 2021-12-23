//
//  MovieTableViewCell.swift
//  Movie Searcher
//
//  Created by Caio Arruda on 18/12/21.
//  Copyright © 2021 Ramon Augusto. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.title
        self.movieYearLabel.text = model.release_date
        
        
        let imageUrl = model.poster_path
        let baseURL = URL(string: "https://image.tmdb.org/t/p/original/")
        let vc1 = baseURL?.appendingPathComponent(imageUrl)
        
        
        if let data = try? Data(contentsOf: vc1!){
        self.moviePosterImageView.image = UIImage(data: data)
        }
        
        
        //if  let data = try? Data(contentsOf: URL(string: url)!){
        //self.moviePosterImageView.image = UIImage(data: data)
        
        //}
    }
    
}


