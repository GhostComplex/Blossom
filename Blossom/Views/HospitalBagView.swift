//
//  HospitalBagView.swift
//  Blossom (拾月)
//
//  Tab 3 - 待产包：Checklist 管理
//

import SwiftUI
import SwiftData

struct HospitalBagView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HospitalBagItem.sortOrder) private var items: [HospitalBagItem]
    
    @State private var showAddItem = false
    @State private var hideCompleted = false
    
    private var categories: [String] {
        HospitalBagCategory.allCases.map { $0.rawValue }
    }
    
    private var totalCount: Int { items.count }
    private var completedCount: Int { items.filter { $0.isCompleted }.count }
    private var progress: Double {
        totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // 进度卡片
                    progressCard
                    
                    // 分类列表
                    ForEach(categories, id: \.self) { category in
                        categorySection(category)
                    }
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .pageBackground()
            .navigationTitle("待产包")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddItem = true }) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.n700)
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddHospitalBagItemView()
            }
            .onAppear {
                if items.isEmpty {
                    seedDefaultItems()
                }
            }
        }
    }
    
    // MARK: - Progress Card
    private var progressCard: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("已准备 \(completedCount) / \(totalCount) 项")
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color.n500)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AppRadius.full)
                        .fill(Color.n200)
                        .frame(height: 10)
                    
                    RoundedRectangle(cornerRadius: AppRadius.full)
                        .fill(progress >= 1.0 ? AnyShapeStyle(Color.success) : AnyShapeStyle(LinearGradient.progressBar))
                        .frame(width: geometry.size.width * progress, height: 10)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 10)
            
            // 隐藏已完成开关
            Toggle(isOn: $hideCompleted) {
                Text("隐藏已准备")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
            .toggleStyle(SwitchToggleStyle(tint: Color.primary600))
        }
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
    
    // MARK: - Category Section
    private func categorySection(_ category: String) -> some View {
        let categoryItems = items.filter { $0.category == category }
        let filteredItems = hideCompleted ? categoryItems.filter { !$0.isCompleted } : categoryItems
        let categoryCompleted = categoryItems.filter { $0.isCompleted }.count
        
        return VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Category header
            HStack {
                Image(systemName: categoryIcon(category))
                    .font(.system(size: 16))
                    .foregroundStyle(Color.primary600)
                Text(category)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                
                Spacer()
                
                Text("(\(categoryCompleted)/\(categoryItems.count))")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
            
            // Items
            if filteredItems.isEmpty {
                if hideCompleted && categoryCompleted == categoryItems.count {
                    Text("全部已准备 ✓")
                        .font(AppFonts.caption)
                        .foregroundStyle(Color.success)
                        .padding(.vertical, 8)
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(filteredItems) { item in
                        HospitalBagItemRow(item: item)
                        
                        if item.id != filteredItems.last?.id {
                            Divider()
                                .background(Color.n200)
                        }
                    }
                }
                .glassCard()
            }
        }
    }
    
    private func categoryIcon(_ category: String) -> String {
        HospitalBagCategory(rawValue: category)?.icon ?? "shippingbox.fill"
    }
    
    // MARK: - Seed Default Items
    private func seedDefaultItems() {
        let defaultItems: [(String, String, Int, String)] = [
            // 证件类
            ("证件类", "身份证", 2, "夫妻双方"),
            ("证件类", "准生证", 1, ""),
            ("证件类", "医保卡", 1, ""),
            ("证件类", "病历本", 1, ""),
            ("证件类", "产检报告", 1, "B超单、化验单"),
            
            // 妈妈用品
            ("妈妈用品", "月子服", 2, ""),
            ("妈妈用品", "哺乳文胸", 2, ""),
            ("妈妈用品", "一次性内裤", 10, ""),
            ("妈妈用品", "产褥垫", 2, "包"),
            ("妈妈用品", "产妇卫生巾", 2, "包"),
            ("妈妈用品", "吸奶器", 1, ""),
            ("妈妈用品", "防溢乳垫", 1, "盒"),
            ("妈妈用品", "乳头霜", 1, ""),
            ("妈妈用品", "束腹带", 1, ""),
            ("妈妈用品", "月子帽", 1, ""),
            ("妈妈用品", "月子鞋", 1, ""),
            ("妈妈用品", "吸管杯", 1, ""),
            ("妈妈用品", "保温杯", 1, ""),
            ("妈妈用品", "巧克力/红牛", 1, "补充能量"),
            ("妈妈用品", "护肤品", 1, "基础保湿"),
            ("妈妈用品", "产后修复用品", 1, ""),
            ("妈妈用品", "卫生纸", 2, "提"),
            ("妈妈用品", "湿巾", 2, "包"),
            ("妈妈用品", "餐具", 1, "碗筷勺"),
            ("妈妈用品", "梳子、发圈", 1, ""),
            
            // 宝宝用品
            ("宝宝用品", "纸尿裤 NB 号", 1, "包"),
            ("宝宝用品", "湿巾", 2, "包"),
            ("宝宝用品", "奶瓶", 2, "玻璃/PPSU"),
            ("宝宝用品", "奶粉（备用）", 1, "罐"),
            ("宝宝用品", "奶瓶刷", 1, ""),
            ("宝宝用品", "奶瓶清洁剂", 1, ""),
            ("宝宝用品", "婴儿衣服 NB 码", 3, "套"),
            ("宝宝用品", "包被", 2, ""),
            ("宝宝用品", "抱被", 1, ""),
            ("宝宝用品", "婴儿帽子", 2, ""),
            ("宝宝用品", "小毛巾", 5, ""),
            ("宝宝用品", "浴巾", 2, ""),
            ("宝宝用品", "隔尿垫", 2, ""),
            ("宝宝用品", "婴儿护臀膏", 1, ""),
            ("宝宝用品", "婴儿沐浴露", 1, ""),
            ("宝宝用品", "婴儿洗衣液", 1, ""),
            ("宝宝用品", "婴儿指甲剪", 1, ""),
            ("宝宝用品", "体温计", 1, ""),
            
            // 住院用品
            ("住院用品", "毛巾", 3, ""),
            ("住院用品", "拖鞋", 2, "双"),
            ("住院用品", "脸盆", 2, ""),
            ("住院用品", "牙刷牙膏", 1, "套"),
            ("住院用品", "洗发水沐浴露", 1, ""),
            ("住院用品", "纸巾", 3, "盒"),
            ("住院用品", "垃圾袋", 1, "卷"),
            
            // 其他
            ("其他用品", "手机充电器", 2, ""),
            ("其他用品", "充电宝", 1, ""),
            ("其他用品", "相机", 1, "记录宝宝出生"),
            ("其他用品", "笔记本、笔", 1, ""),
            ("其他用品", "零钱", 1, ""),
            ("其他用品", "红包", 1, "给医护人员"),
            ("其他用品", "靠垫", 1, "分娩时用"),
            ("其他用品", "大袋子", 1, "装东西回家"),
        ]
        
        for (index, item) in defaultItems.enumerated() {
            let bagItem = HospitalBagItem(
                category: item.0,
                name: item.1,
                quantity: item.2,
                note: item.3,
                sortOrder: index
            )
            modelContext.insert(bagItem)
        }
    }
}

// MARK: - Hospital Bag Item Row
struct HospitalBagItemRow: View {
    @Bindable var item: HospitalBagItem
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Checkbox
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundStyle(item.isCompleted ? Color.success : Color.n300)
            
            // Item info
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(item.name)
                        .font(AppFonts.bodyText)
                        .foregroundStyle(item.isCompleted ? Color.n500 : Color.n900)
                        .strikethrough(item.isCompleted)
                    
                    if item.quantity > 1 {
                        Text("×\(item.quantity)")
                            .font(AppFonts.smallLabel)
                            .foregroundStyle(Color.n500)
                    }
                }
                
                if !item.note.isEmpty {
                    Text(item.note)
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.n500)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.cardPadding)
        .padding(.vertical, AppSpacing.md)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                item.isCompleted.toggle()
            }
            if item.isCompleted {
                NotificationManager.shared.onTaskCompleted()
            }
        }
    }
}

// MARK: - Add Item View (Placeholder)
struct AddHospitalBagItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("添加物品")
                .navigationTitle("添加物品")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("取消") { dismiss() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("添加") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    HospitalBagView()
        .modelContainer(for: HospitalBagItem.self, inMemory: true)
}
