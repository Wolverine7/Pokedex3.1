//
//  Pokemon.swift
//  PokeDex3.1
//
//  Created by Bobodzhon Isamov on 10/28/17.
//  Copyright © 2017 Bobodzhon Isamov. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    private var _pokemonInfoURL: String!
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)/"
        self._pokemonInfoURL = "\(URL_BASE)\(URL_POKEMON_DESCRIPTION)\(self._pokedexId!)"
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        Alamofire.request(self._pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    for statIndex in stats {
                        let statType = statIndex["stat"]?["name"] as? String
                        if statType == "attack"{
                            let attack = statIndex["base_stat"] as? Int
                            self._attack = "\(attack!)"
                        }else if statType == "defense" {
                            let defense = statIndex["base_stat"] as? Int
                            self._defense = "\(defense!)"
                        }
                    }
                    
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0{
                    if let typeDict = types[0]["type"] as? Dictionary<String,AnyObject> {
                        if let name = typeDict["name"] as? String {
                            self._type = name.capitalized
                        }
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let typeDict = types[x]["type"] as? Dictionary<String,AnyObject> {
                                if let name = typeDict["name"] as? String {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                //Get the pokemon description from a different endpoint
                Alamofire.request(self._pokemonInfoURL).responseJSON(completionHandler: { (response) in
                    if let tempDict = response.result.value as? Dictionary<String, AnyObject>{
                        if let flavourTextEntries = tempDict["flavor_text_entries"] as? [Dictionary<String, AnyObject>]{
                            for entries in flavourTextEntries {
                                
                                // Go through each entry and find the "english entry"
                                if let languageDict = entries["language"] as? Dictionary<String, AnyObject>{
                                    
                                    if languageDict["name"] as? String == "en" {
                                        if let description = entries["flavor_text"] as? String {
                                            
                                            self._description = description
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        let evolURL = "\(URL_BASE)\(URL_POKE_EVOLUTION)\(self.pokedexId)"
                        
                        Alamofire.request(evolURL).responseJSON(completionHandler: { (response) in
                            if let evolDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let evolutions = evolDict["evolutions"] as? [Dictionary<String, AnyObject>] {
                                    
                                    if let minLvl = evolutions[0]["level"] as? Int {
                                        
                                        self._nextEvolutionLevel = "\(minLvl)"
                                        
                                    } else {
                                        self._nextEvolutionLevel = ""
                                    }
                                    
                                    
                                    if let evolutionName = evolutions[0]["to"] as? String{
                                        self._nextEvolutionName = evolutionName
                                    } else {
                                        self._nextEvolutionName = ""
                                    }
                                    
                                    if let evolutionURL = evolutions[0]["resource_uri"] {
                                        
                                        let newStr = evolutionURL.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                        let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                        
                                        self._nextEvolutionId = nextEvoId
                                    } else {
                                        self._nextEvolutionId = ""
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            completed()
                        })
                        
                        
                        
                        
                    }
                    
                    completed()
                })
                
                
                
                
            }
            
            completed()
        }
        
    }
}
