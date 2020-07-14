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
//  KeywordType.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-14.
//
// ------------------------------------------------------------------------

enum KeywordType : CaseIterable {
	case none
	case feature
	case background
	case scenario
	case scenarioOutline
	case examples
	case given
	case when
	case then
	case and
	case but
	case asterisk
	
	case table
	case comment
	case tag
	
	static func isStep(type: KeywordType) -> Bool {
		let stepKeywords: [KeywordType] = [.asterisk, .given, .when, .then, .and, .but]
		return stepKeywords.contains(type)
	}

}
