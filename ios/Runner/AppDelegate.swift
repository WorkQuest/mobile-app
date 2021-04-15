import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
//    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//
//    let channel = FlutterMethodChannel(name: "web3Channel", binaryMessenger: controller as! FlutterBinaryMessenger)
//
//    channel.setMethodCallHandler({
//        [weak self](call: FlutterMethodCall, result: FlutterResult) -> Void in
//
//        switch call.method {
//        case "generateSeed":
//            self?.generateSeed()
//        default:
//            result(FlutterMethodNotImplemented)
//            return
//        }
//    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
//    private func generateSeed() {
//        let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 256)!
//        let keystore = try! BIP32Keystore(mnemonics: mnemonic)
//        print("mnemonic = \(mnemonic)")
//        print("address = \(String(describing: keystore?.addresses))")
//    }
 
}
