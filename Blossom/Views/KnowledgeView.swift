//
//  KnowledgeView.swift
//  Blossom (如期)
//
//  Tab 4 - 知识：分娩知识卡片
//

import SwiftUI
import SwiftData

struct KnowledgeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \KnowledgeArticle.sortOrder) private var articles: [KnowledgeArticle]
    
    @State private var searchText = ""
    
    private var categories: [String] {
        ["拉玛泽呼吸法", "凯格尔运动", "分娩信号", "入院时机", "产程阶段", "产后护理"]
    }
    
    private var filteredArticles: [KnowledgeArticle] {
        if searchText.isEmpty {
            return articles
        }
        return articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    // 分类卡片 (2列)
                    categoryGrid
                    
                    // 热门文章
                    hotArticlesSection
                }
                .padding(.horizontal, AppSpacing.pageHorizontal)
                .padding(.vertical, AppSpacing.pageVertical)
            }
            .pageBackground()
            .navigationTitle("知识")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "搜索文章")
            .onAppear {
                if articles.isEmpty {
                    seedDefaultArticles()
                }
            }
        }
    }
    
    // MARK: - Category Grid
    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("分类")
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n900)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: AppSpacing.cardSpacing),
                GridItem(.flexible(), spacing: AppSpacing.cardSpacing)
            ], spacing: AppSpacing.cardSpacing) {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: CategoryArticlesView(category: category)) {
                        CategoryCard(
                            category: category,
                            articleCount: articles.filter { $0.category == category }.count
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Hot Articles Section
    private var hotArticlesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("热门文章")
                .font(AppFonts.cardTitle)
                .foregroundStyle(Color.n900)
            
            VStack(spacing: AppSpacing.md) {
                ForEach(articles.prefix(3)) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleCard(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Seed Default Articles
    private func seedDefaultArticles() {
        let defaultArticles: [(String, String, String, Int)] = [
            // 拉玛泽呼吸法 (6篇)
            ("拉玛泽呼吸法", "第 1 阶段：清洁呼吸", "宫缩前后的深呼吸方法，帮助放松身心...", 3),
            ("拉玛泽呼吸法", "第 2 阶段：胸式呼吸", "适用于宫口开 0-3cm 的阶段，缓慢深呼吸...", 3),
            ("拉玛泽呼吸法", "第 3 阶段：节律呼吸", "适用于宫口开 3-8cm，随宫缩加速呼吸...", 3),
            ("拉玛泽呼吸法", "第 4 阶段：喘息呼吸", "适用于宫口开 7-10cm，浅快呼吸（嘻嘻呼）...", 3),
            ("拉玛泽呼吸法", "第 5 阶段：吹气呼吸", "想用力但不能用力时，像吹蜡烛一样呼气...", 3),
            ("拉玛泽呼吸法", "第 6 阶段：用力呼吸", "宫口全开后，深吸气憋住用力推...", 3),
            
            // 凯格尔运动 (2-3篇)
            ("凯格尔运动", "凯格尔运动的科学原理", "凯格尔运动通过锻炼盆底肌群，帮助产后恢复...", 4),
            ("凯格尔运动", "如何正确做凯格尔运动", "很多人做凯格尔运动时方法不对，这里教你正确姿势...", 5),
        ]
        
        for (index, article) in defaultArticles.enumerated() {
            let knowledgeArticle = KnowledgeArticle(
                category: article.0,
                title: article.1,
                content: article.2,
                readTimeMinutes: article.3,
                sortOrder: index
            )
            modelContext.insert(knowledgeArticle)
        }
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: String
    let articleCount: Int
    
    private var icon: String {
        switch category {
        case "拉玛泽呼吸法": return "wind"
        case "凯格尔运动": return "figure.strengthtraining.traditional"
        case "分娩信号": return "bell.fill"
        case "入院时机": return "cross.circle.fill"
        case "产程阶段": return "clock.fill"
        case "产后护理": return "heart.fill"
        default: return "book.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.primaryDark)
                .frame(width: 44, height: 44)
                .background(Color.accentLight)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(category)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                    .lineLimit(1)
                
                Text("\(articleCount) 篇文章")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Article Card
struct ArticleCard: View {
    let article: KnowledgeArticle
    
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(AppFonts.cardTitle)
                    .foregroundStyle(Color.n900)
                    .lineLimit(2)
                
                Text("\(article.readTimeMinutes) 分钟阅读")
                    .font(AppFonts.caption)
                    .foregroundStyle(Color.n500)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.n300)
        }
        .padding(AppSpacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Category Articles View
struct CategoryArticlesView: View {
    let category: String
    @Query private var articles: [KnowledgeArticle]
    
    init(category: String) {
        self.category = category
        _articles = Query(filter: #Predicate<KnowledgeArticle> { article in
            article.category == category
        }, sort: \KnowledgeArticle.sortOrder)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                ForEach(articles) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        ArticleCard(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Article Detail View
struct ArticleDetailView: View {
    @Bindable var article: KnowledgeArticle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                // Article content
                Text(article.content)
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color.n700)
                    .lineSpacing(6)
                
                // Disclaimer
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("⚠️ 免责声明：本文内容仅供参考，不构成医学建议。如有疑问，请咨询专业医生。")
                        .font(AppFonts.smallLabel)
                        .foregroundStyle(Color.n500)
                }
                
                Spacer(minLength: 40)
                
                // Actions
                if article.category == "拉玛泽呼吸法" || article.category == "凯格尔运动" {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("开始跟练")
                        }
                        .font(AppFonts.cardTitle)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary600)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.full))
                    }
                }
            }
            .padding(.horizontal, AppSpacing.pageHorizontal)
            .padding(.vertical, AppSpacing.pageVertical)
        }
        .pageBackground()
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { article.isFavorited.toggle() }) {
                    Image(systemName: article.isFavorited ? "heart.fill" : "heart")
                        .foregroundStyle(article.isFavorited ? Color.error : Color.n700)
                }
            }
        }
        .onAppear {
            article.isRead = true
        }
    }
}

#Preview {
    KnowledgeView()
        .modelContainer(for: KnowledgeArticle.self, inMemory: true)
}
