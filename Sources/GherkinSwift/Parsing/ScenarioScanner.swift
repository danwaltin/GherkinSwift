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
	enum State {
		case started
		case scanningScenario
		case scanningSteps
		case scanningExamples
		case foundNextExamplesTags
	}

	private var state: State = .started
	private var location = Location.zero()

	private var parseErrors = [ParseError]()
	private var keyword: Keyword = Keyword.none()
	private var name = ""
	private var descriptionLines = [String]()
	
	private let examplesTagScanner: TagScanner
	private let stepScannerFactory: StepScannerFactory
	private var stepScanners = [StepScanner]()
	private let examplesScannerFactory: ExamplesScannerFactory
	private var examplesScanners = [ExamplesScanner]()

	private let tags: [Tag]

	private var isScenarioOutline = false
	
	init(tags: [Tag],
		 stepScannerFactory: StepScannerFactory,
		 examplesTagScanner: TagScanner,
		 examplesScannerFactory: ExamplesScannerFactory) {
		
		self.tags = tags
		self.stepScannerFactory = stepScannerFactory
		self.examplesTagScanner = examplesTagScanner
		self.examplesScannerFactory = examplesScannerFactory
	}
	
	class func lineBelongsToNextScenario(_ line: Line, allLines: [Line]) -> Bool {
		if line.hasKeyword(.tag) , let next = nextLineWithKeyword(currentLine: line, allLines: allLines) {
			return next.hasKeyword(.scenario) || next.hasKeyword(.scenarioOutline)
		}
		return false
	}
	
	private class func nextLineWithKeyword(currentLine: Line, allLines: [Line]) -> Line? {
		let nextIndex = currentLine.number
		let lastIndex = allLines.count - 1
		
		for i in nextIndex...lastIndex {
			let line = allLines[i]
			if line.hasKeyword(.scenario) || line.hasKeyword(.scenarioOutline) || line.hasKeyword(.examples) {
				return line
			}
		}
		
		return nil
	}
	
	func scan(_ line: Line, fileUri: String) {
		switch state {
		case .started:
			if line.hasKeyword(.scenario) || line.hasKeyword(.scenarioOutline) {
				name = line.keywordRemoved()
				keyword = line.keyword
				
				isScenarioOutline = line.hasKeyword(.scenarioOutline)
				location = line.keywordLocation()
				examplesTagScanner.clear()
				state = .scanningScenario
			}

		case .scanningScenario:
			if line.hasKeyword(.tag) {
				examplesTagScanner.scan(line)
				state = .foundNextExamplesTags

			} else if shouldStartNewStep(line) {
				startNewStep(line)
				
			} else if shouldStartNewExamples(line) {
				startNewExamples(line, fileUri: fileUri)

			} else {
				descriptionLines.append(line.text)
			}

		case .scanningSteps:
			if line.hasKeyword(.tag) {
				examplesTagScanner.scan(line)
				state = .foundNextExamplesTags

			} else if shouldStartNewStep(line) {
				startNewStep(line)

			} else if shouldStartNewExamples(line) {
				startNewExamples(line, fileUri: fileUri)

			} else if !currentStepScanner.lineBelongsToStep(line) {
				let tags = "#EOF, #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty"
				parseErrors.append(
					ParseError.invalidGherkin(tags, atLine: line, inFile: fileUri))

			} else {
				scanStep(line)
			}
			
		case .scanningExamples:
			if line.hasKeyword(.tag) {
				examplesTagScanner.scan(line)
				state = .foundNextExamplesTags

			} else if shouldStartNewExamples(line) {
				startNewExamples(line, fileUri: fileUri)

			} else {
				scanExamples(line, fileUri: fileUri)
			}

		case .foundNextExamplesTags:
			if line.hasKeyword(.tag) {
				examplesTagScanner.scan(line)

			} else if shouldStartNewExamples(line) {
				startNewExamples(line, fileUri: fileUri)

			} else if !line.isEmpty()  {
				let expected = "#TagLine, #ExamplesLine, #ScenarioLine, #RuleLine, #Comment, #Empty"

				parseErrors.append(
					ParseError.withExpectedTags(expected, atLine: line, inFile: fileUri))
				
			}
		}
	}
	
	private func shouldStartNewStep(_ line: Line) -> Bool {
		return line.isStep()
	}
	
	private func startNewStep(_ line: Line) {
		stepScanners.append(stepScannerFactory.stepScanner())
		
		scanStep(line)
		
		state = .scanningSteps
	}
	
	private func scanStep(_ line: Line) {
		currentStepScanner.scan(line)
	}
	
	private var currentStepScanner: StepScanner {
		return stepScanners.last!
	}

	private func scanExamples(_ line: Line, fileUri: String) {
		examplesScanners.last!.scan(line, fileUri: fileUri)
	}
	
	private func shouldStartNewExamples(_ line: Line) -> Bool {
		return line.hasKeyword(.examples)
	}
	
	private func startNewExamples(_ line: Line, fileUri: String) {
		let scanner = examplesScannerFactory.examplesScanner(tags: examplesTagScanner.getTags())
		examplesScanners.append(scanner)
		examplesTagScanner.clear()

		scanExamples(line, fileUri: fileUri)

		state = .scanningExamples
	}
	
	func getScenario() -> (scenario: Scenario, errors: [ParseError])  {
		
		let examplesWithScenarioParseErrors = examplesScanners.map { $0.getExamples() }
		let examples = examplesWithScenarioParseErrors.map { $0.examples }
		let examplesParseErrors = examplesWithScenarioParseErrors.flatMap { $0.errors }

		parseErrors.append(contentsOf: examplesParseErrors)
		
		let scenario = Scenario(name: name,
								description: descriptionLines.asDescription(),
								tags: tags,
								location: location,
								steps: steps(),
								examples: examples,
								isScenarioOutline: isScenarioOutline,
								localizedKeyword: keyword.localized)

		return (scenario, parseErrors)
	}

	private func steps() -> [Step] {
		return stepScanners.map{$0.getStep()}
	}
}
