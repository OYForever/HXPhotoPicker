//
//  LanguageType.swift
//  HXPhotoPicker
//
//  Created by Slience on 2021/1/7.
//

import Foundation

public enum LanguageType: Equatable, CustomStringConvertible {
    /// 跟随系统语言
    case system
    /// 中文简体
    case simplifiedChinese
    /// 中文繁体
    case traditionalChinese
    /// 日文
    case japanese
    /// 韩文
    case korean
    /// 英文
    case english
    /// 泰语
    case thai
    /// 印尼语
    case indonesia
    /// 越南语
    case vietnamese
    /// 俄语
    case russian
    /// 德语
    case german
    /// 法语
    case french
    /// 阿拉伯
    case arabic
    /// 葡萄牙语（巴西）
    case portuguese_brazil
    /// 自定义
    case custom(Bundle)
    
    // String 转 LanguageType
    public init(string: String) {
        switch string.lowercased() {
        case "system": self = .system
        case "zh-hans": self = .simplifiedChinese
        case "zh-hant": self = .traditionalChinese
        case "ja": self = .japanese
        case "ko": self = .korean
        case "en": self = .english
        case "th": self = .thai
        case "id": self = .indonesia
        case "vi": self = .vietnamese
        case "ru": self = .russian
        case "de": self = .german
        case "fr": self = .french
        case "ar": self = .arabic
        case "pt-br": self = .portuguese_brazil
        default: self = .system
        }
    }
    
    // LanguageType 转 String
    public var stringValue: String {
        switch self {
        case .system: return "system"
        case .simplifiedChinese: return "zh-Hans"
        case .traditionalChinese: return "zh-Hant"
        case .japanese: return "ja"
        case .korean: return "ko"
        case .english: return "en"
        case .thai: return "th"
        case .indonesia: return "id"
        case .vietnamese: return "vi"
        case .russian: return "ru"
        case .german: return "de"
        case .french: return "fr"
        case .arabic: return "ar"
        case .portuguese_brazil: return "pt-BR"
        case .custom(let bundle): return bundle.bundleIdentifier ?? "custom"
        }
    }
    
    // 实现 CustomStringConvertible 协议
    public var description: String {
        return stringValue
    }
}
