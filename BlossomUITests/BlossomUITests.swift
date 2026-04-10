//
//  BlossomUITests.swift
//  BlossomUITests
//
//  Automated UI walkthrough — simulates a real user tapping through
//  every tab, exercise, and article in the Blossom (如期) app.
//
//  Run with:
//    xcodebuild test -project Blossom.xcodeproj -scheme Blossom \
//      -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
//      -only-testing:BlossomUITests
//

import XCTest

final class BlossomUITests: XCTestCase {

    let app = XCUIApplication()

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        continueAfterFailure = true
        // Reset state so onboarding shows every time
        app.launchArguments = []
        app.launch()
    }

    override func tearDownWithError() throws {
        // nothing — screenshots are already attached
    }

    // MARK: - Helpers

    /// Take a screenshot and attach it to the test result with a human-friendly name.
    private func snap(_ name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    // MARK: - Full User Flow

    func testFullUserFlow() throws {

        // ────────────────────────────────────────────
        // Step 1: Onboarding
        // ────────────────────────────────────────────
        let welcomeTitle = app.staticTexts["欢迎来到如期"]
        XCTAssertTrue(welcomeTitle.waitForExistence(timeout: 5),
                      "Onboarding title '欢迎来到如期' should appear on first launch")

        // Date picker should be visible
        let datePicker = app.datePickers.firstMatch
        XCTAssertTrue(datePicker.waitForExistence(timeout: 3),
                      "Due-date picker should be visible on onboarding screen")

        snap("01-onboarding")

        // Tap the CTA button to finish onboarding
        let ctaButton = app.buttons["开始我的孕期之旅"]
        XCTAssertTrue(ctaButton.waitForExistence(timeout: 3),
                      "CTA button '开始我的孕期之旅' must exist")
        ctaButton.tap()

        // Give SwiftUI time to transition
        Thread.sleep(forTimeInterval: 1.0)

        // ────────────────────────────────────────────
        // Step 2: Home Tab (default after onboarding)
        // ────────────────────────────────────────────
        // After onboarding the tab bar should appear
        let homeTab = app.tabBars.buttons["首页"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 10),
                      "Tab bar with '首页' should appear after onboarding")

        snap("02-home")

        // ────────────────────────────────────────────
        // Step 3: Tasks Tab
        // ────────────────────────────────────────────
        let tasksTab = app.tabBars.buttons["任务"]
        XCTAssertTrue(tasksTab.waitForExistence(timeout: 3))
        tasksTab.tap()
        // Wait for the tasks page content
        sleep(1)

        snap("03-tasks")

        // ────────────────────────────────────────────
        // Step 4: Hospital Bag Tab
        // ────────────────────────────────────────────
        let bagTab = app.tabBars.buttons["待产包"]
        XCTAssertTrue(bagTab.waitForExistence(timeout: 3))
        bagTab.tap()
        sleep(1)

        snap("04-hospital-bag")

        // ────────────────────────────────────────────
        // Step 5: Knowledge Tab
        // ────────────────────────────────────────────
        let knowledgeTab = app.tabBars.buttons["知识"]
        XCTAssertTrue(knowledgeTab.waitForExistence(timeout: 3))
        knowledgeTab.tap()
        sleep(1)

        snap("05-knowledge")

        // ────────────────────────────────────────────
        // Step 6: Tap into the first knowledge article
        // ────────────────────────────────────────────
        // Articles live inside a ScrollView; try tapping the first cell.
        let firstArticle = app.scrollViews.firstMatch.buttons.firstMatch
        if firstArticle.waitForExistence(timeout: 3) {
            firstArticle.tap()
            sleep(1)
            snap("06-article-detail")

            // Navigate back (NavigationStack back button or swipe)
            if app.navigationBars.buttons.firstMatch.exists {
                app.navigationBars.buttons.firstMatch.tap()
            }
        } else {
            // No articles seeded — take a note but don't fail
            snap("06-no-articles")
        }

        // ────────────────────────────────────────────
        // Step 7: Kegel exercise from Tasks tab
        // ────────────────────────────────────────────
        tasksTab.tap()
        sleep(1)

        let kegelText = app.staticTexts["凯格尔运动"]
        if kegelText.waitForExistence(timeout: 3) {
            kegelText.tap()
            sleep(1)
            snap("07-kegel")

            // Dismiss the full-screen cover
            let closeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '关闭' OR label CONTAINS[c] 'close' OR label CONTAINS[c] '返回' OR label CONTAINS[c] '完成'")).firstMatch
            if closeButton.waitForExistence(timeout: 2) {
                closeButton.tap()
            } else if app.navigationBars.buttons.firstMatch.exists {
                app.navigationBars.buttons.firstMatch.tap()
            } else {
                // Swipe down to dismiss full-screen cover
                app.swipeDown()
            }
            sleep(1)
        } else {
            snap("07-kegel-not-found")
        }

        // ────────────────────────────────────────────
        // Step 8: Lamaze exercise from Tasks tab
        // ────────────────────────────────────────────
        let lamazeText = app.staticTexts["拉玛泽呼吸"]
        if lamazeText.waitForExistence(timeout: 3) {
            lamazeText.tap()
            sleep(1)
            snap("08-lamaze")

            let closeLamaze = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '关闭' OR label CONTAINS[c] 'close' OR label CONTAINS[c] '返回' OR label CONTAINS[c] '完成'")).firstMatch
            if closeLamaze.waitForExistence(timeout: 2) {
                closeLamaze.tap()
            } else if app.navigationBars.buttons.firstMatch.exists {
                app.navigationBars.buttons.firstMatch.tap()
            } else {
                app.swipeDown()
            }
            sleep(1)
        } else {
            snap("08-lamaze-not-found")
        }

        // ────────────────────────────────────────────
        // Done!
        // ────────────────────────────────────────────
        snap("09-final-state")
    }

    // MARK: - Quick Smoke Test (skip onboarding)

    /// A lighter test that uses -skip-onboarding launch arg
    /// and verifies each tab renders without crashing.
    func testTabNavigationSmoke() throws {
        // Re-launch with skip-onboarding
        app.terminate()
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        let homeTab = app.tabBars.buttons["首页"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        snap("smoke-home")

        app.tabBars.buttons["任务"].tap()
        sleep(1)
        snap("smoke-tasks")

        app.tabBars.buttons["待产包"].tap()
        sleep(1)
        snap("smoke-hospital-bag")

        app.tabBars.buttons["知识"].tap()
        sleep(1)
        snap("smoke-knowledge")
    }
}
