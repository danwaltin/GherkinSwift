import XCTest

import GherkinSwiftTests

var tests = [XCTestCaseEntry]()
tests += GherkinSwiftTests.allTests()
XCTMain(tests)
