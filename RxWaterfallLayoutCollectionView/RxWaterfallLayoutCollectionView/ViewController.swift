//
//  ViewController.swift
//  RxWaterfallLayoutCollectionView
//
//  Created by 张灿 on 2017/6/7.
//  Copyright © 2017年 FDD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {

    let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: CHTCollectionViewWaterfallLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: CHTCollectionElementKind.sectionHeader, withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: CHTCollectionElementKind.sectionFooter, withReuseIdentifier: "footer")
        self.view.addSubview(collectionView)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CHTCollectionElementKind.sectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: CHTCollectionElementKind.sectionHeader, withReuseIdentifier: "header", for: indexPath)
            if view.subviews.count == 0 {
                let label = UILabel()
                label.text = "header:\(indexPath.section)"
                label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
                view.addSubview(label)
            } else {
                (view.subviews.first as? UILabel)?.text = "header:\(indexPath.section)"
            }
            view.backgroundColor = .red
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: CHTCollectionElementKind.sectionFooter, withReuseIdentifier: "footer", for: indexPath)
            if view.subviews.count == 0 {
                let label = UILabel()
                label.text = "footer:\(indexPath.section)"
                label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
                view.addSubview(label)
            } else {
                (view.subviews.first as? UILabel)?.text = "footer:\(indexPath.section)"
            }
            view.backgroundColor = .yellow
            return view
        }
    }

    func collectView(_ collectView: UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: CGFloat(arc4random_uniform(40) + 60))
    }

    func collectView(_ collectView: UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func collectView(_ collectView: UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    func collectView(_ collectView: UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForFooterInSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

}

