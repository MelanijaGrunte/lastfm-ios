//
//  TrackView.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import Anchorage
import UIKit
import RxGesture
import RxSwift

public protocol TrackViewDelegate {
    func didTapOnHeart(track: Track)
}

public class TrackView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart-inactive"), for: .normal)
        return button
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        label.numberOfLines = 0
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        label.numberOfLines = 0
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        label.textAlignment = .right
        return label
    }()
    
    public var number: Int? {
        didSet {
            guard let number = number else { return }
            numberLabel.text = number.description + "."
        }
    }
    
    public var track: Track? {
        didSet {
            guard let track = track else { return }
            titleLabel.text = track.name
            artistLabel.text = track.artist.name
            durationLabel.text = track.formattedDuration
        }
    }
    
    public var liked: Bool = false {
        didSet {
            let image = liked ? UIImage(named: "heart-active") : UIImage(named: "heart-inactive")
            heartButton.setImage(image, for: .normal)
        }
    }
    
    public var delegate: TrackViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        addSubview(numberLabel) {
            $0.topAnchor == $1.topAnchor + 5
            $0.bottomAnchor == $1.bottomAnchor - 5
            $0.leftAnchor == $1.leftAnchor + 5
        }
        
        addSubview(heartButton) {
            $0.heightAnchor == 15
            $0.widthAnchor == $0.heightAnchor
            $0.leftAnchor == numberLabel.rightAnchor + 10
            $0.centerYAnchor == $1.centerYAnchor
        }
        
        heartButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let track = self?.track else { return }
                self?.delegate?.didTapOnHeart(track: track)
            })
            .disposed(by: disposeBag)
        
        addSubview(artistLabel) {
            $0.verticalAnchors == numberLabel.verticalAnchors
            $0.leftAnchor == heartButton.rightAnchor + 10
        }
        
        addSubview(titleLabel) {
            $0.verticalAnchors == artistLabel.verticalAnchors
            $0.leftAnchor == artistLabel.rightAnchor + 20
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        addSubview(durationLabel) {
            $0.verticalAnchors == numberLabel.verticalAnchors
            $0.leftAnchor == titleLabel.rightAnchor + 10
            $0.rightAnchor == $1.rightAnchor - 10
        }
    }
}
