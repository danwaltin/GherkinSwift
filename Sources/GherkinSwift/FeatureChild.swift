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
//  FeatureChild.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import Foundation

struct FeatureChild : Encodable {
	enum CodingKeys: String, CodingKey {
		case scenario
		case background
	}

	let scenario: Scenario?
	let background: Background?

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		if let scenario = scenario {
			try container.encode(scenario, forKey: .scenario)
		}

		if let background = background {
			try container.encode(background, forKey: .background)
		}
	}
}


extension Feature {
	var children: [FeatureChild] {
		get {
			var backgroundAndScenarios = [FeatureChild]()
			
			if let background = background {
				backgroundAndScenarios.append(FeatureChild(scenario: nil, background: background))
			}

			backgroundAndScenarios.append(contentsOf: scenarios.map {FeatureChild(scenario: $0, background: nil)})
			
			return backgroundAndScenarios
		}
	}
}
