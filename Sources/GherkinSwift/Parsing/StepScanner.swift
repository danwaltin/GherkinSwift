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

class StepScanner {
	var text = ""
	var location = Location(column: 0, line: 0)
	var step: Step!
	
	var isScanningTable = false
	let tableScanner = TableScanner()

	func getStep() -> Step {
		return Step(type: step.type, text: step.text, location: location, tableParameter: tableScanner.getTable())
	}
	
	func scan(_ line: Line, _ commentsCollector: CommentCollector) {
		if line.isComment() {
			commentsCollector.collectComment(line)
		} else {
			handleStepText(line: line)
			handleTable(line: line)
		}
	}
	
	private func handleStepText(line: Line) {
		if line.isEmpty() {
			return
		}
		
		if line.isGiven() {
			location = Location(column: line.columnForKeyword(keywordGiven), line: line.number)
			step = Step.given(line.removeKeyword(keywordGiven))
		}

		if line.isWhen() {
			location = Location(column: line.columnForKeyword(keywordWhen), line: line.number)
			step = Step.when(line.removeKeyword(keywordWhen))
		}

		if line.isThen() {
			location = Location(column: line.columnForKeyword(keywordThen), line: line.number)
			step = Step.then(line.removeKeyword(keywordThen))
		}

		if line.isAnd() {
			location = Location(column: line.columnForKeyword(keywordAnd), line: line.number)
			step = Step.and(line.removeKeyword(keywordAnd))
		}

		if line.isBut() {
			location = Location(column: line.columnForKeyword(keywordBut), line: line.number)
			step = Step.but(line.removeKeyword(keywordBut))
		}
	}
	
	private func handleTable(line: Line) {
		if line.isEmpty() {
			return
		}

		isScanningTable = isScanningTable || line.isTable()

		if isScanningTable {
			tableScanner.scan(line)
		}
	}
}
