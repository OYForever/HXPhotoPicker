//
//  PhotoManager+Language.swift
//  HXPhotoPicker
//
//  Created by Slience on 2020/12/29.
//  Copyright © 2020 Silence. All rights reserved.
//

import Foundation

extension PhotoManager {
    @discardableResult
    public func createLanguageBundle(languageType: LanguageType) -> Bundle? {
        if bundle == nil {
            createBundle()
        }
        
        guard self.languageType != languageType || languageBundle == nil else {
            return languageBundle
        }
        
        languageBundle = nil
        
        switch languageType {
        case let .custom(bundle):
            languageBundle = bundle
            
        case .system:
            // 先尝试匹配系统首选语言列表中的自定义语言
            if let systemLanguage = Locale.preferredLanguages.first {
                let normalizedLanguage = normalizeLanguageIdentifier(systemLanguage)
                // 检查自定义语言
                for customLanguage in customLanguages {
                    let normalizedCustomLanguage = normalizeLanguageIdentifier(customLanguage.language)
                    if normalizedLanguage == normalizedCustomLanguage {
                        languageBundle = customLanguage.bundle
                        break
                    }
                }
                // 如果没有匹配到自定义语言，使用系统语言
                if languageBundle == nil {
                    languageBundle = bundle?.path(forResource: normalizedLanguage, ofType: "lproj").flatMap(Bundle.init)
                }
            }
            
        default:
            languageBundle = bundle?.path(forResource: languageType.stringValue, ofType: "lproj").flatMap(Bundle.init)
        }
        
        // 如果没有找到对应的语言包，使用系统语言作为后备
        if languageBundle == nil {
            languageBundle = bundle?.path(forResource: systemLanguageIdentifier, ofType: "lproj").flatMap(Bundle.init)
        }
        
        self.languageType = languageType
        return languageBundle
    }
    
    private var systemLanguageIdentifier: String {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return "en" }
        return normalizeLanguageIdentifier(preferredLanguage)
    }
    
    private func normalizeLanguageIdentifier(_ identifier: String) -> String {
        let components = identifier.components(separatedBy: "-")
        let baseLanguage = components[0]
        
        // 特殊处理中文和葡萄牙语等需要区分地区的语言
        if baseLanguage == "zh" {
            return identifier.contains("Hans") ? "zh-Hans" : "zh-Hant"
        }
        if baseLanguage == "pt" && components.count > 1 && components[1] == "BR" {
            return "pt-BR"
        }
        
        return baseLanguage
    }
}
