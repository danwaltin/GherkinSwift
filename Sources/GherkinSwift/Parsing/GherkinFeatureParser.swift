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
			return .error(ParseError(
				message: "(1:1): Language not supported: \(languageKey)",
				source: ParseErrorSource(location: Location(column: 1, line: 1), uri: fileUri)))
		}
		
		let language = languages.language(withKey: languageKey)

		let theLines = getLines(lines, language: language)
		for line in theLines {
			if line.hasKeyword(.comment) {
				commentCollector.collectComment(line)
			} else {
				let scanResult = featureScanner.scan(line, allLines: theLines)
				switch scanResult {
				case .error(let location):
					return .error(ParseError(
						message: "(\(location.line):1): expected: #EOF, #Language, #TagLine, #FeatureLine, #Comment, #Empty, got '\(line.text)'",
						source: ParseErrorSource(location: location, uri: fileUri)))
				case .success:
					// happy happy
					break
				}
			}
		}
		
		let document = GherkinDocument(comments: commentCollector.getComments(),
									   feature: featureScanner.getFeature(languageKey: language.key),
									   uri: fileUri)
		
		return .success(document)
	}
	
	public func getAllLinesInFile(url: URL) -> [String] {
		let data = try! Data(contentsOf: url)
		let content = String(data: data, encoding: .utf8)!
		
		return getAllLinesInDocument(document: content)
	}
	
	public func getAllLinesInDocument(document: String) -> [String] {
		return document.allLines().map { $0.replacingOccurrences(of: "\\n", with: "\n")}
	}
	
	private func getLines(_ lines: [String], language: Language) -> [Line] {
		return lines.enumerated().map{ (index, text) in
			let keyword = Keyword.createFrom(text: text, language: language)
			
			return Line(text: text,
						number: index + 1,
						keyword: keyword) }
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
