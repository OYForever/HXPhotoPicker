//
//  PhotoManager+Language.swift
//  HXPhotoPicker
//
//  Created by Slience on 2020/12/29.
//  Copyright © 2020 Silence. All rights reserved.
//

import Foundation

extension PhotoManager {
    /// 创建语言Bundle
    /// - Parameter languageType: 对应的语言类型
    /// - Returns: 语言Bundle
    @discardableResult
    public func createLanguageBundle(languageType: LanguageType) -> Bundle? {
        if bundle == nil {
            createBundle()
        }
        
        // 语言类型没变化时直接返回现有的 Bundle
        guard self.languageType != languageType || languageBundle == nil else {
            return languageBundle
        }
        
        // 创建新的语言 Bundle
        languageBundle = nil
        
        switch languageType {
        case let .custom(bundle):
            languageBundle = bundle
            
        case .system:
            // 先尝试匹配自定义语言
            for customLanguage in customLanguages {
                if Locale.preferredLanguages.first(where: { $0.hasPrefix(customLanguage.language) }) != nil {
                    languageBundle = customLanguage.bundle
                    break
                }
            }
            // 如果没有匹配到自定义语言，使用系统语言
            if languageBundle == nil {
                let systemLanguage = systemLanguageIdentifier
                languageBundle = bundle?.path(forResource: systemLanguage, ofType: "lproj").flatMap(Bundle.init)
            }
            
        default:
            // 使用语言类型的标准标识符
            languageBundle = bundle?.path(forResource: languageType.stringValue, ofType: "lproj").flatMap(Bundle.init)
        }
        if languageBundle == nil {
            let systemLanguage = systemLanguageIdentifier
            languageBundle = bundle?.path(forResource: "en", ofType: "lproj").flatMap(Bundle.init)
        }
        self.languageType = languageType
        return languageBundle
    }
    
    /// 获取系统语言标识符
    private var systemLanguageIdentifier: String {
        if #available(iOS 16, *) {
            let language = Locale.current.language
            let languageCode = language.languageCode?.identifier ?? "en"
            
            // 处理中文特殊情况
            if languageCode == "zh" {
                let script = language.script?.identifier ?? ""
                return "\(languageCode)-\(script)" // zh-Hans 或 zh-Hant
            }
            
            // 处理巴西葡萄牙语特殊情况
            if languageCode == "pt" && language.region?.identifier == "BR" {
                return "pt-BR"
            }
            
            return languageCode
            
        } else {
            // iOS 16 之前的处理方式
            let languageCode = Locale.current.languageCode ?? "en"
            
            // 处理中文特殊情况
            if languageCode == "zh" {
                if let script = Locale.current.scriptCode {
                    return "\(languageCode)-\(script)"
                }
                // 通过首选语言列表判断简繁体
                return Locale.preferredLanguages.first?.contains("Hans") == true ? "zh-Hans" : "zh-Hant"
            }
            
            // 处理巴西葡萄牙语特殊情况
            if languageCode == "pt" && Locale.current.regionCode == "BR" {
                return "pt-BR"
            }
            
            return languageCode
        }
    }
}
