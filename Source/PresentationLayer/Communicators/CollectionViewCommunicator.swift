//
//  CollectionViewCommunicator.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 2/6/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class CollectionViewCommunicator<
    CollectionView: UICollectionView,
    ContentViewModel: ViewModel
    >:  NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {

    // MARK: - Properties

    weak var collectionView: CollectionView?
    let viewModel: ContentViewModel

    lazy var isScrollingToBottom = false


    // MARK: - Initialization

    init(
        collectionView: CollectionView,
        viewModel: ContentViewModel
        ) {
        self.collectionView = collectionView
        self.viewModel = viewModel

        super.init()

        configureCollectionView()
        reloadData()
    }


    // MARK: - Appearance

    func reloadData() {
        collectionView?.reloadData()
    }

    func remove(
        at indexPath: IndexPath
        ) {
        collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
        })
    }


    // MARK: - Configuration

    func configureCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }


    // MARK: - UICollectionViewDataSource

    func numberOfSections(
        in collectionView: UICollectionView
        ) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        notImplementedFatalError()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        notImplementedFatalError()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
        ) -> UICollectionReusableView {
        notImplementedFatalError()
    }


    // MARK: - UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
        ) {

    }

    func collectionView(
        _ collectionView: UICollectionView,
        didHighlightItemAt indexPath: IndexPath
        ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        UIView.animate(withDuration: 0.05) {
            cell.transform = cell.transform.scaledBy(x: 0.95, y: 0.95)
            cell.alpha = 0.9
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didUnhighlightItemAt indexPath: IndexPath
        ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        UIView.animate(withDuration: 0.05) {
            cell.transform = .identity
            cell.alpha = 1
        }
    }


    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        return .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
        ) -> UIEdgeInsets {
        return .zero
    }


    // MARK: - Scrolling

    func scrollToBottom(animated: Bool) {
        isScrollingToBottom = true

        guard let collectionView = collectionView,
            collectionView.numberOfSections > 0 else {
                return
        }

        let collectionViewContentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height

        collectionView.performBatchUpdates(nil) { [unowned self] _ in
            collectionView.scrollRectToVisible(
                CGRect(
                    x: 0.0,
                    y: collectionViewContentHeight - 1.0,
                    width: 1.0,
                    height: 1.0
                ),
                animated: animated
            )

            self.isScrollingToBottom = false
        }
    }
}

