# PageMenu

<p align="center">
<a href="http://blog.chenyalun.com"><img src="https://img.shields.io/badge/language-swift-orange.svg"></a>
<a href="http://blog.chenyalun.com"><img src="https://img.shields.io/badge/platform-iOS-brightgreen.svg?style=flat"></a>
<a href="http://blog.chenyalun.com"><img src="http://img.shields.io/badge/license-MIT-orange.svg?style=flat"></a>
</p>




## Usage

+ PageMenu:

```
var controllerList = [UIViewController]()
let style: MenuStyle = MenuStyle()
// Menu style.
style.margin = 30
style.defaultColor = UIColor(r: 135, g: 135, b: 135)
style.selectedColor = UIColor(r: 0, g: 0, b: 0)
style.selectedFont = UIFont.boldSystemFont(ofSize: 18)
style.lineColor = UIColor.orange
style.lineHeight = 3

// View controller.
let red = UIViewController()
red.view.backgroundColor = UIColor.red
red.title = "关注"
let blue = UIViewController()
blue.view.backgroundColor = UIColor.blue
blue.title = "热门"
controllerList = [red, blue]

// PageMenu.
let pageMenu = PageMenu(style, controllerList)
pageMenu.pageTitle.backgroundColor = UIColor(r: 45, g: 184, b: 105)
addChild(pageMenu)
view.addSubview(pageMenu.view)

```

## Demo

![](/Resource/ithome.gif)

![](/Resource/weibo.gif)

## Author

[Aaron](http://chenyalun.com)

## License

PageMenu is available under the MIT license. See the LICENSE file for more info.


