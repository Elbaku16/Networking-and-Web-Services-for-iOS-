//
//  CharacterListView.swift
//  RickAndMortyCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 29/07/26.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterViewModel = CharacterViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading characters...")
                } else if !viewModel.errorMessage.isEmpty {
                    VStack(spacing: 12) {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                        Button("Retry") {
                            viewModel.fetchCharacters()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(viewModel.characters) { character in
                        NavigationLink(destination: CharacterDetailView(character: character)) {
                            HStack(spacing: 14) {
                                AsyncImage(url: URL(string: character.image)) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color(.systemGray5)
                                }
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(character.name)
                                        .font(.headline)

                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(statusColor(character.status))
                                            .frame(width: 8, height: 8)
                                        Text("\(character.status) · \(character.species)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Characters")
            .onAppear {
                if viewModel.characters.isEmpty {
                    viewModel.fetchCharacters()
                }
            }
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}

#Preview {
    CharacterListView()
}
