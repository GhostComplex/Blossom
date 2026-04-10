//
//  BlossomUITests.swift
//  BlossomUITests
//
//  Automated UI walkthrough — simulates a real user tapping through
//  every tab, exercise, and article in the Blossom (如期) app.
//
//  Run with:
//    xcodebuild test -project Blossom.xcodeproj -scheme Blossom \
//      -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
//      -only-testing:BlossomUITests
//

import XCTest

final class BlossomUITests: XCTestCase {

    let app = XCUIApplication()

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        continueAfterFailure = true
        // Terminate any leftover app instance
        app.terminate()
    }

    override func tearDownWithError() throws {
        app.terminate()
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

    // MARK: - Full User Flow (Onboarding → All Tabs → Exercises → Articles)

    func testFullUserFlow() throws {
        // Fresh launch — no launch arguments, show onboarding
        app.launchArguments = []
        app.launch()

        // ────────────────────────────────────────────
        // Step 1: Onboarding
        // ────────────────────────────────────────────
        let welcomeTitle = app.staticTexts["欢迎来到如期"]
        if welcomeTitle.waitForExistence(timeout: 10) {
            snap("01-onboarding")

            // Date display should be visible (tap to open picker)
            let dateDisplay = app.buttons["dateDisplay"]
            XCTAssertTrue(dateDisplay.waitForExistence(timeout: 3),
                          "Date display should be visible on onboarding screen")

            // Tap the CTA button to finish onboarding
            let ctaButton = app.buttons["开始使用"]
            if !ctaButton.waitForExistence(timeout: 3) {
                // Try finding by partial match
                let anyButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '开始使用'")).firstMatch
                XCTAssertTrue(anyButton.exists, "CTA button '开始使用' must exist")
                anyButton.tap()
            } else {
                ctaButton.tap()
            }

            // Give SwiftUI time to transition and SwiftData to persist
            Thread.sleep(forTimeInterval: 2.0)
        } else {
            // Onboarding already completed (e.g. from previous test run)
            // Continue to tab verification
        }

        // ────────────────────────────────────────────
        // Step 2: Home Tab (default after onboarding)
        // ────────────────────────────────────────────
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
        let firstArticle = app.scrollViews.firstMatch.buttons.firstMatch
        if firstArticle.waitForExistence(timeout: 3) {
            firstArticle.tap()
            sleep(1)
            snap("06-article-detail")

            // Navigate back
            if app.navigationBars.buttons.firstMatch.exists {
                app.navigationBars.buttons.firstMatch.tap()
            }
        } else {
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

            // Try to dismiss Kegel
            let closeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '关闭' OR label CONTAINS[c] 'close' OR label CONTAINS[c] '返回' OR label CONTAINS[c] '完成' OR label CONTAINS[c] '结束'")).firstMatch
            if closeButton.waitForExistence(timeout: 2) {
                closeButton.tap()
                // Handle confirmation alert
                let confirmEnd = app.buttons["结束"]
                if confirmEnd.waitForExistence(timeout: 2) {
                    confirmEnd.tap()
                }
            } else if app.navigationBars.buttons.firstMatch.exists {
                app.navigationBars.buttons.firstMatch.tap()
            } else {
                app.swipeDown()
            }
            sleep(2)
        } else {
            snap("07-kegel-not-found")
        }

        // ────────────────────────────────────────────
        // Step 8: Lamaze exercise from Tasks tab
        // ────────────────────────────────────────────
        let lamazeText = app.staticTexts["拉玛泽呼吸练习"]
        if lamazeText.waitForExistence(timeout: 3) {
            lamazeText.tap()
            sleep(1)
            snap("08-lamaze")

            let closeLamaze = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '关闭' OR label CONTAINS[c] 'close' OR label CONTAINS[c] '返回' OR label CONTAINS[c] '完成' OR label CONTAINS[c] '结束'")).firstMatch
            if closeLamaze.waitForExistence(timeout: 2) {
                closeLamaze.tap()
                let confirmEnd = app.buttons["结束"]
                if confirmEnd.waitForExistence(timeout: 2) {
                    confirmEnd.tap()
                }
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
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        let homeTab = app.tabBars.buttons["首页"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 10))
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

    // MARK: - Notification Pre-Request Popup Test

    /// Verifies the pre-request notification popup appears after completing
    /// the first task (checking a hospital bag item).
    func testNotificationPreRequestPopup() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Hospital Bag tab
        let bagTab = app.tabBars.buttons["待产包"]
        XCTAssertTrue(bagTab.waitForExistence(timeout: 10))
        bagTab.tap()
        sleep(1)

        snap("prerequest-01-hospital-bag")

        // Tap the first unchecked item to mark it complete
        // Hospital bag items are buttons with checkbox circles
        let firstItem = app.scrollViews.firstMatch.buttons.firstMatch
        if firstItem.waitForExistence(timeout: 3) {
            firstItem.tap()
            sleep(2)

            snap("prerequest-02-after-check")

            // Verify pre-request popup appears
            let preRequestTitle = app.staticTexts["每天提醒你练习"]
            let preRequestBody = app.staticTexts["每天练几分钟，和宝宝见面那天会更从容。"]
            let acceptButton = app.buttons["好的，提醒我"]
            let declineButton = app.buttons["不了，谢谢"]

            // Check popup elements
            if preRequestTitle.waitForExistence(timeout: 3) {
                snap("prerequest-03-popup-visible")

                XCTAssertTrue(preRequestBody.exists, "预请求弹窗正文应可见")
                XCTAssertTrue(acceptButton.exists, "『好的，提醒我』按钮应可见")
                XCTAssertTrue(declineButton.exists, "『不了，谢谢』按钮应可见")

                // Tap decline to dismiss (don't trigger system permission dialog in test)
                declineButton.tap()
                sleep(1)

                snap("prerequest-04-after-decline")

                // Verify popup dismissed
                XCTAssertFalse(preRequestTitle.exists, "弹窗应已关闭")
            } else {
                snap("prerequest-03-popup-NOT-visible")
                XCTFail("预请求弹窗未出现 — 检查 NotificationManager 逻辑")
            }
        } else {
            snap("prerequest-02-no-items")
            XCTFail("待产包列表为空")
        }
    }
}
