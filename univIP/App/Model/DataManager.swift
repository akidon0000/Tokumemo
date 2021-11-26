//
//  DataManager.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/10.
//  Copyright © 2021年　akidon0000
//

import Foundation
import KeychainAccess

final class DataManager {
    
    ///
    /// アプリの共通データ（シングルトンのため、必ず同じインスタンスを参照している）
    ///
    public var forwardDisplayUrl = ""               // 1つ前のURL
    public var displayUrl = ""                      // 現在表示しているURL
    public var isLoggedIn = false                   // ログインしているか
    public var allCellList:[[CellList]] =  [[], []] // SettingViewのCell内容（ViewModelではその都度インスタンスが生成される為）
    public var isSyllabusSearchOnce = false           // Syllabusの検索を1度きりにする
    ///
    
    static let singleton = DataManager() // シングルトン・インタンス
    
    private let model = Model()
    private var userDefaults = UserDefaults.standard
    
    
    
    public var isFirstTime: Bool { get { return version.isEmpty }}
    
    public var isRegistrantCheck: Bool { get { return !(cAccount.isEmpty || password.isEmpty) }}
    // 利用規約同意者か判定
    public var isAgreementPersonDecision: Bool { get { return agreementVersion == model.agreementVersion }}
    

    

    
    
    /// KeychainAccess インスタンス
    public var keychain: Keychain {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
            return Keychain(service: "")
        }
        return Keychain(service: identifier)
    }
    
    /// GET (keyChain)
    private func getKeyChain(key:String) -> String {
        do {
            if let value = try keychain.get(key) {
                return value
            }
            AKLog(level: .ERROR, message: "error: Datamanager.getKeyChain do")
            return ""
        } catch {
            AKLog(level: .ERROR, message: "error: Datamanager.getKeyChain catch")
            return ""
        }
    }
    
    /// SET (keyChain)
    private func setKeyChain(key:String, value:String) {
        do {
            try keychain
                .accessibility(Accessibility.alwaysThisDeviceOnly)  // 常時アクセス可能、デバイス限定
                .set(value, key: key)
        } catch {
            AKLog(level: .ERROR, message: "error: Datamanager.setKeyChain")
            print("error: Datamanager.setKeyChain")
            return
        }
    }
    
    /// cAccount
    private let KEY_cAccount = "KEY_cAccount"
    public var cAccount: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }
    
    /// password
    private let KEY_passWord = "KEY_passWord"
    public var password: String {
        get { return getKeyChain(key: KEY_passWord) }
        set(v) { setKeyChain(key: KEY_passWord, value: v) }
    }
    
    
    /// GET (UserDefaults)
    private func getUserDefaultsString(key:String) -> String {
        if let value = userDefaults.string(forKey: key) {
            return value
        }
        AKLog(level: .ERROR, message: "error: Datamanager.getUserDefaults")
        return ""
    }
    
    /// SET (UserDefaults)
    private func setUserDefaultsString(key:String, value:String) {
        userDefaults.set(value ,forKey: key)
    }
    
    
    /// agreementversion
    private let KEY_AgreementVersion = "KEY_AgreementVersion"
    public var agreementVersion: String {
        get { return getUserDefaultsString(key: KEY_AgreementVersion) }
        set(v) { setUserDefaultsString(key: KEY_AgreementVersion, value: v) }
    }
    
    private let KEY_courceManagement = "KEY_corceManagement"
    public var courceManagement: String {
        get { return getUserDefaultsString(key: KEY_courceManagement) }
        set(v) { setUserDefaultsString(key: KEY_courceManagement, value: v) }
    }

    
    private let KEY_manaba = "KEY_manaba"
    public var manaba: String {
        get { return getUserDefaultsString(key: KEY_manaba) }
        set(v) { setUserDefaultsString(key: KEY_manaba, value: v) }
    }

    private let KEY_version = "KEY_version"
    public var version: String {
        get { return getUserDefaultsString(key: KEY_version) }
        set(v) { setUserDefaultsString(key: KEY_version, value: v) }
    }
    
    /// GET (UserDefaults)
    private func getUserDefaultsData(key:String) -> Data {
        if let value = userDefaults.data(forKey: key) {
            return value
        }
        AKLog(level: .ERROR, message: "error: Datamanager.getUserDefaults")
        return Data()
    }
    
    /// SET (UserDefaults)
    private func setUserDefaultsData(key:String, value:Data) {
        userDefaults.set(value ,forKey: key)
    }
    
    private let KEY_settingCellList = "KEY_settingCellList"
    public var settingCellList: Data {
        get { return getUserDefaultsData(key: KEY_settingCellList) }
        set(v) { setUserDefaultsData(key: KEY_settingCellList, value: v) }
    }

}
