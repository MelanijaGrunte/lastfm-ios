//
//  UIView.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import Anchorage

extension UIView {
    public func addSubview(_ view: UIView, block: (_ child: UIView, _ parent: UIView) -> Void) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        block(view, self)
    }
    
    public func addSubview(_ view: UIView, block: (_ child: UIView) -> Void) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        block(view)
    }
}
