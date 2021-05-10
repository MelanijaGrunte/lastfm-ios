//
//  AlbumDetailsViewController.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import RxSwift
import Anchorage

public class AlbumDetailsViewController: BaseViewController {
    static func instantiate(viewModel: AlbumDetailsViewModelType) -> AlbumDetailsViewController {
        let vc = AlbumDetailsViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    public var viewModel: AlbumDetailsViewModelType!
        
    private let scrollView = UIScrollView()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = Colors.gray
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let albumView: AlbumView = {
        let albumView = AlbumView()
        albumView.isHidden = true
        return albumView
    }()
    
    private let trackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
        observeData()
    }
    
    private func layoutViews() {
        view.backgroundColor = Colors.background

        view.addSubview(scrollView) {
            $0.edgeAnchors == $1.edgeAnchors
        }
        
        view.addSubview(errorLabel) {
            $0.edgeAnchors == $1.edgeAnchors
        }
        
        scrollView.addSubview(stackView) {
            $0.centerXAnchor == $1.centerXAnchor
            $0.topAnchor == $1.topAnchor + 10
            $0.bottomAnchor == $1.bottomAnchor - 10
            $0.widthAnchor == view.widthAnchor - 32
        }
        
        stackView.addArrangedSubview(albumView)
        
        let separator = UIView()
        stackView.addArrangedSubview(separator)
        separator.heightAnchor == 25
        
        stackView.addArrangedSubview(trackStackView)
    }
    
    private var tracks: [Track] = [] {
        didSet {
            trackStackView.arrangedSubviews.forEach(trackStackView.removeArrangedSubview)
            trackStackView.subviews.forEach({ $0.removeFromSuperview() })
            
            for (index, track) in tracks.enumerated() {
                let view = TrackView()
                view.heightAnchor == 50 ~ .high
                view.number = index + 1
                view.track = track
                view.delegate = self
                trackStackView.addArrangedSubview(view)
            }
        }
    }
    
    private func observeData() {
        viewModel.outputs.headerTitle
            .subscribe(onNext: { [weak self] title in
                self?.navigationItem.title = title
            }, onError: justPrintError)
            .disposed(by: disposeBag)
        
        viewModel.outputs.showError
            .subscribe(onNext: { [weak self] error in
                self?.errorLabel.text = error
                self?.albumView.isHidden = true
            }, onError: justPrintError)
            .disposed(by: disposeBag)
        
        viewModel.outputs.albumDetails
            .subscribe(onNext: { [weak self] selectedAlbum in
                guard let self = self else { return }
                self.albumView.album = selectedAlbum
                self.albumView.isHidden = false
                self.tracks = selectedAlbum.tracks
            }, onError: justPrintError)
            .disposed(by: disposeBag)
        
        viewModel.outputs.goToLogin
            .subscribe(onNext: { [weak self] _ in
                let loginVC = ViewControllers.shared.getLoginViewController()
                loginVC.modalPresentationStyle = .overCurrentContext
                self?.navigationController?.present(loginVC, animated: true)
            }, onError: justPrintError)
            .disposed(by: disposeBag)
    }
}

extension AlbumDetailsViewController: TrackViewDelegate {
    public func didTapOnHeart(track: Track) {
        viewModel.inputs.didTapOnHeart(track: track)
    }
}
