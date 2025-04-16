//
//  ViewModel.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PokemonViewModel {
    private let disposeBag = DisposeBag()
    var loading = BehaviorRelay<Bool>(value: false)
    var pokemonData = BehaviorRelay<[TableSection]>(value: [])
    let error = PublishRelay<String>()
    
    
    func fetchData(url: String){
        self.loading.accept(true)
        WServices.shared.getPokemon(url: url, completion: { [weak self] result in
            self?.loading.accept(false)
            switch result {
                case .success(let pokemon):
                    self?.setName(names: pokemon.names)
                    self?.setEffectChanges(effectsC: pokemon.effectChanges)
                    self?.setEffectEntries(effects: pokemon.effectEntries)
                    self?.setFlavorText(flavors: pokemon.flavorTextEntries)
                case .failure(let error):
                    self?.error.accept(error.localizedDescription)
            }
        })
    }
    
    func setName(names: [Name]) {
        if let name = names.first(where: { $0.language.name == "es"}){
            let newSection = TableSection(title: "Nombre", items: [name.name])
            self.updatePokemonData(newData: newSection)
        }
    }
    
    func setFlavorText(flavors: [FlavorTextEntry]) {
        if let flavor = flavors.first(where: { $0.language.name == "es"}){
            let newSection = TableSection(title: "Sabor", items: [flavor.flavorText])
            self.updatePokemonData(newData: newSection)
        }
    }
    func setEffectEntries(effects: [EffectEntry]) {
        if let effectEntries = effects.first(where: { $0.language.name == "es"}){
            let newSection = TableSection(title: "Efectos", items: [effectEntries.effect])
            self.updatePokemonData(newData: newSection)
        }
    }
    func setEffectChanges(effectsC: [EffectChange]) {
        let effectsChange = effectsC.flatMap { $0.effectEntries }
                                    .filter { $0.language.name == "es" }
                                    .map { $0.effect }
        let newSection = TableSection(title: "Cambio de Efectos", items: effectsChange)
        self.updatePokemonData(newData: newSection)
    }
    
    func updatePokemonData(newData: TableSection) {
        var current = pokemonData.value
        current.append(newData)
        pokemonData.accept(current)
    }
}

