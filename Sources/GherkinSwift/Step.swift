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
	public let docStringParameter: DocString?
	public let location: Location
	public let localizedKeyword: String
	
	public init(type: StepType,
				text: String,
				location: Location,
				tableParameter: Table?,
				docStringParameter: DocString?,
				localizedKeyword: String) {
		self.type = type
		self.text = text
		self.location = location
		self.tableParameter = tableParameter
		self.docStringParameter = docStringParameter
		self.localizedKeyword = localizedKeyword
	}
	
	var keyword: String {
		switch type {
		case .Asterisk:
			return keywordAsterisk
		case .Given:
			return keywordGiven
		case .When:
			return keywordWhen
		case .Then:
			return keywordThen
		case .And:
			return keywordAnd
		case .But:
			return keywordBut
		}
	}
		
	static func asterisk(_ text: String, _ table: Table? = nil, _ docString: DocString? = nil) -> Step {
		return Step(type: .Asterisk, text: text, location: Location.zero(), tableParameter: table, docStringParameter: docString, localizedKeyword: "")
	}

	static func given(_ text: String, _ table: Table? = nil, _ docString: DocString? = nil) -> Step {
		return Step(type: .Given, text: text, location: Location.zero(), tableParameter: table, docStringParameter: docString, localizedKeyword: "")
	}

	static func when(_ text: String, _ table: Table? = nil, _ docString: DocString? = nil) -> Step {
		return Step(type: .When, text: text, location: Location.zero(), tableParameter: table, docStringParameter: docString, localizedKeyword: "")
	}

	static func then(_ text: String, _ table: Table? = nil, _ docString: DocString? = nil) -> Step {
		return Step(type: .Then, text: text, location: Location.zero(), tableParameter: table, docStringParameter: docString, localizedKeyword: "")
	}

	static func and(_ text: String, _ table: Table? = nil, _ docString: DocString? = nil) -> Step {
		return Step(type: .And, text: text, location: Location.zero(), tableParameter: table, docStringParameter: docString, localizedKeyword: "")
	}

	static func but(_ text: String, _ table: Table? = nil, _ docString: DocString? = nil) -> Step {
		return Step(type: .But, text: text, location: Location.zero(), tableParameter: table, docStringParameter: docString, localizedKeyword: "")
	}
}
