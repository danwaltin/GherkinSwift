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

	private var name = ""
	private var descriptionLines = [String]()
	
	private var examplesTagScanner = TagScanner()
	
	private var currentStepScanner: StepScanner!
	private var stepScanners = [StepScanner]()
	
	private let scenarioTags: [Tag]
	
	private var currentExamplesScanner: ScenarioOutlineExamplesScanner!
	private var examplesScanners = [ScenarioOutlineExamplesScanner]()

	private var isScenarioOutline = false
	
	init(scenarioTags: [Tag]) {
		self.scenarioTags = scenarioTags
	}
	
	func scan(_ line: Line, _ commentCollector: CommentCollector) {
		scanNewWay(line, commentCollector)
	}

	private func scanNewWay(_ line: Line, _ commentCollector: CommentCollector) {
		switch state {
		case .started:
			if line.isScenario() || line.isScenarioOutline() {
				isScenarioOutline = line.isScenarioOutline()
				let keyword = isScenarioOutline ? keywordScenarioOutline : keywordScenario
				name = line.removeKeyword(keyword)
				location = Location(column: line.columnForKeyword(keyword) , line: line.number)
				examplesTagScanner.clear()
				state = .scanningScenario
			}

		case .scanningScenario:
			if line.isTag() {
				examplesTagScanner.scan(line)
				state = .foundNextExamplesTags

			} else if shouldStartNewStep(line) {
				startNewStep(line, commentCollector)
				
			} else if shouldStartNewExamples(line) {
				startNewExamples(line, commentCollector)

			} else if line.isComment() {
				commentCollector.collectComment(line)

			} else {
				descriptionLines.append(line.text)
			}

		case .scanningSteps:
			if shouldStartNewStep(line) {
				startNewStep(line, commentCollector)

			} else if shouldStartNewExamples(line) {
				startNewExamples(line, commentCollector)

			} else {
				currentStepScanner.scan(line, commentCollector)
			}
			
		case .scanningExamples:
			if shouldStartNewExamples(line) {
				startNewExamples(line, commentCollector)

			} else {
				currentExamplesScanner.scan(line)
			}

		case .foundNextExamplesTags:
			if line.isTag() {
				examplesTagScanner.scan(line)

			} else if shouldStartNewExamples(line) {
				startNewExamples(line, commentCollector)

			}
		}
	}
	
	private func shouldStartNewStep(_ line: Line) -> Bool {
		return line.isStep()
	}
	
	private func startNewStep(_ line: Line, _ commentsCollector: CommentCollector) {
		currentStepScanner = StepScanner()
		stepScanners.append(currentStepScanner)
		
		currentStepScanner.scan(line, commentsCollector)
		
		state = .scanningSteps
	}
	
	private func shouldStartNewExamples(_ line: Line) -> Bool {
		return line.isExamples()
	}
	
	private func startNewExamples(_ line: Line, _ commentCollector: CommentCollector) {
		currentExamplesScanner = ScenarioOutlineExamplesScanner()
		examplesTagScanner.clear()
		examplesScanners += [currentExamplesScanner]

		currentExamplesScanner.scan(line)

		state = .scanningExamples
	}
	
	func getScenario() -> Scenario {
		return Scenario(name: name,
						description: descriptionLines.asDescription(),
						tags: tags(),
						location: location,
						steps: steps(),
						examples: examples(),
						isScenarioOutline: isScenarioOutline)
	}

	private func tags() -> [Tag] {
		return scenarioTags
	}

	private func steps() -> [Step] {
		return stepScanners.map{$0.getStep()}
	}

	private func examples() -> [ScenarioOutlineExamples] {
		return examplesScanners.map{$0.getExamples()}
	}
}
