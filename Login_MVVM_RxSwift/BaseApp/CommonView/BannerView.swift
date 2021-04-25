//
//  BannerView.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import UIKit
import FSPagerView

class BannerView: BaseView {
    
    var pagerView: FSPagerView!
    
    // data banner
    var bannerItems: [String] = [] {
        didSet {
            pagerView.automaticSlidingInterval = bannerItems.count > 0 ? 1.5 : 0
        }
    }
    
    override func configView() {
        setupView()
    }
    
    // set up ui
    func setupView() {
        pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.attachView(pagerView)
    }
    
    // set data banner
    func setDataBanner(_ bannerItems: [String]) {
        self.bannerItems = bannerItems
        self.pagerView.reloadData()
    }
}

// handle banner item
extension BannerView: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerItems.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: bannerItems[index])
        return cell
    }
}
