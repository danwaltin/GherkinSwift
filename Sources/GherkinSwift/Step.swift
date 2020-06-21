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
//  Step.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-19.
//
// ------------------------------------------------------------------------

import Foundation

public struct Step : Equatable {
	public let type: StepType
	public let text: String
	public let tableParameter: Table?
	public let location: Location

	public init(type: StepType, text: String, tableParameter: Table?) {
		self.type = type
		self.text = text
		self.tableParameter = tableParameter

		self.location = Location(column: 1, line: 1)
	}
	
	public static func given(_ text: String, _ table: Table? = nil) -> Step {
		return Step(type: .Given, text: text, tableParameter: table)
	}

	public static func when(_ text: String, _ table: Table? = nil) -> Step {
		return Step(type: .When, text: text, tableParameter: table)
	}

	public static func then(_ text: String, _ table: Table? = nil) -> Step {
		return Step(type: .Then, text: text, tableParameter: table)
	}
}
