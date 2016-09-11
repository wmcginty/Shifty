# Shifty

<!---
#[![CI Status](http://img.shields.io/travis/William McGinty/Shifty.svg?style=flat)](https://travis-ci.org/William McGinty/Shifty)
-->

[![Version](https://img.shields.io/cocoapods/v/Shifty.svg?style=flat)](http://cocoapods.org/pods/Shifty)
[![License](https://img.shields.io/cocoapods/l/Shifty.svg?style=flat)](http://cocoapods.org/pods/Shifty)
[![Platform](https://img.shields.io/cocoapods/p/Shifty.svg?style=flat)](http://cocoapods.org/pods/Shifty)

Shifty is a simple but powerful framework designed to make it simple to create sleek frame shift transitions and animations without the trouble of doing all the under hood work yourself.

## Example

![Shifty](https://raw.githubusercontent.com/wmcginty/Shifty/master/Shifty.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

Shifty revolves around two protocols, *ContinuityTransitionable* and *FrameShiftable*. Although these two protocols have been designed to work together to create incredible effects, they work equally as well independently. 

*ContinuityTransitionable* is your gateway to creating transitions that make the parts of your app feel connected to each other in the ways that a standard transition can't.

For example, animate a view's title off screen before transitioning. But don't forget to bring it back on screen when transitioning back!

``` swift
extension ViewControllerA: ContinuityTransitionable {
    
    func prepareForTransition(to destination: UIViewController, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 200)
        }) { (finished) in
            completion(finished)
        }
    }
    
    func completeTransition(from source: UIViewController) {
        UIView.animate(withDuration: 0.3) { 
            self.shiftButton.transform = CGAffineTransform.identity
        }
    }
}
```

Need some place to prepare your views for incoming or outgoing transitions? Use the *ContinuityTransitionPreparable* protocol for that:

``` swift
public protocol ContinuityTransitionPreparable: ContinuityTransitionable {
    
    func prepareForTransition(from source: UIViewController)
    func completeTransition(to destination: UIViewController)
    
}
```

But what if you want to take that awesome view you designed from screen A, and show it someplace else on screen B? What if you could just pick it up from screen A and move it to screen B when you needed to? Enter, *FrameShiftable*:

``` swift
extension ViewControllerA: FrameShiftable {
    func shiftablesForTransition(with viewController: UIViewController) -> [Shiftable] {
        return [Shiftable(view: yellowView, identifier: "yellow"),
                Shiftable(view: orangeView, identifier: "orange"),
                Shiftable(view: titleLabel, identifier: "title")]
    }
}
```

Just tell Shifty what views you want to move, and it will do the rest. When you ask Shifty to do it's thing, it'll check the source and the destination and find all the views with common identifiers. Then, Shifty will figure out where those views are, and where they need to get to. All you need to do is tell Shifty to do it's thing:

``` swift
let shiftAnimator = self.initializeFrameShiftAnimatorWith(sourceViewController, destinationViewController: destinationViewController)
shiftAnimator?.performFrameShiftAnimations(in: containerView, with: destinationView, over: self.transitionDuration(using: transitionContext)) {
    //Completion
}
```

Finally, what if the default ease in, ease out shift animation isn't good enough? That's where *CustomFrameShiftable* comes in. This allows you to provide your own custom animations - and they don't have to be UIView based:

``` swift
public protocol CustomFrameShiftable: FrameShiftable {
    func performShift(with shiftingView: UIView, in containerView: UIView, with finalState: Snapshot, duration: TimeInterval?, completion: () -> Void)
}
```

## Requirements

* Swift 3.0
* iOS 9+

## Installation

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

``` bash
$ gem install cocoapods
```

To integrate Shifty into your Xcode project using CocoaPods, specify it in your `Podfile`:

``` ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'Shifty'
```

Then, run the following command:

``` bash
$ pod install
```

You should open the `{Project}.xcworkspace` instead of the `{Project}.xcodeproj` after you installed anything from CocoaPods.

## Contact

William McGinty, mcgintw@gmail.com

If you find an issue or want to request a feature, please [raise an issue](https://github.com/wmcginty/Shifty/issues/new). Pull requests are always welcome!

## License

Shifty is available under the MIT license. See the LICENSE file for more info.
