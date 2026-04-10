//
//  ArticleContent.swift
//  Blossom (如期)
//
//  Loads article content from bundled .md files at runtime.
//  To add a new article: drop a .md file into Resources/Articles/
//  with the standard header format (# Title, **分类：**, **阅读时间：**).
//

import Foundation

struct ArticleContent {
    let category: String
    let title: String
    let content: String
    let readTime: Int

    /// All articles loaded from Resources/Articles/*.md, sorted by filename.
    static let allArticles: [ArticleContent] = {
        guard let articlesURL = Bundle.main.url(forResource: "Articles", withExtension: nil),
              let fileURLs = try? FileManager.default.contentsOfDirectory(
                  at: articlesURL,
                  includingPropertiesForKeys: nil
              ) else {
            return []
        }

        return fileURLs
            .filter { $0.pathExtension == "md" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
            .compactMap { url -> ArticleContent? in
                guard let text = try? String(contentsOf: url, encoding: .utf8) else {
                    return nil
                }
                return parse(markdown: text)
            }
    }()

    /// Parse a markdown article with header format:
    /// ```
    /// # Title
    /// **分类：** Category
    /// **阅读时间：** N 分钟
    /// ---
    /// Body content...
    /// ```
    private static func parse(markdown text: String) -> ArticleContent? {
        let lines = text.components(separatedBy: .newlines)

        // Extract title from first # line
        let title = lines.first { $0.hasPrefix("# ") }?
            .dropFirst(2)
            .trimmingCharacters(in: .whitespaces) ?? "未命名"

        // Extract category from **分类：** line
        let category: String = {
            for line in lines {
                if line.contains("**分类") {
                    // Handle both ： and :
                    let cleaned = line
                        .replacingOccurrences(of: "**分类：**", with: "")
                        .replacingOccurrences(of: "**分类:**", with: "")
                        .trimmingCharacters(in: .whitespaces)
                    if !cleaned.isEmpty { return cleaned }
                }
            }
            return "未分类"
        }()

        // Extract read time from **阅读时间：** line
        let readTime: Int = {
            for line in lines {
                if line.contains("阅读时间") {
                    // Find the number
                    let digits = line.unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
                    if let num = Int(String(digits)) { return num }
                }
            }
            return 3 // default
        }()

        // Extract body: everything after first ---
        let body: String = {
            if let range = text.range(of: "\n---\n") {
                return String(text[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return text
        }()

        return ArticleContent(
            category: category,
            title: title,
            content: body,
            readTime: readTime
        )
    }
}
