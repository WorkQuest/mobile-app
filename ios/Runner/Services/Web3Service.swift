import Foundation
import Flutter
import web3swift

class Web3Service {
    
    
    public func register(controller: FlutterViewController){
        
        let channel = FlutterMethodChannel(name: "web3Channel", binaryMessenger: controller as! FlutterBinaryMessenger)

        channel.setMethodCallHandler({
            [weak self](call: FlutterMethodCall, result: FlutterResult) -> Void in

            switch call.method {
            case "generateSeed":
                self?.generateSeed()
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }
    
    private func generateSeed() {
        let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 256)!
        print(mnemonic)
    }
    
}
