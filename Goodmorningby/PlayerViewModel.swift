//
//  PlayerViewModel.swift
//  MyApp
//
//  Created by Salvatore Fumo on 17/11/2026.
//
import Foundation
import SwiftUI
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var currentPlayerName: String?
    @Published var wikiData: WikipediaSummary?
    @Published var isLoading = false
    
    private var allPlayers: [String] = []
    private let cacheKey = "cached_napoli_players"
    
    init() {
        loadFastPlayers()
    }
    
    func loadFastPlayers() {
        // 1. Se abbiamo già la lista salvata sull'iPhone, la usiamo ALL'ISTANTE
        if let cached = UserDefaults.standard.stringArray(forKey: cacheKey), !cached.isEmpty {
            self.allPlayers = cached
            getRandomPlayer()
            return
        }
        
        // 2. Altrimenti la scarichiamo una volta sola in background
        Task {
            isLoading = true
            do {
                let fetched = try await NapoliCategoryService.shared.fetchPlayers()
                self.allPlayers = fetched
                // Salva in cache per i futuri avvii
                UserDefaults.standard.set(fetched, forKey: cacheKey)
                
                if currentPlayerName == nil {
                    getRandomPlayer()
                }
            } catch {
                print("Errore caricamento: \(error)")
                isLoading = false
            }
        }
    }
    
    func getRandomPlayer() {
        guard !allPlayers.isEmpty else { return }
        
        Task {
            isLoading = true
            wikiData = nil
            
            guard let randomName = allPlayers.randomElement() else {
                isLoading = false
                return
            }
            
            self.currentPlayerName = randomName
            
            do {
                let summary = try await WikipediaAPIService.shared.fetchPlayerInfo(playerName: randomName)
                self.wikiData = summary
            } catch {
                print("Errore bio Wikipedia per \(randomName): \(error)")
            }
            
            self.isLoading = false
        }
    }
}
