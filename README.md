[![Build Status](https://travis-ci.org/jordidekock/Colorblinds.svg?branch=master)](https://travis-ci.org/jordidekock/Colorblinds)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com)
[![Language Swift 2.2](https://img.shields.io/badge/Language-Swift%202.2-orange.svg?style=flat)](https://swift.org)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/jordidekock/Colorblinds/LICENSE)
[![Version](https://img.shields.io/cocoapods/v/Colorblinds.svg?style=flat)](http://cocoadocs.org/docsets/Colorblinds)

# Colorblinds
Colorblinds is a easy to use library to simulate color blindness within your app. The feature can be easily activated with a 3-tap gesture. Once activated you can choose from four types of color blindness:

- Deuteranomaly
- Deuteranopia
- Protanomaly
- Protanopia
 
<img src="https://github.com/jordidekock/Colorblinds/blob/master/screen1.PNG" width="300">
<img src="https://github.com/jordidekock/Colorblinds/blob/master/screen2.PNG" width="300">

# Compatibility
Colorblinds requires iOS 8 or higher and is written in Swift 3.

### Using CocoaPods
Colorblinds is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod ‘Colorblinds’
```

### Manually
Clone or Download this Repo. Then simply drag files in the folder ```Source``` to your Xcode project.


# Example
```Swift
import Colorblinds
CBController.sharedInstance.startForWindow(window!)
```

# Todos
 - Support Carthage
 - Support animations
 - Support more color blindness types
 
# License
MIT