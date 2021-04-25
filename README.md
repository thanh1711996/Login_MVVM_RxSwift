# Login_MVVM_RxSwift
Create base login application with MVVM + RxSwift

This is an Demo login app that implements MVVM architecture and using RxSwift.

#### The app has following packages:
1. **Base**: It contains abstract class to that have common functions.
2. **BaseViewModelChange**: It contains the model states.
3. **DataManager**: It contains all the data accessing and manipulating components.
4. **Extension**: It contains some custom views, string.
5. **CommonView**: It contains some base views.

### Code flow:
#### LaunchScreen: 
1. First screen, then navigate to Login.

#### Login screen: Login flow
1. It will check for phone number, if it's ok, it will call handleLogin() function from LoginViewModel.
2. handleLogin() function in LoginViewModel: it will call pushToVerifyCodeViewController() function from LoginViewController.
3. pushToVerifyCodeViewController(): it navigate to the verify code screen.

#### Verify code screen: Verify code flow
1. It will check validate for code, if it's ok, it will call handleVerifyCode() function from VerifyCodeViewModel.
2. handleVerifyCode() function in VerifyCodeViewModel: check for correct code, if wrong show error, if right (the correct code is 0110) call pushToHomeViewController() function from VerifyCodeViewController.
3. pushToHomeViewController(): it navigate to the home screen.

#### Home screen: 
1. Show data demo

#### Classes have been designed in such a way that it could be inherited and maximize the code reuse.

### Library reference resources:
1. RxSwift: https://github.com/ReactiveX/RxSwift
2. FSPagerView: https://github.com/WenchaoD/FSPagerView
