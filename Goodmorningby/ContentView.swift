import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PlayerViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Stavi pensando a")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView("Ricerca nell'archivio azzurro...")
                        .frame(height: 460)
                } else if let playerName = viewModel.currentPlayerName {
                    VStack(spacing: 16) {
                        
                        AsyncImage(url: URL(string: viewModel.wikiData?.thumbnail?.source ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 140, height: 140)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                                    .shadow(radius: 6)
                            case .failure(_):
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 140, height: 140)
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(.blue)
                                }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(.top, 8)
                        
                        Text(playerName)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 8) {
                            Image("Image")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                            
                            Text("Calcio Napoli")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                        
                        Divider()
                            .padding(.horizontal, 20)
                        
                        if let extract = viewModel.wikiData?.extract {
                            Text(extract)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(6)
                                .padding(.horizontal, 12)
                        } else {
                            Text("Scheda biografica non disponibile.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 40) // Più respiro verticale interno
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 460) // Rende la card visibilmente rettangolare
                    .background(Color.blue.opacity(0.09))
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                } else {
                    ContentUnavailableView("Nessun Giocatore",
                                           systemImage: "person.fill.questionmark",
                                           description: Text("Premi il pulsante in basso per estrarre un giocatore."))
                    .frame(height: 460)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.getRandomPlayer()
                    }
                }) {
                    HStack {
                        Image(systemName: "dice.fill")
                        Text("Estrai Giocatore Casuale")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(14)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
