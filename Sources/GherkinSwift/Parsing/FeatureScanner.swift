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
	
	let featureTagScanner: TagScanner
	let backgroundScanner: BackgroundScanner
	let scenarioTagScanner: TagScanner
	let scenarioScannerFactory: ScenarioScannerFactory
	var scenarioScanners: [ScenarioScanner] = []
	
	private var parseErrors = [ParseError]()
	private var keyword: Keyword = Keyword.none()
	var name = ""
	var descriptionLines = [String]()
	
	init(featureTagScanner: TagScanner,
		 backgroundScanner: BackgroundScanner,
		 scenarioTagScanner: TagScanner,
		 scenarioScannerFactory: ScenarioScannerFactory) {
		
		self.featureTagScanner = featureTagScanner
		self.backgroundScanner = backgroundScanner
		self.scenarioTagScanner = scenarioTagScanner
		self.scenarioScannerFactory = scenarioScannerFactory
	}
	
	func scan(_ line: Line, allLines: [Line]) {
		switch state {
		case .started:
			if line.hasKeyword(.tag) {
				featureTagScanner.scan(line)
			
			} else if line.hasKeyword(.feature) {
				keyword = line.keyword
				name = line.keywordRemoved()
				location = line.keywordLocation()
				state = .scanningFeature
				
			} else if !(line.text.isLanguageSpecification() || line.isEmpty()) {

				let hasFoundFeatureTags = featureTagScanner.numberOfTags() > 0
				
				let expected = hasFoundFeatureTags
					? "#TagLine, #FeatureLine, #Comment, #Empty"
					: "#EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty"
				
				parseErrors.append(
					ParseError.invalidGherkin(expected, atLine: line))
			}
			
		case .scanningFeature:
			if line.hasKeyword(.tag) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags

			} else if shouldStartBackground(line) {
				startBackground(line)
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)
				
			} else {
				descriptionLines.append(line.text)
			}
			
		case .scanningBackground:
			if line.hasKeyword(.tag) && ScenarioScanner.lineBelongsToNextScenario(line, allLines: allLines) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)
				
			} else {
				backgroundScanner.scan(line)
			}
			
		case .scanningScenario:
			if line.hasKeyword(.tag) && ScenarioScanner.lineBelongsToNextScenario(line, allLines: allLines) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)
				
			} else {
				scanScenario(line)
			}
			
		case .foundNextScenarioTags:
			if line.hasKeyword(.tag) {
				scenarioTagScanner.scan(line)
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)

			} else if !line.isEmpty()  {
				let tags = "#TagLine, #ScenarioLine, #RuleLine, #Comment, #Empty"
				parseErrors.append(
					ParseError.invalidGherkin(tags, atLine: line))
				
			}
		}
	}
	
	private func shouldStartBackground(_ line: Line) -> Bool {
		return line.hasKeyword(.background)
	}
	
	private func startBackground(_ line: Line) {
		backgroundScanner.scan(line)
		state = .scanningBackground
	}
	
	private func shouldStartNewScenario(_ line: Line) -> Bool {
		return line.hasKeyword(.scenario) || line.hasKeyword(.scenarioOutline)
	}
	
	private func startNewScenario(_ line: Line) {
		let tagsWithErrors = scenarioTagScanner.getTags()
		let tags = tagsWithErrors.tags
		parseErrors.append(contentsOf: tagsWithErrors.errors)
		scenarioScanners.append(scenarioScannerFactory.scenarioScanner(tags: tags))
		scenarioTagScanner.clear()
		
		scanScenario(line)
		
		state = .scanningScenario
	}
	
	private func scanScenario(_ line: Line) {
		scenarioScanners.last!.scan(line)
	}
	
	func getFeature(languageKey: String) -> (feature: Feature?, errors: [ParseError]) {
		
		if state == .started {
			return (nil, parseErrors)
		}

		let scenariosWithScenarioParseErrors = scenarioScanners.map { $0.getScenario() }
		let scenarios = scenariosWithScenarioParseErrors.map { $0.scenario }
		let scenarioParseErrors = scenariosWithScenarioParseErrors.flatMap { $0.errors }
		
		let backgroundWithBackgroundParseErrors = backgroundScanner.getBackground()
		let background = backgroundWithBackgroundParseErrors.background
		let backgroundErrors = backgroundWithBackgroundParseErrors.errors

		let tagsWithParseErrors = featureTagScanner.getTags()
		let tags = tagsWithParseErrors.tags
		let tagsErrors = tagsWithParseErrors.errors

		parseErrors.append(contentsOf: scenarioParseErrors)
		parseErrors.append(contentsOf: backgroundErrors)
		parseErrors.append(contentsOf: tagsErrors)
		
		let feature = Feature(name: name,
							  description: descriptionLines.asDescription(),
							  background: background,
							  tags: tags,
							  location: location,
							  scenarios: scenarios,
							  language: languageKey,
							  localizedKeyword: keyword.localized)
		
		return (feature, parseErrors)
	}
}
