//
//  CharacterDetailView.swift
//  RickAndMortyCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 29/07/26.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(statusColor(character.status).opacity(0.12))
                        .frame(width: 220, height: 220)

                    AsyncImage(url: URL(string: character.image)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(statusColor(character.status).opacity(0.4), lineWidth: 3)
                    )
                }
                .padding(.top, 8)

                VStack(spacing: 4) {
                    Text(character.name)
                        .font(.title2)
                        .bold()

                    HStack(spacing: 6) {
                        Circle()
                            .fill(statusColor(character.status))
                            .frame(width: 8, height: 8)
                        Text(character.status)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(spacing: 0) {
                    DetailRow(label: "Species", value: character.species)
                    Divider().padding(.leading)
                    DetailRow(label: "Gender", value: character.gender)
                    Divider().padding(.leading)
                    DetailRow(label: "Origin", value: character.origin.name)
                }
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
        }
        .background(statusColor(character.status).opacity(0.05))
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .bold()
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(character: RMCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            origin: RMCharacter.Origin(name: "Earth (C-137)")
        ))
    }
}
