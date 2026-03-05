import XCTest
import simd
@testable import Colorblinds

final class ColorBlindTypeTests: XCTestCase {

    // MARK: - Matrix Properties

    func testAllMatrixRowsSumToApproximatelyOne() {
        for type in ColorBlindType.allCases {
            let m = type.matrix
            let rows = [m.0, m.1, m.2]
            for (index, row) in rows.enumerated() {
                let sum = row.x + row.y + row.z
                XCTAssertEqual(
                    Double(sum), 1.0, accuracy: 0.01,
                    "\(type.displayName) row \(index) sums to \(sum), expected ~1.0"
                )
            }
        }
    }

    func testAllMatrixCoefficientsAreInValidRange() {
        for type in ColorBlindType.allCases {
            let m = type.matrix
            let rows = [m.0, m.1, m.2]
            for (index, row) in rows.enumerated() {
                for (component, value) in [("x", row.x), ("y", row.y), ("z", row.z)] {
                    XCTAssertGreaterThanOrEqual(
                        value, 0.0,
                        "\(type.displayName) row \(index).\(component) is \(value), expected >= 0"
                    )
                    XCTAssertLessThanOrEqual(
                        value, 1.0,
                        "\(type.displayName) row \(index).\(component) is \(value), expected <= 1"
                    )
                }
            }
        }
    }

    func testPureWhiteMapsToWhite() {
        let white = SIMD3<Float>(1.0, 1.0, 1.0)
        for type in ColorBlindType.allCases {
            let m = type.matrix
            let r = simd_dot(m.0, white)
            let g = simd_dot(m.1, white)
            let b = simd_dot(m.2, white)
            XCTAssertEqual(
                Double(r), 1.0, accuracy: 0.01,
                "\(type.displayName) white.r = \(r)"
            )
            XCTAssertEqual(
                Double(g), 1.0, accuracy: 0.01,
                "\(type.displayName) white.g = \(g)"
            )
            XCTAssertEqual(
                Double(b), 1.0, accuracy: 0.01,
                "\(type.displayName) white.b = \(b)"
            )
        }
    }

    // MARK: - CIVectors

    func testCIVectorsMatchMatrix() {
        for type in ColorBlindType.allCases {
            let m = type.matrix
            let v = type.ciVectors
            XCTAssertEqual(Float(v.rVector.x), m.0.x, accuracy: 0.0001)
            XCTAssertEqual(Float(v.rVector.y), m.0.y, accuracy: 0.0001)
            XCTAssertEqual(Float(v.rVector.z), m.0.z, accuracy: 0.0001)
            XCTAssertEqual(Float(v.rVector.w), 0.0, accuracy: 0.0001)

            XCTAssertEqual(Float(v.gVector.x), m.1.x, accuracy: 0.0001)
            XCTAssertEqual(Float(v.gVector.y), m.1.y, accuracy: 0.0001)
            XCTAssertEqual(Float(v.gVector.z), m.1.z, accuracy: 0.0001)
            XCTAssertEqual(Float(v.gVector.w), 0.0, accuracy: 0.0001)

            XCTAssertEqual(Float(v.bVector.x), m.2.x, accuracy: 0.0001)
            XCTAssertEqual(Float(v.bVector.y), m.2.y, accuracy: 0.0001)
            XCTAssertEqual(Float(v.bVector.z), m.2.z, accuracy: 0.0001)
            XCTAssertEqual(Float(v.bVector.w), 0.0, accuracy: 0.0001)
        }
    }

    // MARK: - Metadata

    func testAllCasesHaveDisplayName() {
        for type in ColorBlindType.allCases {
            XCTAssertFalse(type.displayName.isEmpty, "\(type) has empty displayName")
        }
    }

    func testAllCasesHaveDescription() {
        for type in ColorBlindType.allCases {
            XCTAssertFalse(type.description.isEmpty, "\(type) has empty description")
        }
    }

    func testAllCasesCount() {
        XCTAssertEqual(ColorBlindType.allCases.count, 8)
    }

    func testIdentifiableConformance() {
        for type in ColorBlindType.allCases {
            XCTAssertEqual(type.id, type.rawValue)
        }
    }
}
