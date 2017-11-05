//
//  PokeCell.swift
//  PokeDex3.1
//
//  Created by Bobodzhon Isamov on 10/28/17.
//  Copyright © 2017 Bobodzhon Isamov. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        
        //update a image view with coresponding pokemon character
        
        
        //update a label with coresponding pokemon character's name
        nameLbl.text = self.pokemon.name.uppercased()
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
