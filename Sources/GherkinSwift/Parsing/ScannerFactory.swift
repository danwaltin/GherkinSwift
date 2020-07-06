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
//  ScannerFactory.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-06.
//
// ------------------------------------------------------------------------

struct ScannerFactory {
	private let configuration: ParseConfiguration

	init(configuration: ParseConfiguration) {
		self.configuration = configuration
	}
	
	func featureScanner() -> FeatureScanner {
		return FeatureScanner(featureTagScanner: tagScanner(),
							  backgroundScanner: backgroundScanner(),
							  scenarioTagScanner: tagScanner(),
							  scenarioScannerFactory: scenarioScannerFactory())
	}
	
	func commentCollector() -> CommentCollector {
		return CommentCollector()
	}
	
	private func tagScanner() -> TagScanner {
		return TagScanner()
	}
	
	private func backgroundScanner() -> BackgroundScanner {
		return BackgroundScanner(stepScannerFactory: stepScannerFactory())
	}
	
	private func scenarioScannerFactory() -> ScenarioScannerFactory {
		return ScenarioScannerFactory(configuration: configuration)
	}

	private func stepScannerFactory() -> StepScannerFactory {
		return StepScannerFactory(configuration: configuration)
	}
}

struct ScenarioScannerFactory {
	private let configuration: ParseConfiguration

	init(configuration: ParseConfiguration) {
		self.configuration = configuration
	}

	func scenarioScanner(tags: [Tag]) -> ScenarioScanner {
		return ScenarioScanner(tags: tags,
							   stepScannerFactory: StepScannerFactory(configuration: configuration),
							   examplesTagScanner: TagScanner(),
							   examplesScannerFactory: ExamplesScannerFactory())
	}
}

struct StepScannerFactory {
	private let configuration: ParseConfiguration

	init(configuration: ParseConfiguration) {
		self.configuration = configuration
	}

	func stepScanner() -> StepScanner {
		return StepScanner(tableScanner: TableScanner(),
						   docStringScanner: DocStringScanner(configuration: configuration))
	}
}

struct ExamplesScannerFactory {
	func examplesScanner(tags: [Tag]) -> ExamplesScanner {
		return ExamplesScanner(tags: tags, tableScanner: TableScanner())
	}
}
