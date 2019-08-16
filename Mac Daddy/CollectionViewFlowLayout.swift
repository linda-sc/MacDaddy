//
//  CollectionViewFlowLayout.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/24/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit

/****************************************************************/
// Disappearing animation for accepted and rejected cells
/****************************************************************/
class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
        //return true
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath as IndexPath)
        attribute?.transform = (attribute?.transform)!.scaledBy(x: 1, y: 0)
        attribute?.alpha = 1
        return attribute
    }
    
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath as IndexPath)
        attribute?.transform = (attribute?.transform)!.translatedBy(x: 0, y:0)
        attribute?.transform = (attribute?.transform)!.scaledBy(x: 1, y: 0)
        attribute?.alpha = 1
        return attribute
    }
}

extension UICollectionViewCell {
    /// This is a workaround method for self sizing collection view cells which stopped working for iOS 12
    func setupSelfSizingForiOS12(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
}


open class BouncyLayout: UICollectionViewFlowLayout {
    
    public enum BounceStyle {
        case subtle
        case regular
        case prominent
        case crazy
        
        var damping: CGFloat {
            switch self {
            case .subtle: return 0.9
            case .regular: return 0.7
            case .prominent: return 0.5
            case .crazy: return 0.2
            }
        }
        
        var frequency: CGFloat {
            switch self {
            case .subtle: return 3
            case .regular: return 1.5
            case .prominent: return 1
            case .crazy: return 0.5
            }
        }
    }
    
    private var damping: CGFloat = BounceStyle.regular.damping
    private var frequency: CGFloat = BounceStyle.regular.frequency
    
    public convenience init(style: BounceStyle) {
        self.init()
        
        damping = style.damping
        frequency = style.frequency
    }
    
    public convenience init(damping: CGFloat, frequency: CGFloat) {
        self.init()
        
        self.damping = damping
        self.frequency = frequency
    }
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    
    open override func prepare() {
        super.prepare()
        guard let view = collectionView, let attributes = super.layoutAttributesForElements(in: view.bounds.insetBy(dx: -200, dy: -200))?.compactMap({ $0.copy() as? UICollectionViewLayoutAttributes }) else { return }
        
        oldBehaviors(for: attributes).forEach { animator.removeBehavior($0) }
        newBehaviors(for: attributes).forEach { animator.addBehavior($0, damping, frequency) }
    }
    
    private func oldBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = attributes.map { $0.indexPath }
        return animator.behaviors.compactMap {
            guard let behavior = $0 as? UIAttachmentBehavior, let itemAttributes = behavior.items.first as? UICollectionViewLayoutAttributes else { return nil }
            return indexPaths.contains(itemAttributes.indexPath) ? nil : behavior
        }
    }
    
    private func newBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = animator.behaviors.compactMap { (($0 as? UIAttachmentBehavior)?.items.first as? UICollectionViewLayoutAttributes)?.indexPath }
        return attributes.compactMap { indexPaths.contains($0.indexPath) ? nil : UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center.floored()) }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let view = collectionView else { return false }
        
        animator.behaviors.forEach {
            guard let behavior = $0 as? UIAttachmentBehavior, let item = behavior.items.first else { return }
            update(behavior: behavior, and: item, in: view, for: newBounds)
            animator.updateItem(usingCurrentState: item)
        }
        return view.bounds.width != newBounds.width
    }
    
    private func update(behavior: UIAttachmentBehavior, and item: UIDynamicItem, in view: UICollectionView, for bounds: CGRect) {
        let delta = CGVector(dx: bounds.origin.x - view.bounds.origin.x, dy: bounds.origin.y - view.bounds.origin.y)
        let resistance = CGVector(dx: fabs(view.panGestureRecognizer.location(in: view).x - behavior.anchorPoint.x) / 1000, dy: fabs(view.panGestureRecognizer.location(in: view).y - behavior.anchorPoint.y) / 1000)
        
        switch scrollDirection {
        case .horizontal: item.center.x += delta.dx < 0 ? max(delta.dx, delta.dx * resistance.dx) : min(delta.dx, delta.dx * resistance.dx)
        case .vertical: item.center.y += delta.dy < 0 ? max(delta.dy, delta.dy * resistance.dy) : min(delta.dy, delta.dy * resistance.dy)
        }
        
        item.center.flooredInPlace()
    }
}

extension UIDynamicAnimator {
    
    open func addBehavior(_ behavior: UIAttachmentBehavior, _ damping: CGFloat, _ frequency: CGFloat) {
        behavior.damping = damping
        behavior.frequency = frequency
        addBehavior(behavior)
    }
}

extension CGPoint {
    
    func floored() -> CGPoint {
        return CGPoint(x: floor(x), y: floor(y))
    }
    
    mutating func flooredInPlace() {
        self = floored()
    }
}
