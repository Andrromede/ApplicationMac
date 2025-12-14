import Foundation

#if canImport(SwiftUI)
import SwiftUI

@main
struct TravelSavingsPlanApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
#else
@main
struct TravelSavingsPlanCLI {
    static func main() {
        let examplePlan = SavingsPlan(
            monthlyAmount: 300,
            durationMonths: 12,
            includeThirteenthMonth: true,
            thirteenthMonthIndex: 12,
            startDate: .init(),
            bonuses: [
                Bonus(name: "Prime vacances", amount: 450, date: .init())
            ]
        )
        let total = examplePlan.totalSaved()
        print("Plan d'épargne voyage")
        print("Montant total estimé : \(total) €")
    }
}
#endif
