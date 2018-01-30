//
//  PodsTableView.swift
//  Pods Updater
//
//  Created by Kizito Nwose on 30/01/2018.
//  Copyright © 2018 Kizito Nwose. All rights reserved.
//

import Cocoa

class PodsTableView: NSTableView {
    
    var pods = [Pod]() {
        didSet {
            reloadData()
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        registerCellNib(PodNewVersionsTableCellView.self, forIdentifier: .newVersionsCell)
        registerCellNib(PodUseVersionCellView.self, forIdentifier: .useVersionCell)
    }
}

// MARK:- NSTableViewDelegate
extension PodsTableView: NSTableViewDelegate {
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == tableView.tableColumns[0] {
            let cell = tableView.makeView(withIdentifier: .podNameCell, owner: nil)  as! NSTableCellView
            cell.textField?.stringValue = "Alamofire"
            cell.textField?.alignment = .center
            return cell
        }
        
        if tableColumn == tableView.tableColumns[1]{
            let cell = tableView.makeView(withIdentifier: .currentVersionCell, owner: nil)  as! NSTableCellView
            cell.textField?.stringValue = "Alamofire"
            cell.textField?.alignment = .center
            return cell
        }
        
        if tableColumn == tableView.tableColumns[2] {
            let cell = tableView.makeView(withIdentifier: .newVersionsCell, owner: nil)  as! PodNewVersionsTableCellView
            cell.versionsPopUp.addItems(withTitles: ["1.1.0", "1.1.1", "1.1.2", "1.1.3"])
            return cell
        }
        
        if tableColumn == tableView.tableColumns[3] {
            let cell = tableView.makeView(withIdentifier: .useVersionCell, owner: nil)  as! PodUseVersionCellView
            cell.useVersionButton.title = "Use version"
            return cell
        }
        return nil
    }
}

// MARK:- NSTableViewDataSource
extension PodsTableView: NSTableViewDataSource {
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return 6
    }
}

// MARK:- NSUserInterfaceItemIdentifier
extension NSUserInterfaceItemIdentifier {
    public static let podNameCell = NSUserInterfaceItemIdentifier("podNameCell")
    public static let currentVersionCell = NSUserInterfaceItemIdentifier("currentVersionCell")
    public static let newVersionsCell = NSUserInterfaceItemIdentifier("newVersionsCell")
    public static let useVersionCell = NSUserInterfaceItemIdentifier("useVersionCell")
}

// MARK:- PodNewVersionsTableCellView
class PodNewVersionsTableCellView: NSTableCellView {
    
    @IBOutlet weak var versionsPopUp: NSPopUpButton!
    
}

// MARK:- PodUseVersionCellView
class PodUseVersionCellView: NSTableCellView {
    
    @IBOutlet weak var useVersionButton: NSButton!
    
}
