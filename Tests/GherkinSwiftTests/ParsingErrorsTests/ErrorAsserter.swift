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
//  ErrorAsserter.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-16.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

struct ErrorAsserter {
	let actualPickleResult: PickleResult
	
	func parseError(_ file: StaticString, _ line: UInt, assert: ([ParseError]) -> Void ) {
		switch actualPickleResult {
		case .error(let error):
			assert(error)
			
		case .success( _):
			XCTFail("No parse error found. Parse was successful", file: file, line: line)
		}
	}

	func parseSingleError(_ file: StaticString, _ line: UInt, assert: (ParseError) -> Void ) {
		parseError(file, line) {
			if $0.count == 0 {
				XCTFail("No parse error found. Empty error array.", file: file, line: line)
			}
			assert($0[0])
		}
	}

	func parseError(withMessage message: String, _ file: StaticString, _ line: UInt) {
		parseSingleError(file, line) {
			XCTAssertEqual($0.message, message, file: file, line: line)
		}
	}

	func parseError(withLocation location: Location, _ file: StaticString, _ line: UInt) {
		parseSingleError(file, line) {
			XCTAssertEqual($0.source.location, location, file: file, line: line)
		}
	}
}
