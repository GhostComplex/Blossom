//
//  Models.swift
//  Blossom (拾月)
//
//  SwiftData Models based on PRD v2.1
//

import Foundation
import SwiftData

// MARK: - User Profile
@Model
final class UserProfile {
    var id: UUID
    var dueDate: Date              // 预产期
    var createdAt: Date            // 首次安装日期 (for Kegel level)
    var kegelLevelOverride: Int?   // 手动调整的级别 (nil = 自动)
    
    init(dueDate: Date) {
        self.id = UUID()
        self.dueDate = dueDate
        self.createdAt = Date()
        self.kegelLevelOverride = nil
    }
    
    // 计算当前孕周
    var currentPregnancyWeek: (week: Int, day: Int) {
        let calendar = Calendar.current
        let today = Date()
        // 280 days = 40 weeks pregnancy
        guard let conceptionDate = calendar.date(byAdding: .day, value: -280, to: dueDate) else {
            return (0, 0)
        }
        let days = calendar.dateComponents([.day], from: conceptionDate, to: today).day ?? 0
        return (week: max(0, days / 7), day: max(0, days % 7))
    }
    
    // 距离预产期还有多少天
    var daysUntilDue: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let due = calendar.startOfDay(for: dueDate)
        return calendar.dateComponents([.day], from: today, to: due).day ?? 0
    }
    
    // 当前凯格尔级别 (根据首次安装日期自动推进)
    // 第 1-7 天: 初级, 第 8-21 天: 中级, 第 22 天起: 高级
    var currentKegelLevel: KegelLevel {
        if let override = kegelLevelOverride {
            return KegelLevel(rawValue: override) ?? .beginner
        }
        
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        
        switch days {
        case 0..<7:
            return .beginner
        case 7..<21:
            return .intermediate
        default:
            return .advanced
        }
    }
}

// MARK: - Kegel Level
enum KegelLevel: Int, Codable, CaseIterable {
    case beginner = 0      // 初级: 5s 收缩 / 10s 放松
    case intermediate = 1  // 中级: 7s 收缩 / 14s 放松
    case advanced = 2      // 高级: 10s 收缩 / 20s 放松
    
    var displayName: String {
        switch self {
        case .beginner: return "🌱 初级"
        case .intermediate: return "🌿 中级"
        case .advanced: return "🌳 高级"
        }
    }
    
    var contractDuration: Int {
        switch self {
        case .beginner: return 5
        case .intermediate: return 7
        case .advanced: return 10
        }
    }
    
    var relaxDuration: Int {
        contractDuration * 2  // 1:2 ratio
    }
    
    var totalSets: Int { 10 }
}

// MARK: - Daily Task
@Model
final class DailyTask {
    var id: UUID
    var date: Date                    // 日期 (只保留年月日)
    var kegelCompleted: Bool
    var kegelCompletedAt: Date?
    var kegelSets: Int
    var lamazeCompleted: Bool
    var lamazeCompletedAt: Date?
    var lamazePracticeTime: Int       // 练习时长(秒)
    
    init(date: Date) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.kegelCompleted = false
        self.kegelCompletedAt = nil
        self.kegelSets = 0
        self.lamazeCompleted = false
        self.lamazeCompletedAt = nil
        self.lamazePracticeTime = 0
    }
}

// MARK: - Fetal Movement Record
@Model
final class FetalMovementRecord {
    var id: UUID
    var timestamp: Date
    var count: Int
    
    init(count: Int) {
        self.id = UUID()
        self.timestamp = Date()
        self.count = count
    }
}

// MARK: - Hospital Bag Item
@Model
final class HospitalBagItem {
    var id: UUID
    var category: String              // 证件类/妈妈用品/宝宝用品/住院用品/其他
    var name: String
    var quantity: Int
    var note: String
    var isCompleted: Bool
    var sortOrder: Int                // 排序顺序
    var isCustom: Bool                // 是否用户自定义
    
    init(category: String, name: String, quantity: Int = 1, note: String = "", sortOrder: Int = 0, isCustom: Bool = false) {
        self.id = UUID()
        self.category = category
        self.name = name
        self.quantity = quantity
        self.note = note
        self.isCompleted = false
        self.sortOrder = sortOrder
        self.isCustom = isCustom
    }
}

// MARK: - Hospital Bag Category
enum HospitalBagCategory: String, CaseIterable {
    case documents = "证件类"
    case momItems = "妈妈用品"
    case babyItems = "宝宝用品"
    case hospitalItems = "住院用品"
    case others = "其他用品"
    
    var icon: String {
        switch self {
        case .documents: return "📋"
        case .momItems: return "👩"
        case .babyItems: return "👶"
        case .hospitalItems: return "🏥"
        case .others: return "📦"
        }
    }
}

// MARK: - Knowledge Article
@Model
final class KnowledgeArticle {
    var id: UUID
    var category: String              // 拉玛泽呼吸法/凯格尔运动/分娩信号...
    var title: String
    var content: String
    var readTimeMinutes: Int
    var sortOrder: Int
    var isFavorited: Bool
    var isRead: Bool
    
    init(category: String, title: String, content: String, readTimeMinutes: Int = 3, sortOrder: Int = 0) {
        self.id = UUID()
        self.category = category
        self.title = title
        self.content = content
        self.readTimeMinutes = readTimeMinutes
        self.sortOrder = sortOrder
        self.isFavorited = false
        self.isRead = false
    }
}

// MARK: - Lamaze Stage
enum LamazeStage: Int, CaseIterable {
    case cleansingBreath = 1     // 清洁呼吸
    case chestBreathing = 2      // 胸式呼吸
    case rhythmicBreathing = 3   // 节律呼吸
    case pantingBreathing = 4    // 喘息呼吸
    case blowingBreathing = 5    // 吹气呼吸
    case pushingBreathing = 6    // 用力呼吸
    
    var displayName: String {
        switch self {
        case .cleansingBreath: return "清洁呼吸"
        case .chestBreathing: return "胸式呼吸"
        case .rhythmicBreathing: return "节律呼吸"
        case .pantingBreathing: return "喘息呼吸"
        case .blowingBreathing: return "吹气呼吸"
        case .pushingBreathing: return "用力呼吸"
        }
    }
    
    var description: String {
        switch self {
        case .cleansingBreath: return "宫缩前后深呼吸"
        case .chestBreathing: return "0-3cm，缓慢深呼吸"
        case .rhythmicBreathing: return "3-8cm，随宫缩加速"
        case .pantingBreathing: return "7-10cm，浅快（嘻嘻呼）"
        case .blowingBreathing: return "想用力但不能用力，吹蜡烛"
        case .pushingBreathing: return "全开，深吸气憋住用力"
        }
    }
    
    // 呼吸节奏 (吸气秒数, 呼气秒数)
    var breathingRhythm: (inhale: Double, exhale: Double) {
        switch self {
        case .cleansingBreath: return (4, 6)
        case .chestBreathing: return (4, 4)
        case .rhythmicBreathing: return (3, 3)
        case .pantingBreathing: return (1, 1)
        case .blowingBreathing: return (2, 4)
        case .pushingBreathing: return (6, 2)
        }
    }
    
    var cycleCount: Int { 6 }  // 每阶段练习次数
}
