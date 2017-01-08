//
//  BSSliderView.swift
//  Pods
//
//  Created by Bobby Stenly Irawan on 12/17/16.
//
//

import Foundation
import UIKit

public protocol BSSliderViewDelegate: class {
    func sliderView(_ sliderView: BSSliderView, didSelectItemAt indexPath: IndexPath)
}

public protocol BSSliderViewDataSource: class {
    func numberOfItemsInSliderView(_ sliderView: BSSliderView) -> Int
    func sliderView(_ sliderView: BSSliderView, itemFor indexPath: IndexPath) -> UICollectionViewCell
}

@IBDesignable open class BSSliderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    //public var
    weak open var delegate: BSSliderViewDelegate?
    weak open var dataSource: BSSliderViewDataSource?
    public var currentIndex: Int {
        get{
            return self.currentSlideIndex - 1
        }
    }
    public var collectionView: UICollectionView {
        get{
            return self.sliderCollectionView
        }
    }
    
    public var isAutoPlay: Bool = true
    public var autoPlaySpeed: TimeInterval = 5
    @IBInspectable public var paginationMarginBottom: CGFloat = 8.0
    @IBInspectable public var paginationDotSize: CGFloat = 15.0
    @IBInspectable public var paginationDotMargin: CGFloat = 10.0
    @IBInspectable public var paginationDotBorderWidth: CGFloat = 2.0
    @IBInspectable public var paginationDotBorderColor: UIColor = UIColor.black
    @IBInspectable public var paginationDotUnselectedColor: UIColor = UIColor.white
    @IBInspectable public var paginationDotSelectedColor: UIColor = UIColor.black
    //---end of public var
    
    //public function
    public func register(nib: UINib?, forCellWithReuseIdentifier: String){
        self.sliderCollectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    public func reloadSliderView(){
        self.sliderCollectionView.reloadData()
        self.currentSlideIndex = 1
        let numberOfItems = self.sliderCollectionView.numberOfItems(inSection: 0)
        if numberOfItems > 0 {
            self.sliderCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        }
        
        if numberOfItems > 3 {
            self.sliderCollectionView.isScrollEnabled = true
            self.sliderCollectionView.addGestureRecognizer( self.panGestureRecognizer )
            if self.isAutoPlay {
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: self.autoPlaySpeed, target: self, selector: #selector(BSSliderView.next(_ : )), userInfo: nil, repeats: false)
            }
        }
        else{
            self.sliderCollectionView.isScrollEnabled = false
        }
        
    }
    //--end of public function
    
    private var currentSlideIndex: Int = 1
    private var sliderCollectionView: UICollectionView
    private var sliderLayout: BSSliderCollectionViewLayout
    private var paginationView: UIView
    private var paginationViewWidth: NSLayoutConstraint
    private var timer: Timer
    private var panGestureRecognizer: UIPanGestureRecognizer
    
    #if !TARGET_INTERFACE_BUILDER
    required public init?(coder aDecoder: NSCoder) {
        self.sliderLayout = BSSliderCollectionViewLayout()
        self.sliderCollectionView = UICollectionView(frame: CGRect(x:0, y:0, width:100, height:100), collectionViewLayout: self.sliderLayout)
        self.paginationView = UIView()
        self.paginationViewWidth = NSLayoutConstraint()
        self.timer = Timer()
        self.panGestureRecognizer = UIPanGestureRecognizer()
        super.init(coder: aDecoder)
        self.setup()
    }
    #endif
    
    required public override init(frame: CGRect) {
        self.sliderLayout = BSSliderCollectionViewLayout()
        self.sliderCollectionView = UICollectionView(frame: CGRect(x:0, y:0, width:0, height:0), collectionViewLayout: self.sliderLayout)
        self.paginationView = UIView()
        self.paginationViewWidth = NSLayoutConstraint()
        self.timer = Timer()
        self.panGestureRecognizer = UIPanGestureRecognizer()
        super.init(frame: frame)
        self.setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    deinit {
        self.sliderCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    fileprivate func setup() {
        self.sliderCollectionView.bounces = false
        self.sliderCollectionView.backgroundColor = UIColor.white
        self.sliderCollectionView.showsVerticalScrollIndicator = false
        self.sliderCollectionView.showsHorizontalScrollIndicator = false
        self.sliderCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.sliderCollectionView)
        self.addConstraint(NSLayoutConstraint(
            item: self.sliderCollectionView,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 0
        ))
        self.addConstraint(NSLayoutConstraint(
            item: self.sliderCollectionView,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: 0
        ))
        self.addConstraint(NSLayoutConstraint(
            item: self.sliderCollectionView,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.left,
            multiplier: 1.0,
            constant: 0
        ))
        self.addConstraint(NSLayoutConstraint(
            item: self.sliderCollectionView,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0
        ))
        
        self.sliderCollectionView.delegate = self
        self.sliderCollectionView.dataSource = self
        
        self.paginationView.backgroundColor = UIColor.clear
        self.paginationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.paginationView)
        self.addConstraint(NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.paginationView,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: self.paginationMarginBottom
        ))
        self.addConstraint(NSLayoutConstraint(
            item: self.paginationView,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1.0,
            constant: 0
        ))
        self.paginationViewWidth = NSLayoutConstraint(
            item: self.paginationView,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1.0,
            constant: 0
        )
        self.paginationView.addConstraint(self.paginationViewWidth)
        self.paginationView.addConstraint(NSLayoutConstraint(
            item: self.paginationView,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1.0,
            constant: self.paginationDotSize
        ))
        
        //gesture recognizer
        self.panGestureRecognizer.addTarget(self, action: #selector(BSSliderView.sliderPanGestureRecognizer(_:)))
        self.panGestureRecognizer.delegate = self

        self.sliderCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.sliderCollectionView.isScrollEnabled = false
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            self.setupPagination()
        }
    }
    
    private func setupPagination(){
        
        for view in self.paginationView.subviews {
            view.removeFromSuperview()
        }
        
        let numberOfItems = max(self.sliderCollectionView.numberOfItems(inSection: 0) - 2, 0)
        if numberOfItems > 1 {
            self.paginationViewWidth.constant = (CGFloat(numberOfItems) * self.paginationDotSize) + (CGFloat(numberOfItems) * self.paginationDotMargin)
            
            for i in 0..<numberOfItems {
                let page = UIView(frame: CGRect(x: CGFloat(i) * (self.paginationDotSize + self.paginationDotMargin), y: 0, width: self.paginationDotSize, height: self.paginationDotSize))
                
                page.layer.borderWidth = self.paginationDotBorderWidth
                page.layer.borderColor = self.paginationDotBorderColor.cgColor
                page.layer.cornerRadius = self.paginationDotSize / 2.0
                if i == self.currentSlideIndex - 1 {
                    page.backgroundColor = self.paginationDotSelectedColor
                }
                else{
                    page.backgroundColor = self.paginationDotUnselectedColor
                }
                self.paginationView.addSubview(page)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            let numberOfItems = dataSource.numberOfItemsInSliderView(self)
            if numberOfItems > 0 {
                return numberOfItems + 2
            }
            else{
                return 0
            }
        }
        else{
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let dataSource = self.dataSource {
            let numberOfItems = self.sliderCollectionView.numberOfItems(inSection: indexPath.section)
            if indexPath.row == 0 {
                return dataSource.sliderView(self, itemFor: IndexPath(row: numberOfItems - 3, section: indexPath.section))
            }
            else if indexPath.row == numberOfItems - 1{
                return dataSource.sliderView(self, itemFor: IndexPath(row: 0, section: indexPath.section))
            }
            else{
                return dataSource.sliderView(self, itemFor: IndexPath(row: indexPath.row - 1, section: indexPath.section))
            }
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.sliderView(self, didSelectItemAt: IndexPath(row: indexPath.row - 1, section: indexPath.section))
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func sliderPanGestureRecognizer(_ recognizer: UIPanGestureRecognizer){
        
        if recognizer.state == UIGestureRecognizerState.ended {
            //kill the smooth scroll first
            self.sliderCollectionView.isScrollEnabled = false
            //---end of kill the smooth scroll first
            var offset = self.sliderCollectionView.contentOffset
            
            let numberOfItems = self.sliderCollectionView.numberOfItems(inSection: 0)
            let itemWidth = self.sliderCollectionView.frame.size.width
            var currentIndex: Int = Int(floor(offset.x / itemWidth))
            
            var nextIndex: Int = currentIndex
            let currentItemOffset = (offset.x - (CGFloat(currentIndex) * itemWidth)) / itemWidth
            
            if currentIndex == self.currentSlideIndex { //swipe left
                if currentItemOffset > 0.4 {
                    nextIndex = nextIndex + 1
                    if currentIndex == numberOfItems - 2 {
                        offset.x = offset.x - CGFloat(numberOfItems - 2) * itemWidth
                        self.sliderCollectionView.setContentOffset(offset, animated: false)
                        currentIndex = 0
                        nextIndex = 1
                    }
                }
            }
            else{ // swipe right
                if currentItemOffset > 0.6 {
                    nextIndex = nextIndex + 1
                }
                else if currentIndex == 0 {
                    offset.x = CGFloat(numberOfItems - 2) * itemWidth + offset.x
                    self.sliderCollectionView.setContentOffset(offset, animated: false)
                    currentIndex = numberOfItems - 2
                    nextIndex = currentIndex
                }
            }
            if nextIndex < 0 {
                nextIndex = 0
            }
            if nextIndex > numberOfItems - 1 {
                nextIndex = numberOfItems - 1
            }
            
            //kill the smooth scroll second
            offset.x = offset.x - 1
            self.sliderCollectionView.setContentOffset(offset, animated: false)
            offset.x = offset.x + 1
            self.sliderCollectionView.setContentOffset(offset, animated: false)
            //---end of kill the smooth scroll second
            
            self.currentSlideIndex = nextIndex
            // Below is the hack for killing the smooth scroll.
            // TO DO : remove the delay without allowing smooth scrolling
            let when = DispatchTime.now() + 0.05
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.sliderCollectionView.scrollToItem(at: IndexPath(row:nextIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            }
            
            //enable the scroll
            self.sliderCollectionView.isScrollEnabled = true
            //---end of enable the scroll
            
            //reset timer
            if self.isAutoPlay {
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: self.autoPlaySpeed, target: self, selector: #selector(BSSliderView.next(_ : )), userInfo: nil, repeats: false)
            }
        }
    }
    
    public func next(_ timer: Timer) {
        let numberOfItems = self.sliderCollectionView.numberOfItems(inSection: 0)
        if numberOfItems > 0 {
            if self.currentSlideIndex == numberOfItems - 2 {
                self.sliderCollectionView.scrollToItem(at: IndexPath(row:0, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
                self.currentSlideIndex = 1
            }
            else{
                self.currentSlideIndex = self.currentSlideIndex + 1
            }
            self.sliderCollectionView.scrollToItem(at: IndexPath(row: self.currentSlideIndex, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: self.autoPlaySpeed, target: self, selector: #selector(BSSliderView.next(_ : )), userInfo: nil, repeats: false)
        }
    }
}
