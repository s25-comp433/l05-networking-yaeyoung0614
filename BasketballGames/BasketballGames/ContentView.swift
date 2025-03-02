//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var games: [Game]
}

struct Game: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var opponent: Int
    var unc: Int
}

struct ContentView: View {
    @State private var games = [Game]()

    var body: some View {
        VStack {
            Text("UNC Basketball Games")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundColor(.pink)

            List(games, id: \.id) { game in
                VStack(alignment: .leading) {
                    Text("\(game.team) vs \(game.opponent)")
                        .font(.headline)
                        .foregroundColor(.pink)

                    Text("🗓️ Date: \(game.date)")
                    Text("📍 Location: \(game.isHomeGame ? "Home" : "Away")")
                    Text("💯 Score: UNC \(game.score.unc) - \(game.score.opponent)")
                }
            }
            .listStyle(.plain)
            .task {
                await loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        // Fetching URL
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
