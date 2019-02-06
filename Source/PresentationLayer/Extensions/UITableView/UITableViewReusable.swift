//
//  UITableViewReusable.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

extension UITableView {

    // MARK: - Appearance

    func registerCell(
        ofType type: (Reusable & UITableViewCell).Type
        ) {
        self.register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }

    func registerNibCell(
        ofType type: (Reusable & UITableViewCell).Type
        ) {
        let nib = UINib(nibName: String(describing: type.self), bundle: .main)
        self.register(nib, forCellReuseIdentifier: type.reuseIdentifier)
    }

    func registerHeaderView(
        ofType type: (Reusable & UITableViewHeaderFooterView).Type
        ) {
        self.register(type.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueCell<Cell: Reusable & UITableViewCell>(
        ofType type: Cell.Type = Cell.self,
        at indexPath: IndexPath
        ) -> Cell {
        return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! Cell
    }

    func dequeueNibCell<Cell: Reusable & UITableViewCell>(
        ofType type: Cell.Type = Cell.self,
        at indexPath: IndexPath
        ) -> Cell {
        return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! Cell
    }

    func dequeueHeaderView<HeaderView: Reusable & UITableViewHeaderFooterView>(
        ofType type: HeaderView.Type = HeaderView.self
        ) -> HeaderView {
        return self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as! HeaderView
    }
}
