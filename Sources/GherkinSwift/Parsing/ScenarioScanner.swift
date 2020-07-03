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
//  ScenarioScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

class ScenarioScanner {
	var name = ""
	var isScanningDescription = false
	var descriptionLines = [String]()
	var lineNumber = 0
	var columnNumber = 0
	var isScanningStep = false
	var currentStepScanner: StepScanner!
	var stepScanners = [StepScanner]()
	
	let scenarioTags: [Tag]
	
	var isScanningExamples = false
	var currentExamplesScanner: ScenarioOutlineExamplesScanner!
	var examplesScanners = [ScenarioOutlineExamplesScanner]()

	var isScenarioOutline = false
	
	init(scenarioTags: [Tag]) {
		self.scenarioTags = scenarioTags
	}
	
	func scan(line: Line, _ commentCollector: CommentCollector) {
		
		if line.isScenario() {
			name = line.removeKeyword(keywordScenario)
			lineNumber = line.number
			columnNumber = line.columnForKeyword(keywordScenario)
			
		} else if line.isScenarioOutline() {
			isScenarioOutline = true
			name = line.removeKeyword(keywordScenarioOutline)
			lineNumber = line.number
			columnNumber = line.columnForKeyword(keywordScenarioOutline)

		} else if line.isStep() {
			isScanningDescription = false
			isScanningStep = true
			currentStepScanner = StepScanner()
			stepScanners += [currentStepScanner]
			
			currentStepScanner.scan(line: line)
			
		} else if line.isExamples() {
			isScanningExamples = true
			currentExamplesScanner = ScenarioOutlineExamplesScanner()
			examplesScanners += [currentExamplesScanner]
			
			currentExamplesScanner.scan(line: line)
			
		} else if isScanningExamples {
			currentExamplesScanner.scan(line: line)
			
		} else if line.isComment() {
			commentCollector.collectComment(line: line)

		} else if isScanningStep {
			currentStepScanner.scan(line: line)

		} else if isScanningDescription {
			descriptionLines.append(line.text)

		} else {
			if !isScanningDescription &&  !line.isEmpty() {
				isScanningDescription = true
				descriptionLines.append(line.text)
			}
		}
	}
	
	func getScenario() -> Scenario {
		return Scenario(name: name,
						description: descriptionLines.asDescription(),
						tags: tags(),
						location: location(),
						steps: steps(),
						examples: examples(),
						isScenarioOutline: isScenarioOutline)
	}

	private func tags() -> [Tag] {
		return scenarioTags
	}

	private func location() -> Location {
		return Location(column: columnNumber, line: lineNumber)
	}

	private func steps() -> [Step] {
		return stepScanners.map{$0.getStep()}
	}

	private func examples() -> [ScenarioOutlineExamples] {
		return examplesScanners.map{$0.getExamples()}
	}
}
