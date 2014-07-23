# BDBPopupViewController

BDBPopupViewController is a UIViewController category for presenting custom view controllers modally. Using this category makes it trivial to present a modal view controller that defines its own size and allows for a much more customized look and feel than is possible using UIKit's default view controller presentation methods.

Take a look at the included demo project to get started quickly.

## Usage

BDBPopupViewController is simple to use because there are only two methods: one for presenting a popup view controller, and one for dismissing it.

```objc
- (void)bdb_presentPopupViewController:(UIViewController *)viewController
                         withAnimation:(BDBPopupViewShowAnimationStyle)animation
                            completion:(void (^)(void))completion;

- (void)bdb_dismissPopupViewControllerWithAnimation:(BDBPopupViewHideAnimationStyle)animation
                                         completion:(void (^)(void))completion;
```

There is also a `popupViewController` property that allows you to quickly and easily access the currently displayed popup view controller from its parent view controller.

### Animation Styles

Animations are split into `BDBPopupViewShowAnimationStyle` and `BDBPopupViewHideAnimationStyle` so that you can completely customize how your popup view controller is presented and dismissed.

#### Default

`BDBPopupViewShowAnimationDefault` / `BDBPopupViewHideAnimationDefault`

The default show/hide animation displays a popup view controller in the same default manner as a normal modal view controller. The current view controller is dimmed, and the popup view controller animates in from the bottom of the screen. When dismissed, the popup view controller slides down and the parent view controller becomes active.

#### Zoom In/Out

`BDBPopupViewShowAnimationZoomIn` / `BDBPopupViewHideAnimationZoomOut`

Likely to be the most used animation, the zoom in/out animation does exactly what its name implies: the popup view controller grows from the center of the screen with a little elasticity once it reaches the full size of the view controller (or the screen size on an iPhone). It shrinks back into the center of the screen when dismissed.

#### Drop-Down / Takeoff

`BDBPopupViewShowAnimationDropDown` / `BDBPopupViewHideAnimationTakeoff`

The popup view controller slides in from the top of the screen with a bounce effect and slides back up when dismissed.

## Screenshots
![iPhone Screenshot](https://dl.dropboxusercontent.com/u/6225/GitHub/BDBPopupViewController/iPad.png)
![iPad Screenshot](https://dl.dropboxusercontent.com/u/6225/GitHub/BDBPopupViewController/iPhone.png)

## Credits

BDBPopupViewController was created by [Bradley David Bergeron](http://www.bradbergeron.com). 
