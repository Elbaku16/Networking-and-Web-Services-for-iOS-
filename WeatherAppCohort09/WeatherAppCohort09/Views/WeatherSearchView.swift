//
//  WeatherSearchView.swift
//  WeatherAppCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import SwiftUI

struct WeatherSearchView: View {
    @StateObject var viewModel: WeatherViewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    TextField("Search city (e.g. Tijuana)", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()

                    Button("Search") {
                        viewModel.search()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                Group {
                    switch viewModel.viewState {
                    case .idle:
                        Text("Search a city to see the weather")
                            .foregroundStyle(.secondary)

                    case .loading:
                        ProgressView("Loading...")

                    case .failed:
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundStyle(.orange)
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                        .padding()

                    case .success:
                        VStack(spacing: 16) {
                            Text(viewModel.locationName)
                                .font(.title2)
                                .bold()

                            Text("\(String(format: "%.1f", viewModel.temperature))°C")
                                .font(.system(size: 50, weight: .bold))

                            Text(viewModel.weatherCondition)
                                .font(.title3)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 30) {
                                VStack {
                                    Image(systemName: "humidity")
                                    Text("\(String(format: "%.0f", viewModel.humidity))%")
                                    Text("Humidity").font(.caption).foregroundStyle(.secondary)
                                }
                                VStack {
                                    Image(systemName: "wind")
                                    Text("\(String(format: "%.1f", viewModel.windSpeed)) km/h")
                                    Text("Wind").font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Weather")
        }
    }
}

#Preview {
    WeatherSearchView()
}
