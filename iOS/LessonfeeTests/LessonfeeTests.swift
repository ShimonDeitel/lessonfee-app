import XCTest
@testable import Lessonfee

@MainActor
final class LessonfeeTests: XCTestCase {
    func testSeedDataLoadsBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddEntryIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(SessionEntry(title: "Test", vendor: "V", amount: 10, date: Date()))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWithoutPro() {
        let store = Store()
        while store.entries.count < Store.freeLimit {
            store.add(SessionEntry(title: "Filler", vendor: "V", amount: 1, date: Date()))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProUnlockAllowsMoreThanLimit() {
        let store = Store()
        store.isProUnlocked = true
        while store.entries.count < Store.freeLimit {
            store.add(SessionEntry(title: "Filler", vendor: "V", amount: 1, date: Date()))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteEntryRemovesIt() {
        let store = Store()
        let entry = SessionEntry(title: "ToDelete", vendor: "V", amount: 5, date: Date())
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(entry))
    }

    func testUpdateEntryChangesFields() {
        let store = Store()
        var entry = SessionEntry(title: "Original", vendor: "V", amount: 5, date: Date())
        store.add(entry)
        entry.title = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.title, "Updated")
    }

    func testTotalSpentSumsAmounts() {
        let store = Store()
        let total = store.entries.reduce(0) { $0 + $1.amount }
        XCTAssertEqual(store.totalSpent, total, accuracy: 0.001)
    }
}
