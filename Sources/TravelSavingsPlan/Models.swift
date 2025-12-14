import Foundation

struct Bonus: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var amount: Double
    var date: Date
}

struct PaymentEvent: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var label: String
    var amount: Double
}

struct SavingsPlan {
    var monthlyAmount: Double
    var durationMonths: Int
    var includeThirteenthMonth: Bool
    var thirteenthMonthIndex: Int
    var startDate: Date
    var bonuses: [Bonus] = []

    init(monthlyAmount: Double = 300, durationMonths: Int = 12, includeThirteenthMonth: Bool = false, thirteenthMonthIndex: Int = 12, startDate: Date = .init(), bonuses: [Bonus] = []) {
        self.monthlyAmount = monthlyAmount
        self.durationMonths = durationMonths
        self.includeThirteenthMonth = includeThirteenthMonth
        self.thirteenthMonthIndex = thirteenthMonthIndex
        self.startDate = startDate
        self.bonuses = bonuses
    }

    func schedule(calendar: Calendar = .current) -> [PaymentEvent] {
        var events: [PaymentEvent] = []

        for monthOffset in 0..<durationMonths {
            guard let contributionDate = calendar.date(byAdding: .month, value: monthOffset, to: startDate) else { continue }
            let monthNumber = (monthOffset % 12) + 1
            let baseLabel = "Mois \(monthOffset + 1)"
            events.append(PaymentEvent(date: contributionDate, label: baseLabel, amount: monthlyAmount))

            if includeThirteenthMonth && monthNumber == thirteenthMonthIndex {
                events.append(PaymentEvent(date: contributionDate, label: "13ᵉ mois", amount: monthlyAmount))
            }
        }

        for bonus in bonuses {
            events.append(PaymentEvent(date: bonus.date, label: bonus.name, amount: bonus.amount))
        }

        return events.sorted { lhs, rhs in
            if lhs.date == rhs.date {
                return lhs.label < rhs.label
            }
            return lhs.date < rhs.date
        }
    }

    func totalSaved(calendar: Calendar = .current) -> Double {
        schedule(calendar: calendar).reduce(0) { $0 + $1.amount }
    }
}
