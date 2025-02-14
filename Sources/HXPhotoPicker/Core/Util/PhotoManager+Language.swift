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
                if Bundle.main.preferredLocalizations.first(where: { $0 == customLanguage.language }) != nil {
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
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
}
