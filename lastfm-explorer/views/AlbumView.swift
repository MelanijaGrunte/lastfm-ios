//
//  AlbumView.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import Anchorage
import RxSwift

public class AlbumView: UIView {
    
    private var imageSubscription: Disposable?
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.darkerBackground
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.textColor = Colors.text
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = Colors.text
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    public var album: Album? {
        didSet {
            guard let album = album else { return }
            albumNameLabel.text = album.title
            artistNameLabel.text = "Album by \(album.artist?.name ?? "unknown")"
            loadImage(for: album)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        addSubview(albumImageView) {
            $0.topAnchor == $1.safeAreaLayoutGuide.topAnchor + 10
            $0.centerXAnchor == $1.centerXAnchor
            $0.widthAnchor == $1.widthAnchor / 2
            $0.heightAnchor == $0.widthAnchor
        }
                
        addSubview(albumNameLabel) {
            $0.topAnchor == albumImageView.bottomAnchor + 10
            $0.horizontalAnchors == albumImageView.horizontalAnchors
        }
                
        addSubview(artistNameLabel) {
            $0.topAnchor == albumNameLabel.bottomAnchor + 10
            $0.horizontalAnchors == albumNameLabel.horizontalAnchors
            $0.bottomAnchor == $1.bottomAnchor - 10
        }
    }
    
    private func loadImage(for album: Album) {
        if let imageUrlString = album.images.map({ $0.url }).last(where: { !$0.isEmpty }), let url = URL(string: imageUrlString) {
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
