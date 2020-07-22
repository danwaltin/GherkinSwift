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
//  BackgroundScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-04.
//
// ------------------------------------------------------------------------

class BackgroundScanner {
	enum State {
		case started
		case scanningBackground
		case scanningSteps
	}

	private var state: State = .started
	private var location = Location.zero()

	private var parseErrors = [ParseError]()

	private var name = ""
	private var descriptionLines = [String]()
	
	let stepScannerFactory: StepScannerFactory
	private var stepScanners = [StepScanner]()
	
	init(stepScannerFactory: StepScannerFactory) {
		self.stepScannerFactory = stepScannerFactory
	}
	
	func scan(_ line: Line, fileUri: String) {
		switch state {
		case .started:
			if line.hasKeyword(.background) {
				name = line.keywordRemoved()
				location = line.keywordLocation()
				state = .scanningBackground
			}

		case .scanningBackground:
			if shouldStartNewStep(line) {
				startNewStep(line)
				
			} else {
				descriptionLines.append(line.text)
			}

		case .scanningSteps:
			if shouldStartNewStep(line) {
				startNewStep(line)

			} else if !currentStepScanner().lineBelongsToStep(line) {
				let tags = "#EOF, #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty"
				parseErrors.append(
					ParseError.invalidGherkin(tags, atLine: line, inFile: fileUri))
			} else {
				scanStep(line)
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
		currentStepScanner().scan(line)
	}
	
	private func currentStepScanner() -> StepScanner {
		return stepScanners.last!
	}
	func getBackground() -> (background: Background?, errors: [ParseError]) {
		if state == .started {
			return (nil, parseErrors)
		}

		let background = Background(name: name,
									steps: steps(),
									description: descriptionLines.asDescription(),
									location: location)

		return (background, parseErrors)
	}

	private func steps() -> [Step] {
		return stepScanners.map{$0.getStep()}
	}
}
