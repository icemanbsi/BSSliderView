//
//  ViewController.swift
//  BSSliderView
//
//  Created by Bobby Stenly on 12/17/2016.
//  Copyright (c) 2016 Bobby Stenly. All rights reserved.
//

import UIKit
import BSSliderView

class ViewController: UIViewController, BSSliderViewDataSource, BSSliderViewDelegate {
    
    @IBOutlet weak var slider: BSSliderView!
    
    let data = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.slider.register(nib: UINib(nibName: "ImageSlideCell", bundle: nil), forCellWithReuseIdentifier: "imageSlideCell")
        self.slider.delegate = self
        self.slider.dataSource = self
        
        
        // After adding data, please call reloadSliderView.
        // The first reloadSlider view should called inside viewDidAppear to get the view size precisely
        self.data.add("img1.jpg")
        self.data.add("img2.jpg")
        self.data.add("img3.jpg")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.slider.reloadSliderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfItemsInSliderView(_ sliderView: BSSliderView) -> Int {
        return self.data.count
    }
    
    func sliderView(_ sliderView: BSSliderView, itemFor indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderView.collectionView.dequeueReusableCell(withReuseIdentifier: "imageSlideCell", for: indexPath)
        
        if let imgView = cell.viewWithTag(1) as? UIImageView {
            imgView.image = UIImage(named: data[indexPath.row] as! String)
        }
        
        return cell
    }
    
    func sliderView(_ sliderView: BSSliderView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Slider Clicked at index : \(indexPath.row)")
    }
}

