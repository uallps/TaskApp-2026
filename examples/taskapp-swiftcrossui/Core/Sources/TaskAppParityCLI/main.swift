import Foundation
import TaskAppCore

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
do {
    let data = try encoder.encode(runTaskParityScenario())
    guard let text = String(data: data, encoding: .utf8) else {
        fatalError("The parity report was not UTF-8")
    }
    print(text)
} catch {
    fatalError("Could not encode parity report: \(error)")
}
