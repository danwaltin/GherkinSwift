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
	enum State {
		case started
		case scanningFeature
		case scanningBackground
		case scanningScenario
		case foundNextScenarioTags
	}
	
	private var state: State = .started
	private var location = Location.zero()
	
	let featureTagScanner = TagScanner()

	let scenarioTagScanner = TagScanner()
	
	var name = ""
	var descriptionLines = [String]()
	
	var currentScenarioScanner: ScenarioScanner!
	var scenarioScanners: [ScenarioScanner] = []
	
	let backgroundScanner = BackgroundScanner()
	
	func scan(_ line: Line, _ commentCollector: CommentCollector, allLines: [Line]) {
		switch state {
		case .started:
			if line.isTag() {
				featureTagScanner.scan(line)
			}

			if line.isFeature() {
				name = line.removeKeyword(keywordFeature)
				location = Location(column: line.columnForKeyword(keywordFeature) , line: line.number)
				state = .scanningFeature
			}

		case .scanningFeature:
			if line.isTag() {
				scenarioTagScanner.scan(line)

			} else if shouldStartBackground(line) {
				startBackground(line, commentCollector)
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line, commentCollector)

			} else {
				descriptionLines.append(line.text)
			}

		case .scanningBackground:
			if line.isTag() && ScenarioScanner.lineBelongsToNextScenario(line, allLines: allLines) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags
			} else if shouldStartNewScenario(line) {
				startNewScenario(line, commentCollector)
			
			} else {
				backgroundScanner.scan(line, commentCollector)
			}
			
		case .scanningScenario:
			if line.isTag() && ScenarioScanner.lineBelongsToNextScenario(line, allLines: allLines) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line, commentCollector)
			
			} else {
				currentScenarioScanner.scan(line, commentCollector)
			}

		case .foundNextScenarioTags:
			if line.isTag() {
				scenarioTagScanner.scan(line)
			
			} else if shouldStartNewScenario(line) {
				startNewScenario(line, commentCollector)
			}
		}
	}

	private func shouldStartBackground(_ line: Line) -> Bool {
		return line.isBackground()
	}
	
	private func startBackground(_ line: Line, _ commentCollector: CommentCollector) {
		backgroundScanner.scan(line, commentCollector)
		state = .scanningBackground
	}
	
	private func shouldStartNewScenario(_ line: Line) -> Bool {
		return line.isScenario() || line.isScenarioOutline()
	}

	private func startNewScenario(_ line: Line, _ commentCollector: CommentCollector) {
		currentScenarioScanner = ScenarioScanner(tags: scenarioTagScanner.getTags())
		scenarioTagScanner.clear()
		scenarioScanners += [currentScenarioScanner]

		currentScenarioScanner.scan(line, commentCollector)

		state = .scanningScenario
	}
	
	func getFeature() -> Feature? {
		if state == .started {
			return nil
		}
		
		return Feature(name: name,
					   description: descriptionLines.asDescription(),
					   background: backgroundScanner.getBackground(),
					   tags: tags(),
					   location: location,
					   scenarios: scenarios())
	}
	
	private func tags() -> [Tag] {
		return featureTagScanner.getTags()
	}

	private func scenarios() -> [Scenario] {
		return scenarioScanners.map { $0.getScenario() }
	}
}
