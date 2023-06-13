# LSYNetworking

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)

LSYNetworking是基于 [AFNetworking][AFNetworking] 封装的iOS网络库，实现了对其的高度封装和对网络请求的高度抽象。

## LSYNetworking 的特点

LSYNetworking对网络请求的过程进行了抽象,并在一些关键的位置预留了,应对各种复杂的业务需求,使用者可根据自身的业务需求,在请求过程中的一些关键节点插入自己的逻辑,处理请求的各种数据

## LSYNetworking 实现的功能

* 支持统一设置服务器地址,支持在一个项目里设置多个服务器地址
* 支持将服务器返回的内容自动转换成model
* 支持请求参数以属性的方式定义,并自动转化为最终的请求参数
* 可对请求参数和返回值进行统一的加解密;
* 可对返回结果进行统一的缓存
* 可以模拟返回数据
* 支持文件的断点续传

## 安装

你可以在 Podfile 中加入下面一行代码来使用 LSYNetworking

    pod 'LSYNetworking' ~> 1.0

在 Cartfile 中加入下面的代码以使用 LSYNetworking

    github "liusiyangiOS/LSYNetworking" ~> 1.0

## 安装要求

| LSYNetworking 版本 | AFNetworking 版本 | 最低 iOS Target | 最低 macOS Target | 最低 watchOS Target | 最低 tvOS Target |       注意       |
| :---------------: | :---------------: | :------------: | :--------------: | :----------------: | :-------------: | :--------------: |
|       1.x         |        4.x        |     iOS 9      |   macOS 10.10    |    watchOS 2.0     |    tvOS 9.0     | 要求 Xcode 11 以上 |


## 协议

LSYNetworking 被许可在 MIT 协议下使用。查阅 LICENSE 文件来获得更多信息。

<!-- external links -->
[AFNetworking]:https://github.com/AFNetworking/AFNetworking

