
[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

# Getir Lite App
<br />
<p align="center">
  <p align="center">
    Getir Lite App is a scaled down version of the iOS app for Getir. This app was developed as the final project of Getir and Patika's bootcamp.
  </p>
</p>

## Screenshots
| ![Splash Screen](https://github.com/GradByte/GetirLiteApp/blob/main/images/1.png) | ![Product Listing](https://github.com/GradByte/GetirLiteApp/blob/main/images/2.png) | ![Product Listing](https://github.com/GradByte/GetirLiteApp/blob/main/images/3.png) | ![Product Detail](https://github.com/GradByte/GetirLiteApp/blob/main/images/4.png) |
| --- | --- | --- | --- |
| Splash Screen | Product Listing | Product Listing | Product Detail |

| ![Product Detail](https://github.com/GradByte/GetirLiteApp/blob/main/images/5.png) | ![Shopping Cart](https://github.com/GradByte/GetirLiteApp/blob/main/images/6.png) | ![Shopping Cart](https://github.com/GradByte/GetirLiteApp/blob/main/images/7.png) | ![Order Message](https://github.com/GradByte/GetirLiteApp/blob/main/images/8.png) |
| --- | --- | --- | --- |
| Product Detail | Shopping Cart | Shopping Cart | Order Message |

## Features

- [x] Product Listing
- [x] Product Detail
- [x] Shopping Cart

## Requirements

- iOS 15.2+
- Xcode 13.2+

## How to run?

Running this application is a straightforward process, requiring no special configurations. However, in case you encounter any issues during execution, ensure that you are utilizing the recommended versions of the package dependencies listed below:

- Alamofire: 5.9.1
- Kingfisher: 7.11.0

## Technical Details

- iOS Version and Framework: The app is built for iOS 15.2 and above using UIKit framework.
- Architecture: VIPER (View, Interactor, Presenter, Entity, Router) architecture pattern is employed for organizing the codebase. This promotes separation of concerns and facilitates unit testing.
- UI Layout: Compositional Layout is utilized for arranging UI elements, providing flexibility and efficiency in managing complex layouts.
- Data Management:
    - Singleton Class: A singleton class named "LocalData" is implemented for storing selected products and total bill locally. This ensures a single instance of the class throughout the app's lifecycle.
    - Core Data Integration: Core Data is employed for saving and loading selected products and total bill state, ensuring persistence even when the app is closed or reopened.
- Networking: Alamofire is used as the networking manager to handle API requests and responses efficiently. This abstracts away the complexities of network handling and provides a cleaner interface for API interactions.
- Custom Cells:
    - Product Cell: A custom cell used in both the listing and shopping cart screens to display product information.
    - Selected Product Cell: Another custom cell exclusively used in the shopping cart screen to display selected products.
- Protocol Implementation:
    - ProductProtocol: Implemented to transform MainProduct and SuggestedProduct objects into a unified Product format. This abstraction allows for easier management and display of product data in the collection view cells.
- Functionality:
    - Persistence: The use of Core Data ensures that selected products and total bill are preserved across app sessions, preventing data loss.
    - Lifecycle Management: The app utilizes lifecycle events such as closing and opening to trigger Core Data operations for saving and loading data, maintaining continuity in user experience.

## Meta

Efe Ertekin – [@Instagram](https://www.instagram.com/gradbyte.codes/)

[swift-image]:https://img.shields.io/badge/swift-5.5.2-orange.svg
[swift-url]: https://swift.org/
