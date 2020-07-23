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
//  GherkinFeatureParser.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-06-21.
//
// ------------------------------------------------------------------------

import Foundation

public class GherkinFeatureParser {
	
	private let scannerFactory: ScannerFactory
	private let languages: LanguagesConfiguration
	
	public init(configuration: ParseConfiguration,
				languages: LanguagesConfiguration) {
		scannerFactory = ScannerFactory(configuration: configuration)
		self.languages = languages
	}
	
	public func pickle(lines: [String], fileUri: String) -> PickleResult {
		let featureScanner = scannerFactory.featureScanner()
		let commentCollector = scannerFactory.commentCollector()
		
		let firstLine = lines.count > 0 ? lines.first! : ""
		
		let languageKey = getLanguageKey(from: firstLine)
		if !languages.languageExist(key: languageKey) {
			let error = ParseError.invalidLanguage(languageKey, atLineNumber: 1, file: fileUri)
			return .error([error])
		}
		
		let language = languages.language(withKey: languageKey)

		let theLines = getLines(lines, file: fileUri, language: language)
		for line in theLines {
			if line.hasKeyword(.comment) {
				commentCollector.collectComment(line)
			} else {
				featureScanner.scan(line, allLines: theLines)
			}
		}
		
		let featureResult = featureScanner.getFeature(languageKey: language.key)
		
		var errors = featureResult.errors
		
		// well this ain't pretty...
		if lastLineIsTag(theLines) {
			let lastLine = theLines.last!
			let location = Location(column: 0, line: lastLine.number + 1)
			let source = ParseErrorSource(location: location, uri: fileUri)
			var message = ""
			if let feature = featureResult.feature {
				if feature.scenarios.count == 0 {
					message = "unexpected end of file, expected: #TagLine, #ScenarioLine, #Comment, #Empty"
				} else {
					message = "unexpected end of file, expected: #TagLine, #ExamplesLine, #ScenarioLine, #Comment, #Empty"
				}
			} else {
				message = "unexpected end of file, expected: #TagLine, #FeatureLine, #Comment, #Empty"
			}
			errors.append(ParseError(message: message, source: source))
		}
		
		if errors.count > 0 {
			return .error(errors.sorted(by: {a,b in a.source.location.line < b.source.location.line}))
		}
		
		let document = GherkinDocument(comments: commentCollector.getComments(),
									   feature: featureResult.feature,
									   uri: fileUri)
		
		return .success(document)
	}
	
	private func lastLineIsTag(_ lines: [Line]) -> Bool {
		if lines.count == 0 {
			return false
		}

		var copy = lines
		copy.reverse()
		for line in copy {
			if line.isEmpty() {
				continue
			}
			
			return line.hasKeyword(.tag)
		}
		
		return false
	}
	
	public func getAllLinesInFile(url: URL) -> [String] {
		let data = try! Data(contentsOf: url)
		let content = String(data: data, encoding: .utf8)!
		
		return getAllLinesInDocument(document: content)
	}
	
	public func getAllLinesInDocument(document: String) -> [String] {
		return document.allLines().map { $0.replacingOccurrences(of: "\\n", with: "\n")}
	}
	
	private func getLines(_ lines: [String], file: String, language: Language) -> [Line] {
		return lines.enumerated().map{ (index, text) in
			let keyword = Keyword.createFrom(text: text, language: language)
			
			return Line(text: text,
						number: index + 1,
						keyword: keyword,
						file: file) }
	}
	
	private func getLanguageKey(from text: String) -> String {
		if let languageKeyword = text.languageKeyword() {
			let languageKey = text.removeKeyword(languageKeyword)
			return languageKey
		}
		
		return languages.defaultLanguageKey
	}
	
	private func getLanguage(text: String) -> Language {
		if let languageKeyword = text.languageKeyword() {
			let languageKey = text.removeKeyword(languageKeyword)
			return languages.language(withKey: languageKey)
		}
		
		return languages.defaultLanguage
	}
}
