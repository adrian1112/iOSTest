//
//  PokemonModel.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import Foundation

struct EffectChange: Codable {
    let effectEntries: [EffectEntry]
    let versionGroup: Generic

    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case versionGroup = "version_group"
    }
}

struct EffectEntry: Codable {
    let effect: String
    let language: Generic
}


struct EffectEntryDetail: Codable {
    let effect: String
    let language: Generic
    let shortEffect: String

    enum CodingKeys: String, CodingKey {
        case effect
        case language
        case shortEffect = "short_effect"
    }
}


struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Generic
    let versionGroup: Generic

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case versionGroup = "version_group"
    }
}

struct Name: Codable {
    let name: String
    let language: Generic
}

struct Generic: Codable {
    let name: String
    let url: String
}

struct Pokemon: Codable {
    let effectChanges: [EffectChange]
    let effectEntries: [EffectEntry]
    let flavorTextEntries: [FlavorTextEntry]
    let names: [Name]
    
    enum CodingKeys: String, CodingKey {
        case effectChanges = "effect_changes"
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case names
    }
}
