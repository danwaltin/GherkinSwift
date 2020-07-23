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
//  Asserter.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-05.
//
// ------------------------------------------------------------------------
import XCTest
@testable import GherkinSwift

struct Asserter {
	let actualPickleResult: PickleResult
	
	func gherkinDocument(_ file: StaticString, _ line: UInt, assert: (GherkinDocument) -> Void ) {
		switch actualPickleResult {
		case .success(let document):
			assert(document)

		case .error(let error):
			let messages = error.map{$0.message}.asDescription()
			XCTFail("No gherkin document found. Parse error(-s) occurred with message '\(String(describing: messages))'", file: file, line: line)
		}
	}
	
	func feature(_ file: StaticString, _ line: UInt, assert: (Feature) -> Void ) {
		gherkinDocument(file, line) {
			guard let feature = $0.feature else {
				XCTFail("No feature found", file: file, line: line)
				return
			}
			
			assert(feature)
		}
	}
	
	func scenarios(withNames names: [String], _ file: StaticString, _ line: UInt) {
		feature(file, line) {
			let actualNames = $0.scenarios.map{ s in
				s.name
			}
			XCTAssertEqual(actualNames, names, file: file, line: line)
		}
	}

	func background(_ file: StaticString, _ line: UInt, assert: (Background) -> Void ) {
		feature(file, line) {
			guard let actualBackground = $0.background else {
				XCTFail("No background found", file: file, line: line)
				return
			}
			
			assert(actualBackground)
		}
	}
	
	func backgroundStep(atIndex index: Int, _ file: StaticString, _ line: UInt, stepAsserter: (Step) -> Void ) {
		background(file, line) {
			let steps = $0.steps
			if steps.count <= index {
				XCTFail("No step at index \(index). Number of steps: \(steps.count)", file: file, line: line)
				return
			}
			
			let actualStep = steps[index]
			
			stepAsserter(actualStep)
		}
	}
	
	func scenario(_ scenarioIndex: Int, _ file: StaticString, _ line: UInt, assert: (Scenario) -> Void) {
		feature(file, line) {
			let scenarios = $0.scenarios
			if scenarios.count <= scenarioIndex {
				XCTFail("No scenario at index \(scenarioIndex). Number of scenarios: \(scenarios.count)", file: file, line: line)
				return
			}
			
			assert(scenarios[scenarioIndex])
		}
	}
	
	func step(_ stepIndex: Int, forScenario scenarioIndex: Int, _ file: StaticString, _ line: UInt, assertStep: (Step) -> Void) {
		scenario(scenarioIndex, file, line) {
			let steps = $0.steps
			if steps.count <= stepIndex {
				XCTFail("No step at index \(stepIndex). Number of steps: \(steps.count)", file: file, line: line)
				return
			}
			
			let actualStep = steps[stepIndex]
			
			assertStep(actualStep)
		}
	}

	func stepTableParameter(stepIndex: Int, forScenario scenarioIndex: Int, _ file: StaticString, _ line: UInt, assertTableParameter: (Table) -> Void) {
		step(stepIndex, forScenario: scenarioIndex, file, line) {
			guard let table = $0.tableParameter else {
				XCTFail("No tableParameter for step \(stepIndex).", file: file, line: line)
				return
			}
			
			assertTableParameter(table)
		}
	}

	func stepDocStringParameter(stepIndex: Int, forScenario scenarioIndex: Int, _ file: StaticString, _ line: UInt, assertDocStringParameter: (DocString) -> Void) {
		step(stepIndex, forScenario: scenarioIndex, file, line) {
			guard let docString = $0.docStringParameter else {
				XCTFail("No docStringParameter for step \(stepIndex).", file: file, line: line)
				return
			}
			
			assertDocStringParameter(docString)
		}
	}
	
	func step(_ stepType: StepType,
			  _ text: String,
			  atIndex stepIndex: Int = 0,
			  forScenario scenarioIndex: Int = 0,
			  _ file: StaticString, _ line: UInt) {
		step(stepIndex, forScenario: scenarioIndex, file, line) {
			XCTAssertEqual($0.type, stepType, file: file, line: line)
			XCTAssertEqual($0.text, text, file: file, line: line)
		}
	}
	
	func step(_ stepType: StepType,
			  _ text: String,
			  _ table: Table,
			  atIndex stepIndex: Int = 0,
			  forScenario scenarioIndex: Int = 0,
			  _ file: StaticString, _ line: UInt) {
		step(stepIndex, forScenario: scenarioIndex, file, line) {
			XCTAssertEqual($0.type, stepType, file: file, line: line)
			XCTAssertEqual($0.text, text, file: file, line: line)
			
			if let actualTable = $0.tableParameter {
				XCTAssertEqual(actualTable.withoutLocation(), table, file: file, line: line)
			} else {
				XCTFail("No table parameter", file: file, line: line)
			}
		}
	}
	
	func step(_ stepType: StepType,
			  _ text: String,
			  _ docString: DocString,
			  atIndex stepIndex: Int = 0,
			  forScenario scenarioIndex: Int = 0,
			  _ file: StaticString, _ line: UInt) {
		step(stepIndex, forScenario: scenarioIndex, file, line) {
			XCTAssertEqual($0.type, stepType, file: file, line: line)
			XCTAssertEqual($0.text, text, file: file, line: line)
			
			if let actualDocSring = $0.docStringParameter {
				XCTAssertEqual(actualDocSring.withoutLocation(), docString, file: file, line: line)
			} else {
				XCTFail("No docString parameter", file: file, line: line)
			}
		}
	}
	
	func examples(_ examplesIndex: Int,
				  forScenario scenarioIndex: Int,
				  _ file: StaticString,
				  _ line: UInt,
				  assertExamples: (ScenarioOutlineExamples) -> Void) {
		scenario(scenarioIndex, file, line) {
			let examples = $0.examples
			if examples.count <= examplesIndex {
				XCTFail("No examples at index \(examplesIndex). Number of examples: \(examples.count)", file: file, line: line)
				return
			}
			
			let actualExamples = examples[examplesIndex]
			
			assertExamples(actualExamples)
		}
	}
	
}
