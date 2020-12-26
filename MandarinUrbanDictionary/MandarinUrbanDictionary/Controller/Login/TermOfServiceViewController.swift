//
//  TermOfServiceViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/26/20.
//

import UIKit

class TermOfServiceViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        
        titleLabel.text = "用戶使用協議"
        textView.text = "因為我們相信在自由知識運動中，您不需要提供個人資料，你可以：\n\n"
            + "A. 閱讀、編輯或使用 Slang Dictionary 而無需註冊賬戶。\n\n"
            + "註冊帳號時，僅需通過 Apple ID 即可登入，無需提供電子郵件位址或真實姓名，從 Apple ID" + "所獲取的信箱也將不會儲存於終端的 Cloud Firestore 資料庫，僅會隨機生成亂數ID。\n\n"
        + "因為我們想要了解 Slang Dictionary"
        + "如何被使用，以便讓我們可以為你讓它變得更好，我們會收集一些信息，當你：\n\n"
        + "做出公開貢獻時的貢獻內容。\n"
        + "註冊帳號。\n"
        + "使用 Slang Dictionary"
                + "時，您所發出的貢獻內容與按讚內容、加入最愛的內容以及最近瀏覽的本站紀錄。\n\n"
                + "我們承諾：\n\n"

       + "B. 在這份隱私權政策中描述你的資料將如何被使用或分享。\n\n"
       + "採用合理措施以確保您資料的安全。\n"
       + "絕不會販售你的資料或為了營利目的把資料販售給其他團體，只會儲存於 Cloud Firestore"
            + "資料庫。\n\n"
        + "只在有限的情況下分享你的資料，例如: 把資料內容儲存於位於 Cloud Firestore" + "的終端資料庫。"
        + "對於維護、了解和改善 Slang Dictionary" + "和履行法律規定下的義務中盡可能不要長時間保留你的數據。\n\n"
        + "請注意：\n\n"

        + "C. 你在 Slang Dictionary 中增加或改變的任何內容都會被公開和永久可用。"
        + "如您在尚未登入之情況下將無法增加或改變 Slang Dictionary" + "之內容，該內容或改變將會公開且將永久記錄其之亂數ID位址而非用戶名。\n\n"
        + "D. 我們社群的志願編輯和貢獻者是一個自我監管的機構。某些由社群選出的維基媒體網站管理員，將可有限地獲得有關近期貢獻的非空開資訊，以便讓他們可以保護維基媒體網站並執行政策。\n\n"

       + "E. 經由使用服務，您同意您將不進行下列行為：\n\n"

       + "基於非法或本協議禁止之目的而使用服務。\n"
       + "基於任何傷人或惡意目的使用本服務。\n"
       + "基於傷害 Slang Dictionary 的意圖使用本服務\n"
       + "違反我們的社群規範(可能隨時更新)。\n"
       + "寄垃圾郵件、向其他會員募資或詐騙。\n"
       + "刊登任何會觸犯任何人權益之內容，包括公開權、隱私權、著作權、商標權或其他智慧財產權或合約權。\n"
        + "發布任何仇恨言論、威脅、性露骨或色情內容。\n"
        + "發布任何煽動暴力的內容，或是包含裸露或血腥或恣意暴力的內容。\n"
        + "發佈任何提倡種族歧視、偏執、仇恨或針對任何團體或個人施加肢體暴力的內容。\n"
        + "自其他會員基於任何目的而徵求密碼、基於商業或不法目的而請求個人識別資訊或未經當事人同意而散布他人的個人資訊。\n"
        + "使用其他會員的帳號，與其他會員共享帳號，或持有多個帳號。\n"
        + "在我方已終止您帳號的情況下，新增另外的帳號，除非您已獲得我方允許。\n"
        + "如您違反本合約、濫用「服務」或從事 Slang Dictionary 認為不當或非法的行為。\n"
    }

}
