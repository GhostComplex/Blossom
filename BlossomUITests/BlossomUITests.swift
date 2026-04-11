//
//  BlossomUITests.swift
//  BlossomUITests
//
//  Automated UI walkthrough — simulates a real user tapping through
//  every tab, exercise, and article in the Blossom (拾月) app.
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
        let welcomeTitle = app.staticTexts["欢迎来到拾月"]
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

        // Tap the first unchecked item ("身份证") to mark it complete
        // Items use onTapGesture — can't query as buttons, use staticTexts instead
        sleep(2) // Wait for seedDefaultItems to finish
        let itemText = app.staticTexts["身份证"]
        if !itemText.waitForExistence(timeout: 5) {
            snap("prerequest-02-no-items")
            XCTFail("待产包列表为空 — 找不到『身份证』")
            return
        }
        itemText.tap()
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
    }

    // MARK: - Test 4: Fetal Movement Recording

    /// 任务 Tab → 胎动记录 → +1 三次 → 完成 → 确认弹窗
    func testFetalMovementRecording() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Tasks tab
        let tasksTab = app.tabBars.buttons["任务"]
        XCTAssertTrue(tasksTab.waitForExistence(timeout: 10))
        tasksTab.tap()
        sleep(1)

        // Tap 胎动记录（可选）
        let fetalCard = app.staticTexts["胎动记录（可选）"]
        XCTAssertTrue(fetalCard.waitForExistence(timeout: 5), "应能找到『胎动记录（可选）』")
        fetalCard.tap()
        sleep(1)

        snap("fetal-01-sheet")

        // Tap +1 button three times
        let plusButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'plus'")).firstMatch
        if !plusButton.waitForExistence(timeout: 3) {
            // Try finding the circle button by image
            let circleButton = app.images["plus"].firstMatch
            XCTAssertTrue(circleButton.waitForExistence(timeout: 3), "+1 按钮应存在")
            circleButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
            circleButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
            circleButton.tap()
        } else {
            plusButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
            plusButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
            plusButton.tap()
        }
        sleep(1)

        snap("fetal-02-count-3")

        // Tap 完成
        let doneButton = app.buttons["完成"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3), "『完成』按钮应存在")
        doneButton.tap()
        sleep(1)

        // Verify confirmation alert
        let successAlert = app.staticTexts["✓ 记录成功"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 3), "应显示『✓ 记录成功』弹窗")

        snap("fetal-03-success")

        // Tap 好的 to dismiss
        let okButton = app.buttons["好的"]
        XCTAssertTrue(okButton.exists, "『好的』按钮应存在")
        okButton.tap()
        sleep(1)

        snap("fetal-04-dismissed")
    }

    // MARK: - Test 5: Hospital Bag Check/Uncheck

    /// 待产包 Tab → 勾选身份证 → 截图 → 取消勾选 → 截图 → 验证进度条
    func testHospitalBagCheckUncheck() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Hospital Bag tab
        let bagTab = app.tabBars.buttons["待产包"]
        XCTAssertTrue(bagTab.waitForExistence(timeout: 10))
        bagTab.tap()
        sleep(2) // Wait for seedDefaultItems

        // Verify progress bar exists
        let progressText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] '%'")).firstMatch
        XCTAssertTrue(progressText.waitForExistence(timeout: 3), "进度百分比应可见")

        snap("bag-check-01-initial")

        // Tap 身份证 to check it
        let idCard = app.staticTexts["身份证"]
        XCTAssertTrue(idCard.waitForExistence(timeout: 5), "应能找到『身份证』")
        idCard.tap()
        sleep(1)

        snap("bag-check-02-checked")

        // Dismiss pre-request popup if it appears
        let declineButton = app.buttons["不了，谢谢"]
        if declineButton.waitForExistence(timeout: 2) {
            declineButton.tap()
            sleep(1)
        }

        // Tap 身份证 again to uncheck
        idCard.tap()
        sleep(1)

        snap("bag-check-03-unchecked")
    }

    // MARK: - Test 6: Hospital Bag Add Item

    /// 待产包 Tab → 点 + → 添加物品 sheet → 验证按钮 → 取消
    func testHospitalBagAddItem() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Hospital Bag tab
        let bagTab = app.tabBars.buttons["待产包"]
        XCTAssertTrue(bagTab.waitForExistence(timeout: 10))
        bagTab.tap()
        sleep(1)

        // Tap + button in toolbar
        let addButton = app.navigationBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'plus' OR label CONTAINS[c] '添加' OR label CONTAINS[c] 'Add'")).firstMatch
        if !addButton.waitForExistence(timeout: 3) {
            // Try finding by image name
            let plusButton = app.navigationBars.images["plus"].firstMatch
            XCTAssertTrue(plusButton.waitForExistence(timeout: 3), "右上角 + 按钮应存在")
            plusButton.tap()
        } else {
            addButton.tap()
        }
        sleep(1)

        snap("bag-add-01-sheet")

        // Verify 添加物品 sheet elements
        let sheetTitle = app.staticTexts["添加物品"]
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 3), "应显示『添加物品』标题")

        let cancelButton = app.buttons["取消"]
        let confirmButton = app.buttons["添加"]
        XCTAssertTrue(cancelButton.exists, "『取消』按钮应存在")
        XCTAssertTrue(confirmButton.exists, "『添加』按钮应存在")

        // Tap cancel to close
        cancelButton.tap()
        sleep(1)

        snap("bag-add-02-dismissed")

        // Verify sheet dismissed
        XCTAssertFalse(sheetTitle.exists, "添加物品 sheet 应已关闭")
    }

    // MARK: - Test 7: Article Favorite

    /// 知识 Tab → 第一篇文章 → 点心形收藏 → 截图 → 再点取消
    func testArticleFavorite() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Knowledge tab
        let knowledgeTab = app.tabBars.buttons["知识"]
        XCTAssertTrue(knowledgeTab.waitForExistence(timeout: 10))
        knowledgeTab.tap()
        sleep(2) // Wait for seedDefaultArticles

        // Tap the first category card to see articles
        let firstCategory = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstCategory.waitForExistence(timeout: 5), "应能找到分类卡片")
        firstCategory.tap()
        sleep(1)

        // Tap the first article
        let firstArticle = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstArticle.waitForExistence(timeout: 3), "应能找到文章")
        firstArticle.tap()
        sleep(1)

        snap("favorite-01-article-detail")

        // Tap the heart button to favorite
        let heartButton = app.navigationBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'heart'")).firstMatch
        if !heartButton.waitForExistence(timeout: 3) {
            // Try finding by toolbar button position (trailing)
            let trailingButton = app.navigationBars.buttons.element(boundBy: app.navigationBars.buttons.count - 1)
            XCTAssertTrue(trailingButton.exists, "收藏按钮应存在")
            trailingButton.tap()
        } else {
            heartButton.tap()
        }
        sleep(1)

        snap("favorite-02-favorited")

        // Tap again to unfavorite
        let heartFillButton = app.navigationBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'heart'")).firstMatch
        if heartFillButton.exists {
            heartFillButton.tap()
        } else {
            let trailingButton = app.navigationBars.buttons.element(boundBy: app.navigationBars.buttons.count - 1)
            trailingButton.tap()
        }
        sleep(1)

        snap("favorite-03-unfavorited")
    }

    // MARK: - Test 8: Article Start Exercise

    /// 知识 Tab → 凯格尔文章 → 「开始跟练」→ 验证练习页弹出 → 关闭
    func testArticleStartExercise() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Knowledge tab
        let knowledgeTab = app.tabBars.buttons["知识"]
        XCTAssertTrue(knowledgeTab.waitForExistence(timeout: 10))
        knowledgeTab.tap()
        sleep(2)

        // Find and tap 凯格尔运动 category
        let kegelCategory = app.staticTexts["凯格尔运动"]
        XCTAssertTrue(kegelCategory.waitForExistence(timeout: 5), "应能找到『凯格尔运动』分类")
        kegelCategory.tap()
        sleep(1)

        // Tap the first article in the category
        let firstArticle = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(firstArticle.waitForExistence(timeout: 3), "应能找到凯格尔文章")
        firstArticle.tap()
        sleep(1)

        snap("exercise-01-kegel-article")

        // Scroll down to find 开始跟练 button
        let startButton = app.buttons["开始跟练"]
        if !startButton.waitForExistence(timeout: 3) {
            // Scroll down to find it
            app.swipeUp()
            sleep(1)
        }
        XCTAssertTrue(startButton.waitForExistence(timeout: 3), "『开始跟练』按钮应存在")
        startButton.tap()
        sleep(1)

        snap("exercise-02-kegel-launched")

        // Verify Kegel exercise view is presented
        // Look for elements specific to Kegel exercise view
        let kegelElements = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] '收缩' OR label CONTAINS[c] '放松' OR label CONTAINS[c] '凯格尔' OR label CONTAINS[c] '开始'"))
        XCTAssertTrue(kegelElements.firstMatch.waitForExistence(timeout: 3),
                      "凯格尔练习页面应弹出")

        // Close the exercise
        let closeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '关闭' OR label CONTAINS[c] 'close' OR label CONTAINS[c] '返回' OR label CONTAINS[c] '完成' OR label CONTAINS[c] '结束'")).firstMatch
        if closeButton.waitForExistence(timeout: 2) {
            closeButton.tap()
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

        snap("exercise-03-closed")
    }

    // MARK: - Test 9: Countdown Card Exists on Home

    /// 首页倒计时卡片文字验证
    func testCountdownCardExists() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        let homeTab = app.tabBars.buttons["首页"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 10))
        homeTab.tap()
        sleep(1)

        // Verify countdown text elements
        let countdownLabel = app.staticTexts["距离与宝宝见面"]
        XCTAssertTrue(countdownLabel.waitForExistence(timeout: 5),
                      "应显示『距离与宝宝见面』")

        let dayUnit = app.staticTexts["天"]
        XCTAssertTrue(dayUnit.exists, "应显示『天』单位")

        // Verify 「预产期」label on home (PRD §2.1.2)
        let dueDateLabel = app.staticTexts["预产期"]
        XCTAssertTrue(dueDateLabel.waitForExistence(timeout: 3),
                      "应显示『预产期』文字")

        snap("countdown-01-home")
    }

    // MARK: - Test 10: Kegel Exercise Full Round

    /// 凯格尔 1 组完整流程（等 16 秒）
    func testKegelExerciseFlow() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Tasks tab
        let tasksTab = app.tabBars.buttons["任务"]
        XCTAssertTrue(tasksTab.waitForExistence(timeout: 10))
        tasksTab.tap()
        sleep(1)

        // Tap Kegel exercise
        let kegelText = app.staticTexts["凯格尔运动"]
        XCTAssertTrue(kegelText.waitForExistence(timeout: 5), "应能找到『凯格尔运动』")
        kegelText.tap()
        sleep(1)

        snap("kegel-flow-01-started")

        // Verify contract phase
        let contractText = app.staticTexts["收缩骨盆底肌"]
        XCTAssertTrue(contractText.waitForExistence(timeout: 3),
                      "应显示『收缩骨盆底肌』")

        // Wait for contract phase (5s) + relax phase (10s) + buffer = ~16s
        // This completes 1 full set
        sleep(6) // Wait through contract phase

        snap("kegel-flow-02-relax")

        // Verify relax phase
        let relaxText = app.staticTexts["放松休息"]
        XCTAssertTrue(relaxText.waitForExistence(timeout: 3),
                      "应进入放松阶段")

        sleep(11) // Wait through relax phase

        snap("kegel-flow-03-next-set")

        // After 1 set, should be back to contract phase for set 2
        // Verify completed sets counter updated
        let setsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] '组'")).firstMatch
        XCTAssertTrue(setsText.exists, "应显示组数进度")

        // Close exercise
        let endButton = app.buttons["结束"]
        if endButton.waitForExistence(timeout: 2) {
            endButton.tap()
            sleep(1)
            // Confirm in alert (destructive button)
            let confirmEnd = app.alerts.buttons["结束"]
            if confirmEnd.waitForExistence(timeout: 2) {
                confirmEnd.tap()
            }
        }
        sleep(1)

        snap("kegel-flow-04-closed")
    }

    // MARK: - Test 11: Lamaze Learning Mode

    /// 学习模式 6 阶段列表
    func testLamazeLearningMode() throws {
        app.launchArguments = ["-skip-onboarding"]
        app.launch()

        // Navigate to Tasks tab
        let tasksTab = app.tabBars.buttons["任务"]
        XCTAssertTrue(tasksTab.waitForExistence(timeout: 10))
        tasksTab.tap()
        sleep(1)

        // Tap Lamaze exercise
        let lamazeText = app.staticTexts["拉玛泽呼吸练习"]
        XCTAssertTrue(lamazeText.waitForExistence(timeout: 5), "应能找到『拉玛泽呼吸练习』")
        lamazeText.tap()
        sleep(1)

        snap("lamaze-learn-01-mode-select")

        // Tap 学习模式
        let learningMode = app.staticTexts["学习模式"]
        XCTAssertTrue(learningMode.waitForExistence(timeout: 3), "应能找到『学习模式』")
        learningMode.tap()
        sleep(1)

        snap("lamaze-learn-02-stages")

        // Verify 6 stages title
        let stagesTitle = app.staticTexts["6 阶段呼吸法"]
        XCTAssertTrue(stagesTitle.waitForExistence(timeout: 3),
                      "应显示『6 阶段呼吸法』标题")

        // Verify all 6 stage names exist
        let stageNames = ["清洁呼吸", "胸式呼吸", "节律呼吸", "喘息呼吸", "吹气呼吸", "用力呼吸"]
        for name in stageNames {
            let stageText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", name)).firstMatch
            // Some stages may need scrolling
            if !stageText.exists {
                app.swipeUp()
                Thread.sleep(forTimeInterval: 0.5)
            }
            XCTAssertTrue(stageText.waitForExistence(timeout: 3),
                          "应显示『\(name)』阶段")
        }

        snap("lamaze-learn-03-all-stages")

        // Close
        let closeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '关闭' OR label CONTAINS[c] 'close' OR label CONTAINS[c] '返回' OR label CONTAINS[c] '结束'")).firstMatch
        if closeButton.waitForExistence(timeout: 2) {
            closeButton.tap()
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

        snap("lamaze-learn-04-closed")
    }

    // MARK: - Test 12: Due Date Today (Edge Case)

    /// Onboarding 选今天为预产期 → 倒计时显示 0
    func testDueDateToday() throws {
        // Fresh launch with onboarding
        app.launchArguments = []
        app.launch()

        let welcomeTitle = app.staticTexts["欢迎来到拾月"]
        guard welcomeTitle.waitForExistence(timeout: 10) else {
            // Onboarding already completed — can't test this scenario
            // Mark as skipped
            snap("duedate-today-skipped-no-onboarding")
            return
        }

        snap("duedate-today-01-onboarding")

        // Open date picker
        let dateDisplay = app.buttons["dateDisplay"]
        XCTAssertTrue(dateDisplay.waitForExistence(timeout: 3), "日期选择器应可见")
        dateDisplay.tap()
        sleep(1)

        snap("duedate-today-02-picker")

        // The DatePicker uses .wheel style with range Date()...
        // Today is the minimum date. We need to scroll the picker wheels
        // to select today's date. Since default is ~2 months out,
        // we need to scroll month and day wheels back.
        // Try adjusting the picker wheels to today
        let pickerWheels = app.pickerWheels
        if pickerWheels.count >= 2 {
            // Wheel date picker in zh-Hans typically has: 年/月/日
            // Try to adjust to today's date
            let today = Date()
            let calendar = Calendar.current
            let month = calendar.component(.month, from: today)
            let day = calendar.component(.day, from: today)

            // Adjust month wheel (typically index 1 for zh locale)
            let monthWheel = pickerWheels.element(boundBy: min(1, pickerWheels.count - 1))
            monthWheel.adjust(toPickerWheelValue: "\(month)月")
            Thread.sleep(forTimeInterval: 0.5)

            // Adjust day wheel
            let dayWheel = pickerWheels.element(boundBy: min(2, pickerWheels.count - 1))
            dayWheel.adjust(toPickerWheelValue: "\(day)日")
            Thread.sleep(forTimeInterval: 0.5)
        }

        snap("duedate-today-03-today-selected")

        // Tap 确定 to close picker
        let confirmDate = app.buttons["确定"]
        if confirmDate.waitForExistence(timeout: 3) {
            confirmDate.tap()
            sleep(1)
        }

        // Tap 开始使用
        let ctaButton = app.buttons["开始使用"]
        if !ctaButton.waitForExistence(timeout: 3) {
            let anyButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] '开始使用'")).firstMatch
            XCTAssertTrue(anyButton.exists, "CTA 按钮应存在")
            anyButton.tap()
        } else {
            ctaButton.tap()
        }
        sleep(2)

        snap("duedate-today-04-home")

        // Verify countdown shows 0
        let homeTab = app.tabBars.buttons["首页"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 10))

        let zeroCountdown = app.staticTexts["0"]
        XCTAssertTrue(zeroCountdown.waitForExistence(timeout: 5),
                      "倒计时应显示 0 天")

        let dayUnit = app.staticTexts["天"]
        XCTAssertTrue(dayUnit.exists, "应显示『天』单位")

        snap("duedate-today-05-zero-countdown")
    }
}
