# Shifty

[![CI Status](http://img.shields.io/travis/wmcginty/Shifty.svg?style=flat)](https://travis-ci.org/wmcginty/Shifty)
[![Version](https://img.shields.io/cocoapods/v/Shifty.svg?style=flat)](http://cocoapods.org/pods/Shifty)
[![License](https://img.shields.io/cocoapods/l/Shifty.svg?style=flat)](http://cocoapods.org/pods/Shifty)
[![Platform](https://img.shields.io/cocoapods/p/Shifty.svg?style=flat)](http://cocoapods.org/pods/Shifty)

## Purpose
This library is intended as a supplement to the existing UIViewController transitioning APIs. While Shifty will not replace the UIKit view controller transitioning delegates and animators, it greatly simplifies the implementation of frame shift transitions while giving you the power to customize many parts of the animation to create unique effects.

## Key Concepts
* `TransitionRespondable` - A protocol representing any object that can respond to various callbacks from the transition animator throughout it's lifecycle.
* `State` - Encapsulates a target state for a shifting view, in both the source and the destination.
* `ShiftTransitionable` - A protocol representing any object (usually a UIViewController) that can vend `State` objects to the animator.
* `ShiftAnimator` - The animator object that manages the matching and coordinating of `State` objects between the source and destination.

## Usage
### TransitionRespondable
The  `TransitionRespondable` protocol can be used to create a huge variety of transitions. It allows you to separate out view controller specific effects and animations from the` UIViewControllerAnimatedTransitioning` object itself. This allows to create more reusable animators without losing the custom nature of the animations.

In order to create a simple transition between two view controllers whose backgrounds are identical (say both blue). We might create a `UIViewControllerAnimatedTransitioning` object:

```swift
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let container = transitionContext.containerView
    guard let sourceController = transitionContext.viewController(forKey: .from), let destinationController = transitionContext.viewController(forKey: .to) else { return }
    guard let destinationView = transitionContext.view(forKey: .to) else { return }
    guard let source = sourceController as? TransitionRespondable, let destination = destinationController as? TransitionRespondable else { return }

    destination.prepareForTransition(from: source)
    source.prepareForTransition(to: destination, withDuration: transitionDuration(using: transitionContext)) { finished in

    container.addSubview(destinationView)
    destinationView.frame = transitionContext.finalFrame(for: destinationController)

    source.completeTransition(to: destination)
    destination.completeTransition(from: source)
    transitionContext.completeTransition(finished)
}
```

This animator follows a simple sequence of events. After ensuring that the `UIViewControllerContextTransitioning` is configured properly, it will instruct the source to perform any animations necessary to facilitate a transition to the destination while at the same time giving the destination a chance to prepare itself before it's visible in the window.

Once those animations have completed by the source, the animator will add the `destinationView` to the container and configure it in it's final frame.

Finally, now that the destination view is visible (and obscuring the source view) it will instruct the source to clean up after itself, the destination to perform any animations or work necessary to complete the transition and will call back to the `UIViewControllerContextTransitioning` object to indicate the end of the transition.

But in order to complete the effect that these two screens are continuous, all the content on the source must be cleared, and all the content on the destination must be cleared before the swap itself can happen. In order to accomplish this we might implement `TransitionRespondable` on our source and destination view controllers:

```swift
extension ViewController: TransitionRespondable {
    func completeTransition(from source: TransitionRespondable?) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            animatingViews.forEach { $0.transform = .identity }
        }, completion: nil)
    }

    func completeTransition(to destination: TransitionRespondable?) {
        animatingViews.forEach { $0.transform = .identity }
    }

    func prepareForTransition(from source: TransitionRespondable?) {
        animatingViews.forEach { $0.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0) }
    }

    func prepareForTransition(to destination: TransitionRespondable?, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration - delay, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            animatingViews.forEach { $0.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0) }
        }, completion: completion)
    }
}
```

This will have the effect of animating all the intended views off the leading edge of the screen when acting as the source, and to animate back in from the leading edge when acting as the destination. Implementing this on both the source and destination of the  `UIViewControllerAnimatedTransitioning` object will create the illusion that it is one continuous screen.

### FrameShiftTransitionable

Sometimes in transitions like these, there is content that is consistent between two screens - if not in the exact same size or position. It would be ideal in these situations to not animate the content off screen only to animate it back on. Instead we can use the `ShiftTransitionable` protocol to move it to it's new position. First, we must tell our source and destination which views are eligible to move:

```swift
extension ViewController: ShiftTransitionable {
    /* This empty conformance is enough to inform the animator to search through this controller's subviews for eligible shiftables. */
    
    //The default value of this variable is true, setting to false will short-circuit the search. */
    var containsShiftables: Bool { return true }
    
    //The default value of this variable is an empty array, but allows you to short-circuit search in more complicated view hierarchies.
    var shiftExclusions: [UIView] { return [] }
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* ...other work... */

        yellowView.shiftID = "yellow"
        orangeView.shiftID = "orange"
    }
}
```

In this example, we have a yellow and orange view which are consistent between screens. Because their identifiers (which can be `AnyHashable`) are equal, the animator will match them up into a pair. It will move the `UIView` attached to each `State` from it's state in the source, to it's state in the destination. This will create the illusion that the content is moving from one place to another (similar to the magic move effect in Keynote).

The full list of `UIView` and `CALayer` properties that comprise `State` are so are automatically animatable are:
* `bounds`
* `center`
* `transform` and `layer.transform3d`
* `layer.cornerRadius`

In order to complete the effect and use this new shifting ability, we need to do a little bit more work in our animator:

```swift
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let container = transitionContext.containerView
    guard let sourceController = transitionContext.viewController(forKey: .from), let destinationController = transitionContext.viewController(forKey: .to) else { return }
    guard let destinationView = transitionContext.view(forKey: .to) else { return }
    guard let source = sourceController as? TransitionRespondable, let destination = destinationController as? TransitionRespondable else { return }
    guard let shiftSource = sourceController as? FrameShiftTransitionable, let shiftDestination = destinationController as? FrameShiftTransitionable else { return }

    shiftAnimator = ShiftAnimator(source: shiftSource, destination: shiftDestination)

    destination.prepareForTransition(from: source)
    source.prepareForTransition(to: destination, withDuration: transitionDuration(using: transitionContext)) { finished in

        container.addSubview(destinationView)
        destinationView.frame = transitionContext.finalFrame(for: destinationController)
        destinationView.layoutIfNeeded()

        source.completeTransition(to: destination)
        destination.completeTransition(from: source)
        self.shiftAnimator?.animate(with: 0.3, inContainer: container) { position in
            transitionContext.completeTransition(position == .end)
        }
    }
}
```
This animator method is nearly identical to the previous, with the addition of the `ShiftAnimator`. This object is created with a specific source and destination. At some point during the transition it will be instructed to animate the matches it finds between the source and destination states. This animation can be done as part of the transition (ending it when the frame shifts complete) or separately (the transition will end as soon as the shifts begin).

In addition, providing a custom `ShiftCoordinator` object will allow you to provide a custom `UITimingCurveProvider` object and a different relative start time and end time for each shift. Many more complicated examples are available to run in the example project.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Requires iOS 10.0 +, Swift 4.0

## Installation - CocoaPods

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'Shifty'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/wmcginty/Shifty/graphs/contributors
