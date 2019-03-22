//
//  PageContent.swift
//  PageMenu
//
//  Created by Chen,Yalun on 2019/3/18.
//  Copyright © 2019 Chen,Yalun. All rights reserved.
//

import UIKit

// 代理
protocol PageContentDelegate : class {
    func pageContentDidChange(pageContent: PageContent, targetIndex: Int, progress: CGFloat)
}



class PageContent: UIView {
    weak var delegate: PageContentDelegate?
    private var controllerList: [UIViewController]
    private let identifier = "PageMenu_CollectionView_Identifier"
    private var currentIndex = 0
    private var shouldCallDelegate = false
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        var collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.white
        // 注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        addSubview(collectionView)
        return collectionView
    }()
    init(frame: CGRect, controllerList: [UIViewController]) {
        self.controllerList = controllerList
        super.init(frame: frame)
        self.collectionView.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: UICollectionViewDataSource
extension PageContent : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        let view = controllerList[indexPath.row].view!
        view.frame = cell.bounds
        cell.contentView.addSubview(view)
        return cell
    }
}



// MARK: UIScrollViewDelegate
extension PageContent : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        currentIndex = index
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldCallDelegate = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !shouldCallDelegate { return }
        let width = scrollView.bounds.width
        let offsetX = scrollView.contentOffset.x - CGFloat(currentIndex) * width
        let offsetIndex = offsetX > 0 ? 1 : -1
        let progress = abs(offsetX) / width
        if delegate != nil {
            delegate?.pageContentDidChange(pageContent: self, targetIndex: currentIndex + offsetIndex, progress: progress)
        }
    }
}



// MARK: PageTitleDelegate
extension PageContent : PageTitleDelegate {
    internal func pageTitleDidSelected(pageTitle: PageTitle, pageTitleView: PageTitleView) {
        shouldCallDelegate = false
        collectionView.scrollToItem(at: IndexPath(item: pageTitleView.index, section: 0), at: .left, animated: false)
        currentIndex = pageTitleView.index
    }
}
