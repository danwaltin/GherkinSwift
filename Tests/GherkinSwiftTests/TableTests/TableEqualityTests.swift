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
//  TableEqualityTests.swift
//  GherkinSwiftSpec
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class TableEqualityTests : XCTestCase {
	func test_equalWhenTwoColumns() {
		let one = t(["alpha", "beta"])
		let two = t(["alpha", "beta"])
		
		XCTAssertEqual(one, two)
	}
	
	func test_notEqualWhenTwoColumns() {
		let one = t(["alpha", "beta"])
		let two = t(["alpha", "gamma"])
		
		XCTAssertNotEqual(one, two)
	}
	
	func test_equalWhenTwoRows() {
		let one = t(["column"])
			.addingRowWithCellValues(["alpha"])
			.addingRowWithCellValues(["beta"])
		
		let two = t(["column"])
			.addingRowWithCellValues(["alpha"])
			.addingRowWithCellValues(["beta"])
		
		XCTAssertEqual(one, two)
	}
	
	func test_notEqualWhenTwoRows_differentColumnNames() {
		let one = t(["column"])
			.addingRowWithCellValues(["alpha"])
			.addingRowWithCellValues(["beta"])
		
		let two = t(["another column"])
			.addingRowWithCellValues(["alpha"])
			.addingRowWithCellValues(["beta"])
		
		XCTAssertNotEqual(one, two)
	}
	
	func test_notEqualWhenTwoRows_differentRowValuesSecondRow() {
		let one = t(["column"])
			.addingRowWithCellValues(["alpha"])
			.addingRowWithCellValues(["beta"])
		
		let two = t(["column"])
			.addingRowWithCellValues(["alpha"])
			.addingRowWithCellValues(["gamma"])
		
		XCTAssertNotEqual(one, two)
	}
	
	private func t(_ columns: [String]) -> Table {
		return Table(columns: columns, headerLocation: Location.zero())
	}

}
