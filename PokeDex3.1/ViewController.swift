//
//  ViewController.swift
//  PokeDex3.1
//
//  Created by Bobodzhon Isamov on 10/28/17.
//  Copyright © 2017 Bobodzhon Isamov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //will loop continiously
            musicPlayer.play()
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    //grab the pokemon
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            //use parser to access each row
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    //creating the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //loads as many as it needs at a time; if an user scroll down, those that are not in the display anymore deques
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            }else{
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            cell.configureCell(poke)
            
            return cell
            
        }else{
            //else return empty generic cell
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }else{
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        //if the music is playing make it pause
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}

