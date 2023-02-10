# Photo Gallery

This is a demo for Flutter project, it shows a list of photos from the internet and support paging

It aslo support pull to refresh feature, back to top feature and help user can view the image (with zoom in and out feature) and share the image to social network

# Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment section for notes on how to deploy the project on a live system.

## How to use
Download or clone this repo by using the link below


**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/nvkhanh/photo_gallery.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

## Photo Gallery Features:

* Gallery List
* View Detail Image
* Zoom in/out an image
* Share the image to social network


### Up-Coming Features:

* Local cache favorite photos
* Social login (Google)

### Libraries & Tools Used

* [http](https://pub.dev/packages/http)
* [cache image network](https://pub.dev/packages/cached_network_image)
* [mockito](https://pub.dev/packages/mockito)
* [flutter_bloc](https://pub.dev/packages/flutter_bloc)
* [easy_image_viewer](https://pub.dev/packages/easy_image_viewer)
* [equatable](https://pub.dev/packages/equatable)
* [bloc_test](https://pub.dev/packages/bloc_test)


### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- data/
  |- models/
  |- repositories/
|- domain/
  |- entities/
  |- repositories/
  |- usecase/
|- presentation/
  |- bloc/
  |- pages/
|- helpers/
|- main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- data - Contains the data layer of your project, includes directories for local, network and shared pref/cache.
3- domain - Contain the bussiness logic and link the data layer to presentation layer. 
4- presentation — Contains all the ui of your project, contains sub directory for each screen and state management in this project.
5- helpers — Contains the utilities/common functions of your application.
6- widgets — Contains the common widgets for your applications
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```

### Presentation

This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen specific widgets will be placed in `widgets` directory as shown in the example below:

```
presentation/
|- gallery_screen
   |- gallery_page.dart
   |- widgets
```

### Helpers

Contains the common file(s) and utilities used in a project. The folder structure is as follows: 

```
helpers/
|- utils.dart
```


### Main

This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.


## Conclusion

I will be happy to hear any feedback from you, and if you want to lend a hand with the project then please feel free to submit an issue and/or pull request 


