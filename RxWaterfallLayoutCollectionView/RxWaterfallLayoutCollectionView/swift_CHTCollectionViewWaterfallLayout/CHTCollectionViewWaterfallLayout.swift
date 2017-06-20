//
//  CHTCollectionViewWaterfallLayout.swift
//  RxWaterfallLayoutCollectionView
//
//  Created by 张灿 on 2017/6/7.
//  Copyright © 2017年 FDD. All rights reserved.
//

import UIKit

/**
 *  Enumerated structure to define direction in which items can be rendered.
 */
public enum CHTCollectionViewWaterfallLayoutItemRenderDirection {
    case shortestFirst
    case leftToRight
    case rightToLeft
}

/**
 *  Constants that specify the types of supplementary views that can be presented using a waterfall layout.
 */
public struct CHTCollectionElementKind {
    /// A supplementary view that identifies the header for a given section.
    static let sectionHeader = "CHTCollectionElementKindSectionHeader"
    /// A supplementary view that identifies the footer for a given section.
    static let sectionFooter = "CHTCollectionElementKindSectionFooter"
}

// MARK: - CHTCollectionViewWaterfallLayout
public class CHTCollectionViewWaterfallLayout: UICollectionViewLayout {

    /**
     *  @brief sectionHeaderStyle
     *  @discussion Default: group
     */
    public enum Style {
        case group
        case plain
    }
    public var style = Style.plain {
        didSet {
            if style != oldValue {
                self.invalidateLayout()
            }
        }
    }

