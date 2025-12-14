#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: SavingsPlanViewModel

    var body: some View {
        NavigationStack {
            Form {
                contributionSection
                thirteenthMonthSection
                bonusSection
                summarySection
                scheduleSection
            }
            .navigationTitle("Plan d'épargne voyage")
        }
        .frame(minWidth: 900, minHeight: 650)
    }

    private var contributionSection: some View {
        Section("Contribution mensuelle") {
            HStack {
                Text("Montant par mois")
                Spacer()
                TextField("Montant", value: $viewModel.plan.monthlyAmount, format: .currency(code: "EUR"))
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 220)
            }

            Stepper(value: $viewModel.plan.durationMonths, in: 1...120) {
                Text("Durée : \(viewModel.plan.durationMonths) mois")
            }

            DatePicker("Date de départ de l'épargne", selection: $viewModel.plan.startDate, displayedComponents: .date)
        }
    }

    private var thirteenthMonthSection: some View {
        Section("13ᵉ mois") {
            Toggle("J'ai un 13ᵉ mois", isOn: $viewModel.plan.includeThirteenthMonth)

            if viewModel.plan.includeThirteenthMonth {
                Picker("Mois de versement", selection: $viewModel.plan.thirteenthMonthIndex) {
                    ForEach(1...12, id: \.self) { month in
                        Text("Mois \(month)").tag(month)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var bonusSection: some View {
        Section("Primes et bonus") {
            VStack(alignment: .leading, spacing: 8) {
                TextField("Nom", text: $viewModel.newBonusName)
                TextField("Montant", text: $viewModel.newBonusAmount)
                    .keyboardType(.decimalPad)
                DatePicker("Date de versement", selection: $viewModel.newBonusDate, displayedComponents: .date)
                Button("Ajouter la prime") {
                    viewModel.addBonus()
                }
                .buttonStyle(.borderedProminent)
            }

            if viewModel.plan.bonuses.isEmpty {
                Text("Aucune prime ajoutée pour le moment.")
                    .foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(viewModel.plan.bonuses) { bonus in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(bonus.name)
                                    .font(.headline)
                                Text(bonus.date, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(viewModel.formatCurrency(value: bonus.amount))
                                .bold()
                        }
                    }
                    .onDelete(perform: viewModel.removeBonuses)
                }
                .frame(minHeight: 120, maxHeight: 200)
            }
        }
    }

    private var summarySection: some View {
        Section("Synthèse") {
            HStack {
                Label("Total projeté", systemImage: "sum")
                Spacer()
                Text(viewModel.formattedTotal).bold()
            }

            if let endDate = viewModel.projectedEndDate {
                HStack {
                    Label("Fin de l'épargne", systemImage: "calendar")
                    Spacer()
                    Text(endDate, style: .date)
                }
            }
        }
    }

    private var scheduleSection: some View {
        Section("Calendrier des versements") {
            if viewModel.schedule().isEmpty {
                Text("Aucun versement planifié.")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.schedule()) { event in
                            HStack {
                                Text(event.date, style: .date)
                                    .frame(width: 120, alignment: .leading)
                                Text(event.label)
                                Spacer()
                                Text(viewModel.formatCurrency(value: event.amount))
                                    .bold()
                            }
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.08))
                            )
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 260)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: .init())
}
#endif
