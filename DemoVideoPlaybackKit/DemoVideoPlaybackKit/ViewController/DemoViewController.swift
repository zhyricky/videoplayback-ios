//
//  ViewController.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 4/25/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private enum DemoOption: String {
    case SingleVideoView, SingleViewViewAutoplay, CustomToolBar, FeedView, FeedAutoplayView
}

class DemoViewController: UIViewController {

    private let tableView = UITableView(frame: .zero)
    private let disposeBag = DisposeBag()
    private let demoList = Variable([DemoOption.SingleVideoView, DemoOption.SingleViewViewAutoplay, DemoOption.CustomToolBar, DemoOption.FeedView, DemoOption.FeedAutoplayView])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        setupDemoList()
    }
    
    
    private func setupDemoList() {
        demoList.asObservable().bindTo(tableView.rx.items(cellIdentifier: BasicTableViewCell.identifier)) { index, model, cell in
            guard let cell = cell as? BasicTableViewCell else { return }
            cell.titleText = model.rawValue
        }.addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(DemoOption.self).subscribe(onNext: { demoOption in
            switch demoOption {
            case .SingleVideoView:
                self.navigationController?.pushViewController(SingleVideoPlaybackViewController(), animated: true)
            case .SingleViewViewAutoplay:
                self.navigationController?.pushViewController(SingleVideoPlaybackViewController(shouldAutoPlay: true), animated: true)                
            default:
                print("not ready")
                break
            }
            
        }).addDisposableTo(disposeBag)
    }

}

