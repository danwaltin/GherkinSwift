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

extension String {
	func isLanguageSpecification() -> Bool {
		return languageKeyword() != nil
	}
	
	func languageKeyword() -> String? {
		// there is probably a regular expression that can solve this...
		
		// Must begin with "#" and contain a ":
		if trim().hasPrefix(String(commentToken)) && contains(":") {
			let between = stringBetween(commentToken, and: ":")
			if between.trim() == "language" {
				return "\(commentToken)\(between):"
			}
		}

		return nil
	}
}
