//
//  CellSortViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/06.
//

import UIKit
import FirebaseAnalytics

final class CustomizeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 編集モードの状態で表示
        editMode(isEditing: true)
    }
    
    // MARK: - IBAction
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        // 編集状態を反転する
        editMode(isEditing: !tableView.isEditing)
    }
    
    // MARK: - Private func
    
    private func editMode(isEditing: Bool) {
        cellSort()
        // 編集状態について
        tableView.setEditing(isEditing, animated: false)
        // 複数の選択を許可するかどうか
        tableView.allowsMultipleSelectionDuringEditing = isEditing
        tableView.reloadData()
        
        if isEditing {
            editButton.setTitle("名前の変更", for: .normal)
            
            for i in 0 ..< dataManager.menuLists.count {
                if dataManager.menuLists[i].isDisplay {
                    // display=true のセルを選択状態にする
                    // animatiedを有効にすると画面が選択cellの最下部へフォーカスする　**false推奨**
                    tableView.selectRow(at: [0,i], animated: false, scrollPosition: .bottom)
                }
            }
            
        } else {
            editButton.setTitle("並び替え", for: .normal)
        }
    }
    
    // 表示を許可したCellを配列の前方にソートする
    private func cellSort() {
        var oldLists:[Constant.Menu] = dataManager.menuLists
        var newLists:[Constant.Menu] = []
        var counter = 0
        for i in 0..<dataManager.menuLists.count {
            if dataManager.menuLists[i].isDisplay {
                newLists.append(dataManager.menuLists[i])
                oldLists.remove(at: i - counter)
                counter += 1
            }
        }
        dataManager.menuLists = newLists + oldLists
    }
    
    // 名前変更のフィールドを出現させる
    private func showRenameEditPopup(_ indexPath: Int) {
        // MARK: - HACK 推奨されたAlertの使い方ではない
        // 名前を変更するpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
        let alert = UIAlertController(title: "名前の変更", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "変更",
                               style: .default,
                               handler: {[weak alert] (action) -> Void in
            let alert = alert! // fatalError(変更が押された、つまりalertは必ず存在する)
            
            if let textField = alert.textFields {
                if let text = textField[0].text {
                    // 名前の更新
                    self.changeContentsMenuLists(row: indexPath, title: text)
                    self.dataManager.saveMenuLists()
                    self.tableView.reloadData()
                    // Analytics
                    Analytics.logEvent("CustomizeText", parameters: ["changeName": text])
                }
                
            }else{
                // 空欄の場合
                return
            }
        })
        
        let cancel = UIAlertAction(title: "キャンセル",
                                   style: .cancel,
                                   handler: { _ in self.tableView.reloadData() })
        
        alert.addAction(ok)
        alert.addAction(cancel)
        alert.addTextField(configurationHandler: {(textField:UITextField!) -> Void in
            textField.text = DataManager.singleton.menuLists[indexPath].title
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    /// MenuLists内の要素を削除する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    private func deleteContentsMenuLists(row: Int) {
        dataManager.menuLists.remove(at: row)
        dataManager.saveMenuLists()
    }
    
    /// MenuLists内の要素を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    ///   - title: タイトルの変更
    ///   - isDisplay: リストで表示する
    ///   - isInitView: 初期画面にする
    private func changeContentsMenuLists(row: Int, title: String? = nil, isDisplay: Bool? = nil, isInitView: Bool? = nil) {
        if let title = title {
            dataManager.menuLists[row].title = title
        }
        if let isDisplay = isDisplay {
            dataManager.menuLists[row].isDisplay = isDisplay
        }
        if let isInitView = isInitView {
            // falseに初期化する
            for i in 0..<dataManager.menuLists.count { dataManager.menuLists[i].isInitView = false }
            dataManager.menuLists[row].isInitView = isInitView
        }
        dataManager.saveMenuLists()
    }
    
    /// MenuLists内の順番を変更する。その都度UserDefaultsに保存する
    /// CustomizeViewControllerとMenuTutorialから呼び出される
    /// - Parameters:
    ///   - sourceRow: 移動させたいcellのindex
    ///   - destinationRow: 挿入場所のindex
    private func changeSortOderMenuLists(sourceRow: Int, destinationRow: Int) {
        let todo = dataManager.menuLists[sourceRow]
        dataManager.menuLists.remove(at: sourceRow)
        dataManager.menuLists.insert(todo, at: destinationRow)
        dataManager.saveMenuLists()
    }
}


// MARK: - TableView
extension CustomizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.menuLists.count
    }
    
    // cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cellSort, for: indexPath)! // fatalError
        tableCell.textLabel?.text = dataManager.menuLists[indexPath.item].title
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    // 並び替え
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        return proposedDestinationIndexPath
        
    }
    
    // 「編集モード」並び替え検知
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 並び替えを更新
        changeSortOderMenuLists(sourceRow: sourceIndexPath.row, destinationRow: destinationIndexPath.row)
        dataManager.saveMenuLists()
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.isEditing {
            // 編集モードの場合、全Cell表示
            return 44
            
        }else{
            if dataManager.menuLists[indexPath.row].isDisplay {
                return 44
            }else{
                return 0
            }
        }
    }
    
    // セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            // 表示許可情報を更新
            // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
            changeContentsMenuLists(row: indexPath.row, isDisplay: true)
            dataManager.saveMenuLists()
            
        }else{
            showRenameEditPopup(indexPath.row)
        }
        
    }
    
    // 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // カスタマイズは非表示にはしない
        if dataManager.menuLists[indexPath.row].id == .cellSort {
            return
        }
        
        //
        if dataManager.menuLists[indexPath.row].id == .favorite {
            deleteContentsMenuLists(row: indexPath.row)
            return
        }
            
        // 表示許可情報を更新
        changeContentsMenuLists(row: indexPath.row,isDisplay: false)
        dataManager.saveMenuLists()
    }
}
