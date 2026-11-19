//
//  NapoliCategoryService.swift
//  goodmorning
//
//  Created by Salvatore Fumo on 19/11/2026.
//
import Foundation

struct CategoryMember: Codable {
    let title: String
}

struct WikiCategoryResponse: Codable {
    let query: CategoryQuery?
    
    struct CategoryQuery: Codable {
        let categorymembers: [CategoryMember]
    }
}

class NapoliCategoryService {
    static let shared = NapoliCategoryService()
    
    // Una sola chiamata rapidissima (senza loop di paginazione)
    func fetchPlayers() async throws -> [String] {
        let urlString = "https://it.wikipedia.org/w/api.php?action=query&list=categorymembers&cmtitle=Categoria:Calciatori_della_S.S.C._Napoli&cmlimit=500&format=json"
        
        guard let url = URL(string: urlString) else { return [] }
        
        var request = URLRequest(url: url)
        request.setValue("NapoliApp/1.0 (salvatore@example.com)", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return [] }
        
        let decoded = try JSONDecoder().decode(WikiCategoryResponse.self, from: data)
        
        return decoded.query?.categorymembers
            .map { $0.title }
            .filter { !$0.contains("Categoria:") && !$0.contains("File:") } ?? []
    }
}
