# BDBPopupViewController

BDBPopupViewController is a UIViewController category for presenting custom view controllers modally. Using this category makes it trivial to present a view modal view controller that defines its own size and allows for a much more customized feel than is possible using Apple's built-in view controller presentation methods.

## Usage

Take a look at the PopoverViewDemo Xcode project to get started quickly.

To present a view controller as a popup:
```objective-c
- (void)presentPopupViewController:(UIViewController *)viewController withAnimation:(BDBPopupViewShowAnimationStyle)animation completion:(void (^)(void))completion;
````

To dismiss a popup view controller, simply call the following method from the parent view controller:
```objective-c
- (void)dismissPopupViewControllerWithAnimation:(BDBPopupViewHideAnimationStyle)animation completion:(void (^)(void))completion;
```

To easily access the current popup view controller, you can use the `popupViewController` property of the parent view controller.

## Screenshots
![iPhone Screenshot](iPhone.png)
![iPad Screenshot](iPad.png)

## Credits

BDBPopupViewController was created by [Bradley David Bergeron](http://www.bradbergeron.com). 