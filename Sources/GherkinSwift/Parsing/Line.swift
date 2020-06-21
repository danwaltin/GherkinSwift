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
//  Line.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------
import Foundation

let tagToken = "@"
let keywordFeature = "Feature:"
let keywordScenarioOutline = "Scenario Outline:"
let keywordScenario = "Scenario:"

struct Line {
	let text: String
	let number: Int
	
	func removeKeyword(_ keyword: String) -> String {
		let copy = text.deleteText(keyword)
		return copy.trim()
	}

	func isTag() -> Bool {
		return hasPrefix(tagToken)
	}

	func isFeature() -> Bool {
		return beginsWithKeyword(keywordFeature)
	}

	func isScenarioOutline() -> Bool {
		return beginsWithKeyword(keywordScenarioOutline)
	}

	func isScenario() -> Bool {
		return beginsWithKeyword(keywordScenario)
	}

	private func beginsWithKeyword(_ keyword: String) -> Bool {
		return hasPrefix(keyword)
	}
	
	private func hasPrefix(_ prefix: String) -> Bool {
		return text.trim().hasPrefix(prefix)
	}
}
