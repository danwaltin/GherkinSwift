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
//  StepScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

class  StepScanner {
	var text = ""
	var step: Step!
	
	var isScanningTable = false
	let tableScanner = TableScanner()

	func getStep() -> Step {
		return Step(type: step.type, text: step.text, tableParameter: tableScanner.getTableArgument())
	}
	
	func scan(line: Line) {
		handleStepText(line: line)
		handleTable(line: line)
	}
	
	private func handleStepText(line: Line) {
		if line.isGiven() {
			step = Step.given(line.removeKeyword(keywordGiven))
		}
		
		if line.isWhen() {
			step = Step.when(line.removeKeyword(keywordWhen))
		}
		
		if line.isThen() {
			step = Step.then(line.removeKeyword(keywordThen))
		}
	}

	private func handleTable(line: Line) {
		if line.isEmpty() {
			return
		}

		if isScanningTable {
			tableScanner.scan(line: line)
			
		} else if line.isTable() {
			isScanningTable = true
			tableScanner.scan(line: line)
		}
	}
}
