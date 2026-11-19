//
//  WikipediaAPIService.swift
//  goodmorning
//
//  Created by Salvatore Fumo on 19/11/2026.
//

import Foundation

struct WikipediaSummary: Codable {
    let title: String
    let extract: String?
    let thumbnail: Thumbnail?
    
    struct Thumbnail: Codable {
        let source: String
        let width: Int
        let height: Int
    }
}

class WikipediaAPIService {
    static let shared = WikipediaAPIService()
    
    func fetchPlayerInfo(playerName: String) async throws -> WikipediaSummary {
        let formattedName = playerName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? playerName
        
        guard let url = URL(string: "https://it.wikipedia.org/api/rest_v1/page/summary/\(formattedName)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("NapoliHistoryApp/1.0 (salvatore@example.com)", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(WikipediaSummary.self, from: data)
    }
}
