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
//  LanguagesConfiguration.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-11.
//
// ------------------------------------------------------------------------
import Foundation

public struct LanguagesConfiguration {
	let defaultLanguageKey: String
	private let languages: [String: Language]
	
	public init(defaultLanguageKey: String,
				languages: [String: Language]) {
		self.defaultLanguageKey = defaultLanguageKey
		self.languages = languages
	}

	public init(defaultLanguageKey: String) {
		self.init(defaultLanguageKey: defaultLanguageKey, languages: LanguagesConfiguration.getAvailableLanguages())
	}

	private static func getAvailableLanguages() -> [String : Language] {
		let languagesFileUrl = fileUrl(of: "gherkin-languages.json")
		
		let data = try! Data(contentsOf: languagesFileUrl)

		if let x = try? JSONDecoder().decode([String: Language].self, from: data) {
			return x
		}
		
		return [:]
	}
	
	private static func fileUrl(of file: String) -> URL {
		let thisSourceFile = URL(fileURLWithPath: #file)
		let currentDirectory = thisSourceFile.deletingLastPathComponent()
		let parentDirectory = currentDirectory.deletingLastPathComponent()
		
		return parentDirectory.appendingPathComponent(file)
	}

	func languageExist(key: String) -> Bool {
		return languages[key] != nil
	}
	
	func language(withKey key: String) -> Language {
		if var l = languages[key] {
			l.key = key
			return l
		}
		
		return defaultLanguage
	}

	var defaultLanguage: Language {
		var l = languages[defaultLanguageKey]!
		l.key = defaultLanguageKey
		return l
	}
}
