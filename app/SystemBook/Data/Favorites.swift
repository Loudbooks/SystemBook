// Favorites.swift created by Loudbook on 6/26/24.

import Foundation

@Observable
class Favorites {
    private var favorites: Array<String>

    init() {
        favorites = []
        load()
    }
    
    func load() {
        favorites = SavedDataManager.shared.get(key: "favorites") ?? Array()
    }
    
    func save() {
        SavedDataManager.shared.saveArray(key: "favorites", object: Array(favorites))
    }
    
    func add(id: String) {
        favorites.append(id)
        save()
    }
    
    func remove(id: String) {
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
        }
        
        save()
    }
    
    func contains(id: String) -> Bool {
        favorites.map() { $0.lowercased() }.contains(id.lowercased())
    }
    
    func list() -> Array<String> {
        return favorites
    }
}
