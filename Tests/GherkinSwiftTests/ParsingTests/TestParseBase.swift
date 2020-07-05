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
	var actualFeature: Feature {
		return actualGherkinDocument.feature!
	}
	var actualGherkinDocument: GherkinDocument!
	
	func when_parsingDocument(_ document: String) {
		actualGherkinDocument = parseDocument(document, parser: parser())
	}

	func when_parsing(_ lines: [String]) {
		actualGherkinDocument = parseGherkinDocument(lines, parser: parser())
	}

	func parseGherkinDocument(_ lines: [String], parser: GherkinFeatureParser) -> GherkinDocument {
		return parser.pickle(lines: lines, fileUri: "").gherkinDocument
	}

	func parseDocument(_ document: String, parser: GherkinFeatureParser) -> GherkinDocument {
		let lines = document.allLines()
		return parseGherkinDocument(lines, parser: parser)
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
		return Table.withColumns([col])
			.addingRow(cells: [cell(r1c1, col)], location: Location.zero())
	}
	
	func table(_ col: String,
	           _ r1c1: String,
	           _ r2c1: String) -> Table {
		return Table.withColumns([col])
			.addingRow(cells: [cell(r1c1, col)], location: Location.zero())
			.addingRow(cells: [cell(r2c1, col)], location: Location.zero())
	}
	
	func table(_ c1: String, _ c2: String,
	           _ r1c1: String, _ r1c2: String) -> Table {
		return Table.withColumns([c1, c2])
			.addingRow(cells: [cell(r1c1, c1), cell(r1c2, c2)], location: Location.zero())
	}
	
	func table(_ c1: String, _ c2: String,
	           _ r1c1: String, _ r1c2: String,
	           _ r2c1: String, _ r2c2: String) -> Table {
		return Table.withColumns([c1, c2])
			.addingRow(cells: [cell(r1c1, c1), cell(r1c2, c2)], location: Location.zero())
			.addingRow(cells: [cell(r2c1, c1), cell(r2c2, c2)], location: Location.zero())
	}
	
	private func cell(_ value: String, _ header: String) -> TableCell {
		return TableCell(value: value, location: Location.zero(), header: header)
	}
	
	// MARK: - Assertions
	func assertBackground(_ file: StaticString, _ line: UInt, assertBackground: (Background) -> Void ) {
		guard let actualBackground = actualFeature.background else {
			XCTFail("No background found", file: file, line: line)
			return
		}
		
		assertBackground(actualBackground)
	}

	func assertBackgroundStep(atIndex index: Int, _ file: StaticString, _ line: UInt, assertStep: (Step) -> Void ) {
		assertBackground(file, line) {
			let steps = $0.steps
			if steps.count <= index {
				XCTFail("No step at index \(index). Number of steps: \(steps.count)", file: file, line: line)
				return
			}
			
			let actualStep = steps[index]
			
			assertStep(actualStep)
		}
	}

	func assertScenario(_ scenarioIndex: Int, _ file: StaticString, _ line: UInt, assert: (Scenario) -> Void) {
		let scenarios = actualFeature.scenarios
		if scenarios.count <= scenarioIndex {
			XCTFail("No scenario at index \(scenarioIndex). Number of scenarios: \(scenarios.count)", file: file, line: line)
			return
		}
		
		assert(scenarios[scenarioIndex])
	}
	
	func assertStep(_ stepIndex: Int, forScenario scenarioIndex: Int, _ file: StaticString, _ line: UInt, assert: (Step) -> Void) {
		assertScenario(scenarioIndex, file, line) {
			let steps = $0.steps
			if steps.count <= stepIndex {
				XCTFail("No step at index \(stepIndex). Number of steps: \(steps.count)", file: file, line: line)
				return
			}
			
			let actualStep = steps[stepIndex]
			
			assert(actualStep)
		}
	}

	func assertExamples(_ examplesIndex: Int,
						forScenario scenarioIndex: Int,
						_ file: StaticString,
						_ line: UInt,
						assert: (ScenarioOutlineExamples) -> Void) {
		assertScenario(scenarioIndex, file, line) {
			let examples = $0.examples
			if examples.count <= examplesIndex {
				XCTFail("No examples at index \(examplesIndex). Number of examples: \(examples.count)", file: file, line: line)
				return
			}
			
			let actualExamples = examples[examplesIndex]
			
			assert(actualExamples)
		}
	}
}

