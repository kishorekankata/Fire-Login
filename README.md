# ![Fire Login](assets/Fire Login.png)

- An SPM package to seamlessly use Google's FireBase Authentication of Email and Phone number together. 

  ------

  # Welcome to FireLogin!

* This is a ***Swift package*** which you can add to your existing or new project to get the benifits of ***Firebase Authentication***.
* This package reduces your efforts to write logic for Integrating the Authentication.
* Checkout the example project [here]() to see how it is used.

## Installation

* > Goto File menu -> Click Add Package Dependencies -> paste the url - ***https://github.com/kishorekankata/Fire-Login.git***

* > Click on Add package.

------

## Setup guide

* Please ensure that you have already created an app in Firebase and it is properly registered in the console.
* Once your Firebase console is ready, Make sure you downloaded the GoogleServices.info plist file and properly configure the Firebase setup for your project.

> [!NOTE]
>
> Adding firebase to your app 
>
> [Adding Firebase to your Project]: https://firebase.google.com/docs/ios/setup#initialize_firebase_in_your_app	"here"

###### 	Usage:

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



###### and then for Phone number authentication:

> [!IMPORTANT]
>
> Before you add Phone number authentication, follow the setup Guidelines 
>
> [Phone Auth setup]: https://firebase.google.com/docs/auth/ios/phone-auth?	"here"

###### 	Usage:

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
