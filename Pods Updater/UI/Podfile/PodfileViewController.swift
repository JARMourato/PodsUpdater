//
//  PodfileViewController.swift
//  Pods Updater
//
//  Created by Kizito Nwose on 01/02/2018.
//  Copyright © 2018 Kizito Nwose. All rights reserved.
//

import Cocoa
import Highlightr
import RxSwift
import RxCocoa

class PodfileViewController: NSViewController {

    var result: PodFileCleanResult?
    @IBOutlet weak var themeChoiceButton: NSPopUpButton!
    @IBOutlet weak var oldPodfileTextView: NSTextView!
    @IBOutlet weak var newPodfileTextView: NSTextView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    fileprivate var presenter: PodfileContract.Presenter!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let highlighter = Highlightr()
    private let writeErrorAert: NSAlert = {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = "Counld not write to Podfile"
        alert.alertStyle = .critical
        alert.addButton(withTitle: "OK")
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter = PodfilePresenter(view: self, source: Repository.instance, result: result!)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.titleVisibility = .hidden
        view.window?.titlebarAppearsTransparent = true
        view.window?.styleMask.insert(.fullSizeContentView)
        view.window?.zoom(self)
    }
}

// MARK:- PodfileContract.View
extension PodfileViewController: PodfileContract.View {
    func showPodfileSaveSuccess() {
        view.window?.close()
    }
    
    func showPodfileSaveError() {
        writeErrorAert.runModal()
    }
}

//MARK: Setup
extension PodfileViewController {
    
    func setupViews() {
        setupTextViews()
        setupButtons()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(hex: "#263238").cgColor
    }
    
    private func setupTextViews() {
        [oldPodfileTextView, newPodfileTextView].forEach {
            // Setting these values via Storyboard does not work due to a bug in NSTextView
            // https://stackoverflow.com/questions/19801601/nstextview-with-smart-quotes-disabled-still-replaces-quotes
            $0?.isAutomaticQuoteSubstitutionEnabled = false
            $0?.isAutomaticDashSubstitutionEnabled = false
            $0?.isAutomaticTextReplacementEnabled = false
        }
        
        // Setup synchronized scrolling between the two TextViews.
        (oldPodfileTextView.enclosingScrollView as! SynchronizedScrollView).synchronizedScrollView
            = newPodfileTextView.enclosingScrollView!
        (newPodfileTextView.enclosingScrollView as! SynchronizedScrollView).synchronizedScrollView
            = oldPodfileTextView.enclosingScrollView!
        
        let emptyString = NSAttributedString()
        oldPodfileTextView.textStorage?.append(highlighter?.highlight(result!.oldContent, as: "ruby") ?? emptyString)
        newPodfileTextView.textStorage?.append(highlighter?.highlight(result!.newContent, as: "ruby") ?? emptyString)
        updateColors()
    }
    
    private func setupButtons() {
        saveButton.rx.tap.asDriver().drive(onNext: { [unowned self] in
            self.presenter.updatePodFileWitNewData()
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap.asDriver().drive(onNext: { [unowned self] in
            self.view.window?.close()
            }).disposed(by: disposeBag)
        
        if let highlighter = highlighter {
            themeChoiceButton.removeAllItems()
            themeChoiceButton.addItems(withTitles: highlighter.availableThemes().sorted())
            themeChoiceButton.rx.tap.asDriver().drive(onNext: {  [unowned self] in
                self.highlighter?.setTheme(to: self.themeChoiceButton.selectedItem?.title ?? "")
                self.updateColors()
            }).disposed(by: disposeBag)
        } else {
            themeChoiceButton.isHidden = true
        }
    }
    
    private func updateColors()  {
        if let color = highlighter?.theme.themeBackgroundColor {
            oldPodfileTextView.backgroundColor = color
            newPodfileTextView.backgroundColor = color
        }
    }
}

