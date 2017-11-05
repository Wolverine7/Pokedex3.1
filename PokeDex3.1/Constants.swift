//
//  Constants.swift
//  PokeDex3.1
//
//  Created by Bobodzhon Isamov on 10/29/17.
//  Copyright © 2017 Bobodzhon Isamov. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v2/pokemon/"
let URL_POKEMON_DESCRIPTION = "/api/v2/pokemon-species/"
let URL_POKE_EVOLUTION = "/api/v1/pokemon/"

//block of code that runs specific time pass this to download pokemon class
typealias DownloadComplete = () -> ()
