//
//  CollectionView.swift
//  Wallet
//
//  Created by Petr Šíma on 29/10/2017.
//  Copyright © 2017 Petr Šíma. All rights reserved.
//

import UIKit

enum ViewOrVC {
    case view(IBox<UIView>)
    case vc(IBox<UIViewController>)
}

class EmbedCell: UICollectionViewCell {
    let key = NSUUID().uuidString
    weak var embeddedView: UIView? {
        get {
            return contentView.subviews.first
        }
        set {
            embeddedView?.removeFromSuperview()
            guard let newValue = newValue else { return }
            let evaluatedConstraints = sizeToParent().map { $0(contentView, newValue) }
            contentView.addSubview(newValue, constraints: evaluatedConstraints.map { $0.unbox })

        }
    }
}

class CollectionVC<A>: UICollectionViewController {
    var items: [A] = []
    let createContent: (A) -> ViewOrVC
    let didSelect: ((A) -> ())?

    init(layout: UICollectionViewLayout, items: [A], didSelect: ((A) -> ())? = nil, createContent: @escaping (A) -> ViewOrVC) {
        self.items = items
        self.createContent = createContent
        self.didSelect = didSelect
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(EmbedCell.self, forCellWithReuseIdentifier: "Identifier")
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(items[indexPath.item])
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }


    var disposables: [String : Any] = [:]

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Identifier", for: indexPath) as! EmbedCell
        let newContent = createContent(items[indexPath.item])
        switch newContent {
        case let .view(vBox):
            cell.embeddedView = vBox.unbox
            disposables[cell.key] = vBox
        case let .vc(vcBox):
            let vc = vcBox.unbox
            addChildViewController(vc) // todo do I need to call removeFromParentViewController when replacing it?
            cell.embeddedView = vc.view
            vc.didMove(toParentViewController: self)
            disposables[cell.key] = vcBox
        }
        return cell
    }

}

extension CollectionVC where A: Equatable {
    func apply(_ change: ArrayChange<A>) {
        items.apply(change)
        switch change {
        case let .insert(_, at: index):
            let indexPath = IndexPath(item: index, section: 0)
            collectionView?.insertItems(at: [indexPath])
        case let .remove(at: index):
            let indexPath = IndexPath(item: index, section: 0)
            collectionView?.deleteItems(at: [indexPath])
        case let .replace(with: _, at: index):
            let indexPath = IndexPath(item: index, section: 0)
            collectionView?.reloadItems(at: [indexPath])
        case let .move(at: i, to: j):
            collectionView?.moveItem(at: IndexPath(item: i, section: 0), to: IndexPath(item: j, section: 0))
        }
    }
}

func collectionViewController<A>(layout: I<UICollectionViewLayout>, items value: ArrayWithHistory<A>, didSelect: ((A) -> ())? = nil, createContent: @escaping (A) -> ViewOrVC) -> IBox<UICollectionViewController> {
    let collectionVC = CollectionVC(layout: layout.value, items: [], didSelect: didSelect, createContent: createContent)
    let box = IBox<UICollectionViewController>(collectionVC)
    box.disposables.append(value.observe(current: {
        collectionVC.items = $0
    }, handleChange: { change in
        collectionVC.apply(change)
    }))
    box.disposables.append(layout.observe { l in
        collectionVC.collectionView?.setCollectionViewLayout(l, animated: true)
    })
    return box
}

