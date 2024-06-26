// SavedDataManager.swift created by Loudbook on 6/26/24.

import Foundation

class SavedDataManager {
    static let shared = SavedDataManager()
    
    let defaults = UserDefaults.standard
    
    func saveArray(key: String, object: Array<String>) {
        defaults.set(object, forKey: key)
    }
    
    func get<T>(key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
}

