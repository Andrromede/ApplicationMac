import Foundation

#if canImport(SwiftUI)
import SwiftUI

final class SavingsPlanViewModel: ObservableObject {
    @Published var plan: SavingsPlan
    @Published var newBonusName: String = "Prime"
    @Published var newBonusAmount: String = "500"
    @Published var newBonusDate: Date = .init()

    init(plan: SavingsPlan = .init()) {
        self.plan = plan
    }

    var formattedTotal: String {
        formatCurrency(value: plan.totalSaved())
    }

    var projectedEndDate: Date? {
        Calendar.current.date(byAdding: .month, value: plan.durationMonths, to: plan.startDate)
    }

    func addBonus() {
        guard let amount = Double(newBonusAmount) else { return }
        let bonus = Bonus(name: newBonusName.isEmpty ? "Prime" : newBonusName, amount: amount, date: newBonusDate)
        plan.bonuses.append(bonus)
        resetBonusForm()
    }

    func removeBonuses(at offsets: IndexSet) {
        plan.bonuses.remove(atOffsets: offsets)
    }

    func schedule() -> [PaymentEvent] {
        plan.schedule()
    }

    func formatCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "€\(value)"
    }

    private func resetBonusForm() {
        newBonusName = "Prime"
        newBonusAmount = "500"
        newBonusDate = .init()
    }
}
#endif
