//
//  PokemonDetailVC.swift
//  PokeDex3.1
//
//  Created by Bobodzhon Isamov on 10/28/17.
//  Copyright © 2017 Bobodzhon Isamov. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
       nameLbl.text = pokemon.name
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetail {
            // whatever we write here only be called after the network call is complete
            
            self.updateUI()
        }
        
    }
    
    func updateUI(){
        attackLbl.text = pokemon.attack
        defenseLbl.text = "\(pokemon.defense)"
        heightLbl.text = "\(pokemon.height)"
        weightLbl.text = "\(pokemon.weight)"
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == ""{
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        }else{
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
    
        dismiss(animated: true, completion: nil)
    }
    
}