    /**
     *  @brief How many columns for this layout.
     *  @discussion Default: 2
     */
    public var columnCount = 2 {
        didSet {
            if columnCount != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The minimum spacing to use between successive columns.
     *  @discussion Default: 10.0
     */
    public var minimumColumnSpacing: CGFloat = 10.0 {
        didSet {
            if minimumColumnSpacing != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The minimum spacing to use between items in the same column.
     *  @discussion Default: 10.0
     *  @note This spacing is not applied to the space between header and columns or between columns and footer.
     */
    public var minimumInteritemSpacing: CGFloat = 10.0 {
        didSet {
            if minimumInteritemSpacing != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief Height for section header
     *  @discussion
     *    If your collectionView's delegate doesn't implement `collectionView:layout:heightForHeaderInSection:`,
     *    then this value will be used.
     *
     *    Default: 0
     */
    public var headerHeight: CGFloat = 0.0 {
        didSet {
            if headerHeight != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief Height for section footer
     *  @discussion
     *    If your collectionView's delegate doesn't implement `collectionView:layout:heightForFooterInSection:`,
     *    then this value will be used.
     *
     *    Default: 0
     */
    public var footerHeight: CGFloat = 0.0 {
        didSet {
            if footerHeight != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The margins that are used to lay out the header for each section.
     *  @discussion
     *    These insets are applied to the headers in each section.
     *    They represent the distance between the top of the collection view and the top of the content items
     *    They also indicate the spacing on either side of the header. They do not affect the size of the headers or footers themselves.
     *
     *    Default: UIEdgeInsetsZero
     */
    public var headerInset = UIEdgeInsets.zero {
        didSet {
            if headerInset != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The margins that are used to lay out the footer for each section.
     *  @discussion
     *    These insets are applied to the footers in each section.
     *    They represent the distance between the top of the collection view and the top of the content items
     *    They also indicate the spacing on either side of the footer. They do not affect the size of the headers or footers themselves.
     *
     *    Default: UIEdgeInsetsZero
     */
    public var footerInset = UIEdgeInsets.zero {
        didSet {
            if footerInset != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The margins that are used to lay out content in each section.
     *  @discussion
     *    Section insets are margins applied only to the items in the section.
     *    They represent the distance between the header view and the columns and between the columns and the footer view.
     *    They also indicate the spacing on either side of columns. They do not affect the size of the headers or footers themselves.
     *
     *    Default: UIEdgeInsetsZero
     */
    public var sectionInset = UIEdgeInsets.zero {
        didSet {
            if sectionInset != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The direction in which items will be rendered in subsequent rows.
     *  @discussion
     *    The direction in which each item is rendered. This could be left to right (CHTCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight), right to left (CHTCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft), or shortest column fills first (CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst).
     *
     *    Default: CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst
     */
    public var itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirection.shortestFirst {
        didSet {
            if itemRenderDirection != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The minimum height of the collection view's content.
     *  @discussion
     *    The minimum height of the collection view's content. This could be used to allow hidden headers with no content.
     *
     *    Default: 0.f
     */
    public var minimumContentHeight: CGFloat = 0.0 {
        didSet {
            if minimumContentHeight != oldValue {
                self.invalidateLayout()
            }
        }
    }
    /**
     *  @brief The calculated width of an item in the specified section.
     *  @discussion
     *    The width of an item is calculated based on number of columns, the collection view width, and the horizontal insets for that section.
     */
    public func itemWidth(InSectionAtIndex section: Int) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let sectionInset = self.delegate?.collectView(collectionView, layout: self, insetForSectionAtIndex: section) ?? self.sectionInset
        let width  = collectionView.bounds.size.width - sectionInset.left - sectionInset.right
        let columnCount = self.columnCount(section: section)
        let columnSpacing = self.delegate?.collectView(collectionView, layout: self, minimumColumnSpacingForSectionAtIndex: section) ?? self.minimumColumnSpacing

        return CHTCollectionViewWaterfallLayout.CHTFloor((width - CGFloat(columnCount - 1) * columnSpacing) / CGFloat(columnCount))
    }
    /// How many items to be union into a single rectangle
    fileprivate static let unionSize = 20
    /// The delegate will point to collection view's delegate automatically.
    fileprivate weak var delegate: CHTCollectionViewDelegateWaterfallLayout? {
        return (self.collectionView?.delegate as? CHTCollectionViewDelegateWaterfallLayout)
    }
    /// Array to store height for each column
    fileprivate var columnHeights = [[CGFloat]]()
    /// Array of arrays. Each array stores item attributes for each section
    fileprivate var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    /// Array to store attributes for all items includes headers, cells, and footers
    fileprivate var allItemAttributes = [UICollectionViewLayoutAttributes]()
    /// Dictionary to store section headers' attribute
    fileprivate var headersAttribute = [Int: UICollectionViewLayoutAttributes]()
    /// Dictionary to store section footers' attribute
    fileprivate var footersAttribute = [Int: UICollectionViewLayoutAttributes]()
    /// Array to store union rectangles
    fileprivate var unionRects = [CGRect]()
    /// Array to store a sectionHeaderStick rectangles, for compute HeaderStick
    fileprivate var headerStickRectangles = [CGRect]()

    fileprivate var fromHederStickChange = false
}

extension CHTCollectionViewWaterfallLayout {
    fileprivate static func CHTFloor(_ value: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return floor(value * scale) / scale
    }

    fileprivate func columnCount(section: Int) -> Int {
        guard let collectionView = collectionView,
              let delegate = delegate else {
            return self.columnCount
        }
        return delegate.collectView(collectionView, layout: self, columnCountForSection: section)
    }

    //MARK: - Methods to Override
    public override func prepare() {
        super.prepare()
        if fromHederStickChange == false {
            headersAttribute.removeAll()
            footersAttribute.removeAll()
            unionRects.removeAll()
            columnHeights.removeAll()
            allItemAttributes.removeAll()
            sectionItemAttributes.removeAll()
            headerStickRectangles.removeAll()

            guard let collectionView = collectionView else { return  }

            guard let numberOfSections = self.collectionView?.numberOfSections,
                numberOfSections > 0 else {
                    return
            }

            for section in 0..<numberOfSections {
                let columnCount = self.columnCount(section: section)
                let sectionColumnHeights = Array<CGFloat>(repeating: 0, count: columnCount)
                columnHeights.append(sectionColumnHeights)
            }

            // Create attributes
            var top: CGFloat = 0

            for section in 0..<numberOfSections {
                /*
                 * 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
                 */
                let minimumInteritemSpacing = self.delegate?.collectView(collectionView, layout: self, minimumInteritemSpacingForSectionAtIndex: section) ?? self.minimumInteritemSpacing

                let columnSpacing = self.delegate?.collectView(collectionView, layout: self, minimumColumnSpacingForSectionAtIndex: section) ?? self.minimumColumnSpacing

                let sectionInset = self.delegate?.collectView(collectionView, layout: self, insetForSectionAtIndex: section) ?? self.sectionInset

                let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
                let columnCount = self.columnCount(section: section)
                let itemWidth = CHTCollectionViewWaterfallLayout.CHTFloor((width - (CGFloat(columnCount) - 1) * columnSpacing) / CGFloat(columnCount))

                /*
                 * 2. Section header
                 */
                let headerHeight = self.delegate?.collectView(collectionView, layout: self, heightForHeaderInSection: section) ?? self.headerHeight
                let headerInset = self.delegate?.collectView(collectionView, layout: self, insetForHeaderInSection: section) ?? self.headerInset

                top += headerInset.top
                var sectionRect = CGRect(x: 0,
                                         y: top,
                                         width: collectionView.bounds.width,
                                         height: 0)

                if headerHeight > 0 {
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CHTCollectionElementKind.sectionHeader, with: IndexPath(row: 0, section: section))
                    attributes.frame = CGRect(x: headerInset.left,
                                              y: top,
                                              width: collectionView.bounds.width - headerInset.left - headerInset.right,
                                              height: headerHeight)
                    self.headersAttribute[section] = attributes
                    self.allItemAttributes.append(attributes)
                    top = attributes.frame.maxY + headerInset.bottom
                }

                top += sectionInset.top
                for index in 0..<columnCount {
                    self.columnHeights[section][index] = top
                }

                /*
                 * 3. Section items
                 */
                let itemCount = collectionView.numberOfItems(inSection: section)
                var itemAttributes = [UICollectionViewLayoutAttributes]()
                for index in 0 ..< itemCount {
                    let indexPath = IndexPath(row: index, section: section)
                    let columnIndex = nextColumnIndex(itemIndexPath: indexPath)
                    let xOffset = sectionInset.left + (itemWidth + columnSpacing) * CGFloat(columnIndex)
                    let yOffset = self.columnHeights[section][columnIndex]
                    let itemSize = self.delegate?.collectView(collectionView, layout: self, sizeForItemAtIndexPath: indexPath) ?? .zero
                    var itemHeight: CGFloat = 0
                    if itemSize.width > 0 && itemSize.height > 0 {
                        itemHeight = CHTCollectionViewWaterfallLayout.CHTFloor(itemSize.height * itemWidth / itemSize.width)
                    }
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(x: xOffset,
                                              y: yOffset,
                                              width: itemWidth,
                                              height: itemHeight)
                    itemAttributes.append(attributes)
                    self.allItemAttributes.append(attributes)
                    self.columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing

                }
                self.sectionItemAttributes.append(itemAttributes)

                /*
                 * 4. Section footer
                 */
                let columnIndex = longestColumnIndex(inSection: section)
                if self.columnHeights[section].count > 0 {
                    top = self.columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInset.bottom
                } else {
                    top = 0
                }

                let footerHeight = self.delegate?.collectView(collectionView, layout: self, heightForFooterInSection: section) ?? self.footerHeight
                let footerInset = self.delegate?.collectView(collectionView, layout: self, insetForFooterInSection: section) ?? self.footerInset
                top += footerInset.top

                if footerHeight > 0 {
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CHTCollectionElementKind.sectionFooter, with: IndexPath(row: 0, section: section))
                    attributes.frame = CGRect(x: footerInset.left,
                                              y: top,
                                              width: collectionView.bounds.width - footerInset.left - footerInset.right,
                                              height: footerHeight)
                    self.footersAttribute[section] = attributes
                    self.allItemAttributes.append(attributes)
                    top = attributes.frame.maxY + footerInset.bottom

                }
                
                for index in 0..<columnCount {
                    self.columnHeights[section][index] = top
                }

                /*
                 * 5. compute Section headerStickRectangle
                 */
                sectionRect = CGRect(x: sectionRect.minX,
                                     y: sectionRect.minY,
                                     width: sectionRect.width,
                                     height: top - sectionRect.minY)
                headerStickRectangles.append(sectionRect)
            }// end of for for section in 0..<numberOfSections
            
            // Build union rects
            var index = 0
            let itemCount = self.allItemAttributes.count
            while index < itemCount {
                var unionRect = self.allItemAttributes[index].frame
                let rectEndIndex = min(index + CHTCollectionViewWaterfallLayout.unionSize, itemCount)
                
                for i in (index + 1)..<(rectEndIndex) {
                    unionRect = unionRect.union(self.allItemAttributes[i].frame)
                }
                
                index = rectEndIndex
                
                self.unionRects.append(unionRect)
            }
        } else {
            fromHederStickChange = false
        }
    }

    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections == 0 {
            return .zero
        }

        var contentSize = collectionView.bounds.size
        contentSize.height = self.columnHeights.last?.first ?? 0

        if contentSize.height < self.minimumContentHeight {
            contentSize.height = self.minimumContentHeight
        }

        return contentSize
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= self.sectionItemAttributes.count  {
            return nil
        }
        if indexPath.item >= self.sectionItemAttributes[indexPath.section].count {
            return nil
        }
        return self.sectionItemAttributes[indexPath.section][indexPath.item]
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case CHTCollectionElementKind.sectionHeader:
            return self.headersAttribute[indexPath.section]
        case CHTCollectionElementKind.sectionFooter:
            return self.footersAttribute[indexPath.section]
        default:
            return nil
        }
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin = 0
        var end = self.unionRects.count

        for i in 0..<self.unionRects.count {
            if rect.intersects(self.unionRects[i]) {
                begin = i * CHTCollectionViewWaterfallLayout.unionSize
                break
            }
        }

        for i in (0..<self.unionRects.count).reversed() {
            if rect.intersects(self.unionRects[i]) {
                end = min((i + 1) * CHTCollectionViewWaterfallLayout.unionSize, self.allItemAttributes.count)
                break
            }
        }

        var result = [UICollectionViewLayoutAttributes]()
        for i in begin..<end {
            let attr = self.allItemAttributes[i]
            if rect.intersects(attr.frame) {
                result.append(attr)
            }
        }

        return result
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldRect = collectionView?.bounds ?? .zero
        if style == .plain {
            if newBounds != oldRect {
                sectionHeaderStickCounter(in: newBounds)
                fromHederStickChange = true
                return true
            }
        } else {
            if newBounds.width != oldRect.width {
                return true
            }
        }

        return false
    }

    // MARK: - private Method

    fileprivate func sectionHeaderStickCounter(in rect: CGRect) {

        let starPoint = CGPoint(x: rect.minX + 1, y: rect.minY + 1)
        var sectionRect: CGRect? = nil

        for frameItem in headerStickRectangles {
            if frameItem.contains(starPoint) {
                sectionRect = frameItem
                break
            }
        }

        guard let curRect = sectionRect  else {
            return
        }

        var stickHeader: UICollectionViewLayoutAttributes? = nil

        for attribute in self.headersAttribute.values {
            attribute.transform = .identity
            if curRect.contains(attribute.frame) {
                stickHeader = attribute
            }
        }

        if let header = stickHeader {
            header.zIndex = 1024
            let intersectionRect =  curRect.intersection(rect)
            if intersectionRect.height >= header.frame.height {
                header.transform = CGAffineTransform.identity
                    .translatedBy(x: intersectionRect.minX - header.frame.minX,
                                  y: intersectionRect.minY - header.frame.minY)
            } else {
                header.transform = CGAffineTransform.identity
                    .translatedBy(x: intersectionRect.minX - header.frame.minX,
                                  y: (intersectionRect.maxY - header.frame.height) - header.frame.minY)
            }
        }

        print("rect:\(rect)")
        print("curRect:\(curRect)")
    }

    fileprivate func nextColumnIndex(itemIndexPath: IndexPath) -> Int {
        var index = 0
        let columnCount = self.columnCount(section: itemIndexPath.section)
        switch itemRenderDirection {
        case .shortestFirst:
            index = shortestColumnIndex(inSection: itemIndexPath.section)
        case .leftToRight:
            index = itemIndexPath.item % columnCount
        case .rightToLeft:
            index = (columnCount - 1) - (itemIndexPath.item % columnCount)
        }
        return index
    }

    fileprivate func shortestColumnIndex(inSection section: Int) -> Int {
        var index = 0
        var shortestHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        for itemIndex in 0..<self.columnHeights[section].count {
            let height = self.columnHeights[section][itemIndex]
            if height < shortestHeight {
                shortestHeight = height
                index = itemIndex
            }
        }
        return index
    }

    fileprivate func longestColumnIndex(inSection section: Int) -> Int {
        var index = 0
        var longestHeight: CGFloat = 0
        for itemIndex in 0..<self.columnHeights[section].count {
            let height = self.columnHeights[section][itemIndex]
            if height > longestHeight {
                longestHeight = height
                index = itemIndex
            }
        }
        return index
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout
/**
 *  The CHTCollectionViewDelegateWaterfallLayout protocol defines methods that let you coordinate with a
 *  CHTCollectionViewWaterfallLayout object to implement a waterfall-based layout.
 *  The methods of this protocol define the size of items.
 *
 *  The waterfall layout object expects the collection view’s delegate object to adopt this protocol.
 *  Therefore, implement this protocol on object assigned to your collection view’s delegate property.
 */
public protocol CHTCollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {
    /**
     *  Asks the delegate for the size of the specified item’s cell.
     *
     *  @param collectionView
     *    The collection view object displaying the waterfall layout.
     *  @param collectionViewLayout
     *    The layout object requesting the information.
     *  @param indexPath
     *    The index path of the item.
     *
     *  @return
     *    The original size of the specified item. Both width and height must be greater than 0.
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, sizeForItemAtIndexPath indexPath:IndexPath ) -> CGSize

    /**
     *  Asks the delegate for the column count in a section
     *
     *  @param collectionView
     *    The collection view object displaying the waterfall layout.
     *  @param collectionViewLayout
     *    The layout object requesting the information.
     *  @param section
     *    The section.
     *
     *  @return
     *    The original column count for that section. Must be greater than 0.
     */
     func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, columnCountForSection section:Int ) -> Int

    /**
     *  Asks the delegate for the height of the header view in the specified section.
     *
     *  @param collectionView
     *    The collection view object displaying the waterfall layout.
     *  @param collectionViewLayout
     *    The layout object requesting the information.
     *  @param section
     *    The index of the section whose header size is being requested.
     *
     *  @return
     *    The height of the header. If you return 0, no header is added.
     *
     *  @discussion
     *    If you do not implement this method, the waterfall layout uses the value in its headerHeight property to set the size of the header.
     *
     *  @see
     *    headerHeight
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, heightForHeaderInSection section:Int ) -> CGFloat


    /**
     *  Asks the delegate for the height of the footer view in the specified section.
     *
     *  @param collectionView
     *    The collection view object displaying the waterfall layout.
     *  @param collectionViewLayout
     *    The layout object requesting the information.
     *  @param section
     *    The index of the section whose header size is being requested.
     *
     *  @return
     *    The height of the footer. If you return 0, no footer is added.
     *
     *  @discussion
     *    If you do not implement this method, the waterfall layout uses the value in its footerHeight property to set the size of the footer.
     *
     *  @see
     *    footerHeight
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, heightForFooterInSection section:Int ) -> CGFloat

    /**
     * Asks the delegate for the insets in the specified section.
     *
     * @param collectionView
     *   The collection view object displaying the waterfall layout.
     * @param collectionViewLayout
     *   The layout object requesting the information.
     * @param section
     *   The index of the section whose insets are being requested.
     *
     * @discussion
     *   If you do not implement this method, the waterfall layout uses the value in its sectionInset property.
     *
     * @return
     *   The insets for the section.
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForSectionAtIndex section:Int ) -> UIEdgeInsets

    /**
     * Asks the delegate for the header insets in the specified section.
     *
     * @param collectionView
     *   The collection view object displaying the waterfall layout.
     * @param collectionViewLayout
     *   The layout object requesting the information.
     * @param section
     *   The index of the section whose header insets are being requested.
     *
     * @discussion
     *   If you do not implement this method, the waterfall layout uses the value in its headerInset property.
     *
     * @return
     *   The headerInsets for the section.
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForHeaderInSection section:Int ) -> UIEdgeInsets

    /**
     * Asks the delegate for the footer insets in the specified section.
     *
     * @param collectionView
     *   The collection view object displaying the waterfall layout.
     * @param collectionViewLayout
     *   The layout object requesting the information.
     * @param section
     *   The index of the section whose footer insets are being requested.
     *
     * @discussion
     *   If you do not implement this method, the waterfall layout uses the value in its footerInset property.
     *
     * @return
     *   The footerInsets for the section.
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForFooterInSection section:Int ) -> UIEdgeInsets

    /**
     * Asks the delegate for the minimum spacing between two items in the same column
     * in the specified section. If this method is not implemented, the
     * minimumInteritemSpacing property is used for all sections.
     *
     * @param collectionView
     *   The collection view object displaying the waterfall layout.
     * @param collectionViewLayout
     *   The layout object requesting the information.
     * @param section
     *   The index of the section whose minimum interitem spacing is being requested.
     *
     * @discussion
     *   If you do not implement this method, the waterfall layout uses the value in its minimumInteritemSpacing property to determine the amount of space between items in the same column.
     *
     * @return
     *   The minimum interitem spacing.
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, minimumInteritemSpacingForSectionAtIndex section:Int ) -> CGFloat

    /**
     * Asks the delegate for the minimum spacing between colums in a secified section. If this method is not implemented, the
     * minimumColumnSpacing property is used for all sections.
     *
     * @param collectionView
     *   The collection view object displaying the waterfall layout.
     * @param collectionViewLayout
     *   The layout object requesting the information.
     * @param section
     *   The index of the section whose minimum interitem spacing is being requested.
     *
     * @discussion
     *   If you do not implement this method, the waterfall layout uses the value in its minimumColumnSpacing property to determine the amount of space between columns in each section.
     *
     * @return
     *   The minimum spacing between each column.
     */
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, minimumColumnSpacingForSectionAtIndex section:Int ) -> CGFloat
}

public extension CHTCollectionViewDelegateWaterfallLayout {
    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, columnCountForSection section:Int ) -> Int {
        return collectionViewLayout.columnCount
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, heightForHeaderInSection section:Int ) -> CGFloat {
        return collectionViewLayout.headerHeight
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, heightForFooterInSection section:Int ) -> CGFloat {
        return collectionViewLayout.footerHeight
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForSectionAtIndex section:Int ) -> UIEdgeInsets {
        return collectionViewLayout.sectionInset
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForHeaderInSection section:Int ) -> UIEdgeInsets {
        return collectionViewLayout.headerInset
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, insetForFooterInSection section:Int ) -> UIEdgeInsets {
        return collectionViewLayout.footerInset
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, minimumInteritemSpacingForSectionAtIndex section:Int ) -> CGFloat {
        return collectionViewLayout.minimumInteritemSpacing
    }

    func collectView(_ collectView:UICollectionView, layout collectionViewLayout: CHTCollectionViewWaterfallLayout, minimumColumnSpacingForSectionAtIndex section:Int ) -> CGFloat {
        return collectionViewLayout.minimumColumnSpacing
    }

}
