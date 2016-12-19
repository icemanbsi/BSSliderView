# BSSliderView

[![CI Status](http://img.shields.io/travis/Bobby Stenly/BSSliderView.svg?style=flat)](https://travis-ci.org/Bobby Stenly/BSSliderView)
[![Version](https://img.shields.io/cocoapods/v/BSSliderView.svg?style=flat)](http://cocoapods.org/pods/BSSliderView)
[![License](https://img.shields.io/cocoapods/l/BSSliderView.svg?style=flat)](http://cocoapods.org/pods/BSSliderView)
[![Platform](https://img.shields.io/cocoapods/p/BSSliderView.svg?style=flat)](http://cocoapods.org/pods/BSSliderView)

## Description
BSSliderView is a widget that allowed you to have your own carousel / slideshow in your app. This widget basically is an inheritance from UICollectionView, so you can add your own slide design from nib / xib file. 

![alt text](http://bobbystenly.com/cocoapod/BSSliderView/sample.gif "BSSliderView Sample")


## Installation

BSSliderView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BSSliderView"
```

## How To Use

1. Create BSSliderView element in you storyboard / xib file. You can start it with create a UIView and then change the class name and module into BSSliderView.
2. In your view controller, add delegate and data source for the slider.
3. Register your slide nib / xib file with `register` function. For example : 
```swift
self.slider.register(nib: UINib(nibName: "ImageSlideCell", bundle: nil), forCellWithReuseIdentifier: "imageSlideCell")
```
4. Add `reloadSliderView` in `viewDidAppear` method.
```swift
self.slider.reloadSliderView()
```
5. Start adding your data. Please remember, everytime you update your data source, don't forget to call `reloadSliderView` to refresh the slider.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Bobby Stenly, iceman.bsi@gmail.com

## License

BSSliderView is available under the MIT license. See the LICENSE file for more info.
