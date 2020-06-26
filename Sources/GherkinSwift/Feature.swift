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
//  Feature.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

public struct Feature : Equatable, Taggable, HasName {
	public let name: String
	public let description: String?
	public let tags: [String]
	public let scenarios: [Scenario]
	public let location: Location
	
	public init(name: String, description: String?, tags: [String] = [], location: Location, scenarios: [Scenario] = []) {
		self.name = name
		self.description = description
		self.tags = tags
		self.scenarios = scenarios
		
		self.location = location
	}
}
