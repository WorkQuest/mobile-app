import 'dart:typed_data';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';


const _baseDerivationPath = "m/44'/60'/0'/0/0";

class AddressService {

  static final AddressService _instance = AddressService._internal();

  factory AddressService() => _instance;

  AddressService._internal();

  String generateMnemonic() {
    try {
      return bip39.generateMnemonic(strength: 128);
    } catch (e) {
      throw Exception("Error generating mnemonic");
    }
  }

  bool validateMnemonic(String mnemonic) {
    try {
      return bip39.validateMnemonic(mnemonic);
    } catch (e) {
      throw Exception("Error validate mnemonic");
    }
  }

  String getPrivateKey(String mnemonic) {
    try {
      final seed = bip39.mnemonicToSeedHex(mnemonic);

      final bip32.BIP32 root = bip32.BIP32.fromSeed(
        Uint8List.fromList(
          HEX.decode(seed),
        ),
      );
      final bip32.BIP32 child = root.derivePath(_baseDerivationPath);

      final privateKey = HEX.encode(child.privateKey!.toList());

      return privateKey;
    } catch (e) {
      throw Exception("Error getting private key");
    }
  }

  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    try {
      final private = EthPrivateKey.fromHex(privateKey);
      final address = await private.extractAddress();
      return address;
    } catch (e) {
      throw Exception("Error getting address");
    }
  }

  String getPublicKey(String privateKey) {
    try {
      final private = EthPrivateKey.fromHex(privateKey);
      final public = HEX.encode(private.encodedPublicKey);
      return public;
    } catch (e) {
      throw Exception("Error getting public key");
    }
  }
}
