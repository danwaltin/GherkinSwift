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

	private var name = ""
	private var descriptionLines = [String]()
	
	private var currentStepScanner: StepScanner!
	private var stepScanners = [StepScanner]()
	
	func scan(_ line: Line, _ commentCollector: CommentCollector) {
		switch state {
		case .started:
			if line.isBackground() {
				name = line.removeKeyword(keywordBackground)
				location = Location(column: line.columnForKeyword(keywordBackground) , line: line.number)
				state = .scanningBackground
			}

		case .scanningBackground:
			if shouldStartNewStep(line) {
				startNewStep(line, commentCollector)
				
			} else {
				descriptionLines.append(line.text)
			}

		case .scanningSteps:
			if shouldStartNewStep(line) {
				startNewStep(line, commentCollector)

			} else {
				currentStepScanner.scan(line, commentCollector)
			}
		}
	}
	
	private func shouldStartNewStep(_ line: Line) -> Bool {
		return line.isStep()
	}
	
	private func startNewStep(_ line: Line, _ commentCollector: CommentCollector) {
		currentStepScanner = StepScanner()
		stepScanners.append(currentStepScanner)
		
		currentStepScanner.scan(line, commentCollector)
		
		state = .scanningSteps
	}
	
	func getBackground() -> Background? {
		if state == .started {
			return nil
		}

		return Background(name: name,
						  steps: steps(),
						  description: descriptionLines.asDescription(),
						  location: location)
	}

	private func steps() -> [Step] {
		return stepScanners.map{$0.getStep()}
	}
}
