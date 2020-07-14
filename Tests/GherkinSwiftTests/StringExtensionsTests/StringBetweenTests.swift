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
//  StringBetweenTests.swift
//  GherkinSwift
//
//  Created by Dan Waltin on 2020-07-14.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinSwift

class StringBetweenTests : XCTestCase {
	func test_emptyString_shouldReturnEmptyString() {
		let actual = "".stringBetween("1", and: "2")
		XCTAssertEqual(actual, "")
	}

	func test_firstNotPresent_shouldReturnEmptyString() {
		let actual = "apa2".stringBetween("1", and: "2")
		XCTAssertEqual(actual, "")
	}

	func test_secondNotPresent_shouldReturnEmptyString() {
		let actual = "1apa".stringBetween("1", and: "2")
		XCTAssertEqual(actual, "")
	}
	
	func test_secondBeforeFirst_shouldReturnEmptyString() {
		let actual = "2apa1".stringBetween("1", and: "2")
		XCTAssertEqual(actual, "")
	}

	func test_nothingBetween_shouldReturnEmptyString() {
		let actual = "apaABbpa".stringBetween("A", and: "B")
		XCTAssertEqual(actual, "")
	}
	
	func test_oneLetterBetween_shouldReturnLetter() {
		let actual = "apaAxBbpa".stringBetween("A", and: "B")
		XCTAssertEqual(actual, "x")
	}

	func test_twoLettersBetween_shouldReturnLetters() {
		let actual = "apaAxyBbpa".stringBetween("A", and: "B")
		XCTAssertEqual(actual, "xy")
	}

	func test_spaceBetween_shouldReturnSpace() {
		let actual = "apaA Bbpa".stringBetween("A", and: "B")
		XCTAssertEqual(actual, " ")
	}

	func test_wordWithSpacesAroundBetween_shouldReturnWord() {
		let actual = "apaA word Bbpa".stringBetween("A", and: "B")
		XCTAssertEqual(actual, " word ")
	}

	func test_nonAlphaNumericSeparators_shouldReturnWord() {
		let actual = "apa# word :bpa".stringBetween("#", and: ":")
		XCTAssertEqual(actual, " word ")
	}

	func test_twoStartSeparatorsBeforeEndSeparator_shouldReturnStringIncludingSecondStart() {
		let actual = "apa X one X two Y bpa".stringBetween("X", and: "Y")
		XCTAssertEqual(actual, " one X two ")
	}

	func test_twoEndSeparatorsAfterStartSeparator_shouldReturnStringUpToFirstEnd() {
		let actual = "apa X one Y two Y bpa".stringBetween("X", and: "Y")
		XCTAssertEqual(actual, " one ")
	}

	func test_twoSetsOfSeparators_shouldReturnStringBetweenFirstSet() {
		let actual = "det var en gång en gube # som bodde i en lådda : med sina # drängar bådda : de voro ute hela daggen".stringBetween("#", and: ":")
		XCTAssertEqual(actual, " som bodde i en lådda ")
	}

	func test_multiLetterSeparators() {
		let actual = "det var en gång 22 en gube 333 som bodde i en lådda".stringBetween("22", and: "333")
		XCTAssertEqual(actual, " en gube ")
	}
	
	func test_separatorsWithinAWord() {
		let actual = "qwerty".stringBetween("w", and: "t")
		XCTAssertEqual(actual, "er")
	}
	
	func test_emptyFirstSeparator_shouldReturnEmptyString() {
		let actual = "qwerty".stringBetween("", and: "t")
		XCTAssertEqual(actual, "")
	}

	func test_emptySecondSeparator_shouldReturnEmptyString() {
		let actual = "qwerty".stringBetween("w", and: "")
		XCTAssertEqual(actual, "")
	}

	func test_emptySeparators_shouldReturnEmptyString() {
		let actual = "qwerty".stringBetween("", and: "")
		XCTAssertEqual(actual, "")
	}

	func test_equalSeparators_shouldReturnEmptyString() {
		let actual = "qwerty".stringBetween("w", and: "w")
		XCTAssertEqual(actual, "")
	}
}
