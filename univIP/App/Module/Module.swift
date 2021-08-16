//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class Module: NSObject {
    
    /// ログインURL
    let loginURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    /// 接続切れの際、再リロード
    let lostConnectionUrl : String = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="//83桁 =の後ろに付く(e1s1)は可変
    /// タイムアウト
    let timeOutURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
    /// アンケート催促
    let enqueteReminder :String = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
    
    /// 情報ポータル、ホーム画面URL
    let courceManagementHomeURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
    /// マナバURL
    let manabaURL : String = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
    
    /// 図書館URL
    let liburaryURL : String = "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
    /// シラバスURL
    let syllabusURL : String = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"
    /// 時間割
    let timeTableURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/Schedule/Day.aspx"
    /// 今年の成績表
    let currentTermPerformanceURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year=2021"
    /// 出欠記録
    let presenceAbsenceRecordURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
    
    /// 現在表示しているURLを保持
    var displayURL: String = " "
    /// 表示させたいURLを保持（これにより到達したかを判定）
    var confirmationURL : String = " "
    
    /// 回数を保持
    var hasPassdThroughOnce = false
    var onlySearchOnce = false
    var once1 = false
    var hasPassdCounter = 0
//    var images = "line.horizontal.3"
    var mainViewRightButtonOnOff : Bool = false
    let mailTitle = "トクメモ開発者へ"
    let masterMail = "universityinformationportalapp@gmail.com"
    let masterPass = "5hy7wt66qwwfftxpkoas"
}
