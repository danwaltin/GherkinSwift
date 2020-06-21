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
//  TestParseBase.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

class TestParseBase: XCTestCase {
	var actualFeature: Feature!

	func when_parsingFeature(_ lines: [String]) {
		actualFeature = parser().parse(lines: lines)
	}
	
	func then_shouldReturnScenariosWithNames(_ names: [String]) {
		let actualNames = scenarios().map{ s in
			s.name
		}
		XCTAssertEqual(actualNames, names)
	}

	func parser() -> GherkinFeatureParser {
		return GherkinFeatureParser()
	}
	
	func scenarios() -> [Scenario] {
		return actualFeature.scenarios
	}
	
	func scenario(at index: Int) -> Scenario {
		return scenarios()[index]
	}

	// MARK: - Factory methods
	func table(_ col: String,
	           _ r1c1: String) -> Table {
		return Table(columns: [col])
			.addingRow(cells: [r1c1])
	}
	
	func table(_ col: String,
	           _ r1c1: String,
	           _ r2c1: String) -> Table {
		return Table(columns: [col])
			.addingRow(cells: [r1c1])
			.addingRow(cells: [r2c1])
	}
	
	func table(_ c1: String, _ c2: String,
	           _ r1c1: String, _ r1c2: String) -> Table {
		return Table(columns: [c1, c2])
			.addingRow(cells: [r1c1, r1c2])
	}
	
	func table(_ c1: String, _ c2: String,
	           _ r1c1: String, _ r1c2: String,
	           _ r2c1: String, _ r2c2: String) -> Table {
		return Table(columns: [c1, c2])
			.addingRow(cells: [r1c1, r1c2])
			.addingRow(cells: [r2c1, r2c2])
	}
}

