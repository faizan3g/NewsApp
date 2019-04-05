# NewsApp
Demo app for news data
This app uses https://newsapi.org/ to fetch news data as NY Time website was not working and was not able to get the api key.

Following pods are used in the app:

pod Alamofire', '~> 4.5'
pod 'AlamofireSwiftyJSON'
pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
pod 'SDWebImage', '~> 4.0'

API url is stored in constant.swift file

How to run the project:
Intall Xcode and open MyApp.xcworkspace and run it on simulator.

If any error comes then open terminal and execute below command : 
pod install
