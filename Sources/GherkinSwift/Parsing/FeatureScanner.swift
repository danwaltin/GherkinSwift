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
		let keyword = line.keyword
		
		switch state {
		case .started:
			if line.isTag() {
				featureTagScanner.scan(line)
			}

			if keyword == .feature {
				name = line.keywordRemoved()
				location = line.keywordLocation()
				state = .scanningFeature
			}

		case .scanningFeature:
			if line.isTag() {
				scenarioTagScanner.scan(line)

			} else if shouldStartBackground(line) {
				startBackground(line)
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)

			} else {
				descriptionLines.append(line.text)
			}

		case .scanningBackground:
			if line.isTag() && ScenarioScanner.lineBelongsToNextScenario(line, allLines: allLines) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)
			
			} else {
				backgroundScanner.scan(line)
			}
			
		case .scanningScenario:
			if line.isTag() && ScenarioScanner.lineBelongsToNextScenario(line, allLines: allLines) {
				scenarioTagScanner.scan(line)
				state = .foundNextScenarioTags
				
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)
			
			} else {
				scanScenario(line)
			}

		case .foundNextScenarioTags:
			if line.isTag() {
				scenarioTagScanner.scan(line)
			
			} else if shouldStartNewScenario(line) {
				startNewScenario(line)
			}
		}
	}

	private func shouldStartBackground(_ line: Line) -> Bool {
		return line.keyword == .background
	}
	
	private func startBackground(_ line: Line) {
		backgroundScanner.scan(line)
		state = .scanningBackground
	}
	
	private func shouldStartNewScenario(_ line: Line) -> Bool {
		return line.keyword == .scenario || line.keyword == .scenarioOutline
	}

	private func startNewScenario(_ line: Line) {
		scenarioScanners.append(scenarioScannerFactory.scenarioScanner(tags: scenarioTagScanner.getTags()))
		scenarioTagScanner.clear()

		scanScenario(line)

		state = .scanningScenario
	}
	
	private func scanScenario(_ line: Line) {
		scenarioScanners.last!.scan(line)
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
