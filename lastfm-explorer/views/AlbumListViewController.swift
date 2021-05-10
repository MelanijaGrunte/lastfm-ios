//
//  AlbumListViewController.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import Anchorage
import RxSwift
import DropDown
import SVProgressHUD

public class AlbumListViewController: BaseViewController {
    static func instantiate(viewModel: AlbumViewModelType) -> AlbumListViewController {
        let vc = AlbumListViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    public var viewModel: AlbumViewModelType!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = Colors.separator
        tableView.backgroundColor = .none
        return tableView
    }()
    
    let dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.backgroundColor = Colors.darkerBackground
        dropDown.textColor = Colors.text
        dropDown.separatorColor = Colors.separator
        dropDown.dataSource = Period.allCases.map { $0.rawValue }
        return dropDown
    }()
    
    var topAlbums: TopAlbums? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        layoutViews()
        observeData()
    }
    
    private func layoutViews() {
        view.backgroundColor = Colors.background

        view.addSubview(tableView) {
            $0.edgeAnchors == $1.edgeAnchors
        }
       
        let rightSideOptionButton = UIBarButtonItem(title: "Period", style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = rightSideOptionButton
        dropDown.anchorView = rightSideOptionButton
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            tableView.setContentOffset(.zero, animated: true)
            let selectedPeriod = Period(rawValue: item) ?? ._overall
            viewModel.inputs.didSelectPeriod(period: selectedPeriod)
        }
    }
    
    @objc private func menuButtonTapped() {
        dropDown.show()
    }
    
    private func observeData() {
        viewModel.outputs.showHud
            .subscribe(onNext: { show in
                if show {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }, onError: justPrintError)
            .disposed(by: disposeBag)
        
        viewModel.outputs.showError
            .subscribe(onNext: { error in
                SVProgressHUD.showError(withStatus: error)
            }, onError: justPrintError)
            .disposed(by: disposeBag)
        
        viewModel.outputs.albums
            .subscribe(onNext: { [weak self] topAlbums in
                self?.topAlbums = topAlbums
            }, onError: justPrintError)
            .disposed(by: disposeBag)
    }
}

extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topAlbums?.albums.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseIdentifier, for: indexPath) as! AlbumTableViewCell
        let album = topAlbums?.albums[indexPath.row]
        cell.album = album
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let topAlbums = topAlbums else { return }
        
        if indexPath.row == topAlbums.albums.count - 5 && !topAlbums.pagingMeta.lastPageReached {
            viewModel.inputs.willDisplayCell(at: topAlbums.pagingMeta.page + 1)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let album = topAlbums?.albums[indexPath.row] else { return }
        
        let albumDetailsVC = ViewControllers.shared.getAlbumDetailsViewController(album: album)
        navigationController?.pushViewController(albumDetailsVC, animated: true)
    }
}
