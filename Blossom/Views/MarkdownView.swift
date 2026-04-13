//
//  MarkdownView.swift
//  Blossom (拾月)
//
//  Simple markdown renderer: splits content by lines and renders
//  headers, bullets, bold, blockquotes, and body paragraphs
//  as native SwiftUI views.
//

import SwiftUI

struct MarkdownView: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                renderBlock(block)
            }
        }
    }

    // MARK: - Block types

    private enum Block {
        case h2(String)
        case h3(String)
        case bullet(String)
        case blockquote(String)
        case divider
        case paragraph(String)
    }

    private var blocks: [Block] {
        var result: [Block] = []
        var currentParagraph = ""

        for line in text.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.isEmpty {
                if !currentParagraph.isEmpty {
                    result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentParagraph = ""
                }
                continue
            }

            if trimmed == "---" || trimmed == "***" || trimmed == "___" {
                if !currentParagraph.isEmpty {
                    result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentParagraph = ""
                }
                result.append(.divider)
            } else if trimmed.hasPrefix("### ") {
                if !currentParagraph.isEmpty {
                    result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentParagraph = ""
                }
                result.append(.h3(String(trimmed.dropFirst(4))))
            } else if trimmed.hasPrefix("## ") {
                if !currentParagraph.isEmpty {
                    result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentParagraph = ""
                }
                result.append(.h2(String(trimmed.dropFirst(3))))
            } else if trimmed.hasPrefix("- ") || trimmed.hasPrefix("* ") {
                if !currentParagraph.isEmpty {
                    result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentParagraph = ""
                }
                result.append(.bullet(String(trimmed.dropFirst(2))))
            } else if trimmed.hasPrefix("> ") {
                if !currentParagraph.isEmpty {
                    result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentParagraph = ""
                }
                result.append(.blockquote(String(trimmed.dropFirst(2))))
            } else {
                if currentParagraph.isEmpty {
                    currentParagraph = trimmed
                } else {
                    currentParagraph += "\n" + trimmed
                }
            }
        }

        if !currentParagraph.isEmpty {
            result.append(.paragraph(currentParagraph.trimmingCharacters(in: .whitespacesAndNewlines)))
        }

        return result
    }

    // MARK: - Rendering

    @ViewBuilder
    private func renderBlock(_ block: Block) -> some View {
        switch block {
        case .h2(let text):
            Text(inlineMarkdown(text))
                .font(.custom("NotoSerifSC-Medium", size: 18))
                .foregroundStyle(Color(hex: "A87CC0"))

        case .h3(let text):
            Text(inlineMarkdown(text))
                .font(.custom("NotoSerifSC-Medium", size: 16))
                .foregroundStyle(Color(hex: "A87CC0"))

        case .bullet(let text):
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color(hex: "C9A0DC"))
                Text(inlineMarkdown(text))
                    .font(AppFonts.bodyText)
                    .foregroundStyle(Color(hex: "7A6E94"))
                    .lineSpacing(9)
            }

        case .blockquote(let text):
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.warning)
                    .frame(width: 3)
                Text(inlineMarkdown(text))
                    .font(AppFonts.smallLabel)
                    .foregroundStyle(Color.n500)
                    .lineSpacing(4)
            }
            .padding(.vertical, 8)

        case .divider:
            Divider()
                .padding(.vertical, 4)

        case .paragraph(let text):
            Text(inlineMarkdown(text))
                .font(AppFonts.bodyText)
                .foregroundStyle(Color(hex: "7A6E94"))
                .lineSpacing(9)
        }
    }

    /// Render inline markdown (bold, italic) using AttributedString
    private func inlineMarkdown(_ text: String) -> AttributedString {
        if let attributed = try? AttributedString(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
            return attributed
        }
        return AttributedString(text)
    }
}
