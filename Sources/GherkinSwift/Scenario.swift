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
//  Scenario.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-19.
//
// ------------------------------------------------------------------------

public struct Scenario : Equatable, Taggable, HasName {
	public let name: String
	public let description: String?
	public let tags: [Tag]
	public let steps: [Step]
	public let location: Location
	public let examples: [ScenarioOutlineExamples]
	public let isScenarioOutline: Bool
	public let localizedKeyword: String
	
	public init(name: String,
				description: String?,
				tags: [Tag],
				location: Location,
				steps: [Step],
				examples: [ScenarioOutlineExamples],
				isScenarioOutline: Bool = false,
				localizedKeyword: String) {
		self.name = name
		self.description = description
		self.tags = tags
		self.location = location
		self.steps = steps
		self.examples = examples
		self.isScenarioOutline = isScenarioOutline
		self.localizedKeyword = localizedKeyword
	}
}
