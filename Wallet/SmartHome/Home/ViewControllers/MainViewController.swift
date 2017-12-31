//
//  MainCollectionViewController.swift
//  Wallet
//
//  Created by Petr Šíma on 31/12/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit
import CollectionKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: CollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let provider = CollectionProvider(data: ["firstfdshafhjkdajkhfdhkjfdahjhkgjfdaghdfagkhjadfghkjfdaghkjdfghjkakghjadfkghjfadghkjfdahjkgashjgkfdhjgkdfsahjgkdfashjgkfadsghjkfadhjgkhjgkfahjkgaf", "second"], viewUpdater: { (label: UILabel, data: String, index: Int) in
            label.numberOfLines = 0
            label.text = data
            label.backgroundColor = index == 0 ? .red : .green
        })
        provider.sizeProvider = { [unowned provider] (index,_, collectionSize) in
            let v = provider.view(at: index)
            return CGSize(
                width: collectionSize.width,
                height: v.systemLayoutSizeFitting(CGSize(width: collectionSize.width, height: UILayoutFittingCompressedSize.height)).height
            )
        }
        collectionView.provider = provider
    }
}
