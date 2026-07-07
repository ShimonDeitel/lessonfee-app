import Foundation

struct SessionEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var vendor: String
    var amount: Double
    var date: Date
    var notes: String = ""

    static func == (lhs: SessionEntry, rhs: SessionEntry) -> Bool {
        lhs.id == rhs.id
    }
}
