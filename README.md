###信鸽推送SDK2.4.0Swift1.2Demo
---
> ##### 开发环境:OS X Yosemite 10.10.3 + Xcode 6.4

> ##### 开发语言:Swift 1.2

###使用方法
---
* 把`XinGeSDK2_4_0`文件拷贝到工程中
* 拷贝`XinGeAppDelegate.swift`到工程中
* 在	`工程名-Bridging-Header.h`桥接文件中，添加
```swift
#import "XGSetting.h"
#import "XGPush.h"
```
* `AppDelegate`继承`XinGeAppDelegate`,并且两者有且只有一个`var window: UIWindow?`属性。继承的方法前需要添加`override`关键字，例如:
```swift
import UIKit

@UIApplicationMain
class AppDelegate: XinGeAppDelegate{
    
    var window: UIWindow?
    
    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // 在此处，可以设置UI等操作。
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```


* 在`XinGeAppDelegate.swift`文件中填写`ACCESS ID`和`ACCESS KEY`，从[腾讯信鸽官网](http://xg.qq.com/xg/)创建应用并提交材料。



###添加必要的框架: 
---
 
* `CoreGraphics.framework`
* `CoreTelephony.framework`
* `SystemConfiguration.framework`
* `libz.dylib`
* `CFNetwork.framework`
* `libsqlite3.dylib`
