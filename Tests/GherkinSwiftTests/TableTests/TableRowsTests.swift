// ------------------------------------------------------------------------
// Copyright 2020 Dan Waltin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ------------------------------------------------------------------------
//
//  TableRowsTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class TableRowsTests : XCTestCase {
	// MARK: - Adding row with values
	func test_oneColumn_addOneRowWithValue() {
		let table = t(["Column"])
			.addingRowWithCellValues(["rowValue"])
		
		XCTAssertEqual(table.rows.count, 1)
		XCTAssertEqual(table.columns.count, 1)

		XCTAssertEqual(table.rows[0]["Column"], cell("rowValue"))
	}

	func test_twoColumns_addOneRowWithValues() {
		let table = t(["c1", "c2"])
			.addingRowWithCellValues(["v1", "v2"])
		
		XCTAssertEqual(table.rows.count, 1)
		XCTAssertEqual(table.columns.count, 2)

		XCTAssertEqual(table.rows[0]["c1"], cell("v1"))
		XCTAssertEqual(table.rows[0]["c2"], cell("v2"))
	}

	func test_oneColumns_addTwoRowsWithValue() {
		let table = t(["c"])
			.addingRowWithCellValues(["v1"])
			.addingRowWithCellValues(["v2"])
		
		XCTAssertEqual(table.rows.count, 2)
		XCTAssertEqual(table.columns.count, 1)

		XCTAssertEqual(table.rows[0]["c"], cell("v1"))
		XCTAssertEqual(table.rows[1]["c"], cell("v2"))
	}

	func test_twoColumns_addTwoRowsWithValues() {
		let table = t(["c1", "c2"])
			.addingRowWithCellValues(["r1c1", "r1c2"])
			.addingRowWithCellValues(["r2c1", "r2c2"])
		
		XCTAssertEqual(table.rows.count, 2)
		XCTAssertEqual(table.columns.count, 2)

		XCTAssertEqual(table.rows[0]["c1"], cell("r1c1"))
		XCTAssertEqual(table.rows[0]["c2"], cell("r1c2"))
		XCTAssertEqual(table.rows[1]["c1"], cell("r2c1"))
		XCTAssertEqual(table.rows[1]["c2"], cell("r2c2"))
	}
	
	// MARK: - Adding row as key/value-pairs
	func test_oneColumnOneRow_addOneRowWithKeyValue() {
		let table = t(["Column"])
			.addingRow(cells: ["Column": cell("rowValue")])
		
		XCTAssertEqual(table.rows.count, 1)
		XCTAssertEqual(table.columns.count, 1)

		XCTAssertEqual(table.rows[0]["Column"], cell("rowValue"))
	}


	func test_twoColumns_addOneRowWithKeyValues() {
		let table = t(["c1", "c2"])
			.addingRow(cells: ["c1": cell("v1"), "c2": cell("v2")])
		
		XCTAssertEqual(table.rows.count, 1)
		XCTAssertEqual(table.columns.count, 2)

		XCTAssertEqual(table.rows[0]["c1"], cell("v1"))
		XCTAssertEqual(table.rows[0]["c2"], cell("v2"))
	}

	func test_oneColumn_addTwoRowsWithKeyValues() {
		let table = t(["c"])
			.addingRow(cells: ["c": cell("v1")])
			.addingRow(cells: ["c": cell("v2")])
		
		XCTAssertEqual(table.rows[0]["c"], cell("v1"))
		XCTAssertEqual(table.rows[1]["c"], cell("v2"))
	}

	func test_twoColumns_addTwoRowsWithKeyValues() {
		let table = t(["c1", "c2"])
			.addingRow(cells: ["c1": cell("r1c1"), "c2": cell("r1c2")])
			.addingRow(cells: ["c1": cell("r2c1"), "c2": cell("r2c2")])
		
		XCTAssertEqual(table.rows.count, 2)
		XCTAssertEqual(table.columns.count, 2)
		
		XCTAssertEqual(table.rows[0]["c1"], cell("r1c1"))
		XCTAssertEqual(table.rows[0]["c2"], cell("r1c2"))
		XCTAssertEqual(table.rows[1]["c1"], cell("r2c1"))
		XCTAssertEqual(table.rows[1]["c2"], cell("r2c2"))
	}
	
	private func cell(_ value: String) -> TableCell {
		return TableCell(value: value, location: Location.zero())
	}
	
	private func t(_ columns: [String]) -> Table {
		return Table(columns: columns, headerLocation: Location.zero())
	}

}
