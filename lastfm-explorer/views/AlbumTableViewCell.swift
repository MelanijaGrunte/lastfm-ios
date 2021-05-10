//
//  AlbumTableViewCell.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import Anchorage
import RxSwift

class AlbumTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AlbumTableViewCell"
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.darkerBackground
        return imageView
    }()

    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.textColor = Colors.text
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(15)
        label.textColor = Colors.text
        return label
    }()
    
    private let playCountLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        return label
    }()
        
    private var imageSubscription: Disposable?
    
    public var album: Album? {
        didSet {
            rankLabel.text = album?.rank.map { $0.description }
            albumNameLabel.text = album?.title
            artistNameLabel.text = album?.artist.map { $0.name }
            if let playCount = album?.playCount?.description {
                playCountLabel.text = "Play count: \(playCount)"
            }
            
            if let imageUrlString = album?.images.last?.url, let url = URL.init(string: imageUrlString) {
                imageSubscription?.dispose()
                imageSubscription = Api.loadImage(url: url)
                    .subscribe(onSuccess: { [weak self] image in
                        self?.albumImageView.image = image
                    }, onFailure: justPrintError)
            } else {
                albumImageView.image = nil
            }
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        addSubview(albumImageView) {
            $0.topAnchor == $1.topAnchor + 10
            $0.leftAnchor == $1.leftAnchor + 20
            $0.bottomAnchor == $1.bottomAnchor - 10
            $0.widthAnchor == $0.heightAnchor
        }
        
        addSubview(albumNameLabel) {
            $0.topAnchor == $1.topAnchor + 10
            $0.leftAnchor == albumImageView.rightAnchor + 10
            $0.rightAnchor == $1.rightAnchor - 20
        }

        addSubview(artistNameLabel) {
            $0.topAnchor == albumNameLabel.bottomAnchor + 2
            $0.leftAnchor == albumNameLabel.leftAnchor
            $0.rightAnchor == $1.rightAnchor - 20
        }

        addSubview(playCountLabel) {
            $0.topAnchor >= artistNameLabel.bottomAnchor + 5
            $0.leftAnchor == artistNameLabel.leftAnchor
            $0.bottomAnchor == $1.bottomAnchor - 15
        }
        
        addSubview(rankLabel) {
            $0.bottomAnchor == $1.bottomAnchor - 15
            $0.rightAnchor == $1.rightAnchor - 20
        }
    }
}
