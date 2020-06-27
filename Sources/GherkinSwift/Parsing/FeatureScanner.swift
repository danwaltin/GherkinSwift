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
//  FeatureScanner.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import Foundation

class FeatureScanner {
	var featureTags = [String]()
	let tagScanner = TagScanner()

	var name = ""
	var descriptionLines = [String]()
	var lineNumber = 0
	var columnNumber = 0
	var hasFoundFeature = false

	var isScanningScenarios = false
	var currentScenarioScanner: ScenarioScanner!
	var scenarioScanners: [ScenarioScanner] = []
	
	func scan(line: Line, _ commentCollector: CommentCollector) {
		
		if line.isTag() {
			tagScanner.scan(line: line)
		
		} else if line.isFeature() {
			name = line.removeKeyword(keywordFeature)
			lineNumber = line.number
			columnNumber = line.columnForKeyword(keywordFeature)
			hasFoundFeature = true
			featureTags = tagScanner.getTags()
			tagScanner.clear()
			
		} else if line.isScenarioOutline() {
			currentScenarioScanner = ScenarioOutlineScanner(scenarioTags: tagScanner.getTags())
			tagScanner.clear()
			scenarioScanners += [currentScenarioScanner]
			
			isScanningScenarios = true
			
			currentScenarioScanner.scan(line: line, commentCollector)

		} else if line.isScenario() {
			currentScenarioScanner = ScenarioScanner(scenarioTags: tagScanner.getTags())
			tagScanner.clear()
			scenarioScanners += [currentScenarioScanner]
			
			isScanningScenarios = true
			
			currentScenarioScanner.scan(line: line, commentCollector)

		} else if isScanningScenarios {
			currentScenarioScanner.scan(line: line, commentCollector)
			
		} else if !line.isEmpty() {
			descriptionLines.append(line.text)
		}
	}
	
	func getFeature() -> Feature? {
		if !hasFoundFeature {
			return nil
		}
		let description = descriptionLines.count == 0 ? nil : descriptionLines.joined(separator: "\n")
		return Feature(name: name,
					   description: description,
					   tags: featureTags,
					   location: Location(column: columnNumber, line: lineNumber),
					   scenarios: getScenarios())
	}
	
	private func getScenarios() -> [Scenario] {
		var s = [Scenario]()
		for scanner in scenarioScanners {
			s.append(contentsOf: scanner.getScenarios())
		}
		return s
	}
}
