![Fire Login](https://github.com/kishorekankata/Fire-Login/assets/29530987/4a084cb8-1d24-49fd-8ab2-7443e7ad6fc9)

# Welcome to FireLogin!

An SPM package for seamlessly using Google's FireBase Authentication of Email and Phone number together.
* This is a ***Swift package*** which you can add to your existing or new project to get the benifits of ***Firebase Authentication***.
* This package reduces your efforts to write logic for Integrating the Authentication.
* Checkout the example project [here](https://github.com/kishorekankata/FireLogin-Example) to see how it is used.
------
## Installation

* Goto File menu -> Click Add Package Dependencies -> paste the below package url in the search bar
  ` https://github.com/kishorekankata/Fire-Login.git `
* Select 'Up to Next Major Version' click on **Add Package**
* This will fetch FireLogin to your project along with all Firebase dependencies into your project.
* Boom! you are done and ready to use authentication. Follow this Example Project to see how you can use this Package [Click](https://github.com/kishorekankata/FireLogin-Example)

------

## Setup guide

* Please ensure that you have already created an app in Firebase and it is properly registered in the [console](https://console.firebase.google.com/).
* Once your Firebase console is ready, Make sure you downloaded the GoogleServices.info plist file and properly configure the Firebase setup for your project.


> Adding Firebase to your app - https://firebase.google.com/docs/ios/setup#initialize_firebase_in_your_app
>

###### 	Email Authentication:

```swift
import FireLogin

//For Signup
          FireAuthentication.shared.createUser(with: emailText, password: password) { [weak self] result in
              self?.handleFireLoginResponse(result)
          }
                
 //For SignIn
          FireAuthentication.shared.signInUser(with: emailText, password: password) { [weak self] result in
                  self?.handleFireLoginResponse(result)
          }
```

> [!IMPORTANT]
>
> Before you add Phone number authentication, follow the setup Guidelines for Phone Auth here - https://firebase.google.com/docs/auth/ios/phone-auth?

###### 	Phone Number Authentication:

```swift
import FireLogin

//For Sending OTP
          FireAuthentication.shared.startAuth(phoneNumber: number) { success in
                self.didSentOTP = success
            }
                
 //For Verifying OTP
          FireAuthentication.shared.verifyCode(smsCode: OTP) { success in
                self.phoneVerified = success
            }
```

------

#### <u>**Thank you for Visiting.... Happy Coding!**</u>
