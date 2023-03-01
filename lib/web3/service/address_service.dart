import 'dart:typed_data';
import 'package:bech32/bech32.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';


const _baseDerivationPath = "m/44'/60'/0'/0/0";

class AddressService {

  static String generateMnemonic() {
    try {
      return bip39.generateMnemonic(strength: 128);
    } catch (e) {
      throw Exception("Error generating mnemonic");
    }
  }

  static bool validateMnemonic(String mnemonic) {
    try {
      return bip39.validateMnemonic(mnemonic);
    } catch (e) {
      throw Exception("Error validate mnemonic");
    }
  }

  static String getPrivateKey(String mnemonic) {
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

  static Future<EthereumAddress> getPublicAddress(String privateKey) async {
    try {
      final private = EthPrivateKey.fromHex(privateKey);
      final address = await private.extractAddress();
      return address;
    } catch (e) {
      throw Exception("Error getting address");
    }
  }

  static String getPublicKey(String privateKey) {
    try {
      final private = EthPrivateKey.fromHex(privateKey);
      final public = HEX.encode(private.encodedPublicKey);
      return public;
    } catch (e) {
      throw Exception("Error getting public key");
    }
  }

  static String hexToBech32(String address) {
    try {
      final _address = EthereumAddress.fromHex(address);
      final _hex = HEX.decode(_address.hexNo0x);
      final _bech32 = Bech32Encoder.encode('wq', Uint8List.fromList(_hex));
      return _bech32;
    } catch (e) {
      return address;
    }
  }

  static String bech32ToHex(String addressBech32) {
    try {
      final bechToHex = Bech32Encoder.decode(addressBech32);
      final result = HEX.encode(bechToHex.toList());

      return '0x$result';
    } catch (e) {
      return addressBech32;
    }
  }

  static String convertToHexAddress(String address) {
    try {
      final _isBech = address.substring(0, 2).toLowerCase() == 'wq';
      return _isBech ? AddressService.bech32ToHex(address) : address;
    } catch (e) {
      return address;
    }
  }
}

class Bech32Encoder {
  /// Encodes the given data using the Bech32 encoding with the
  /// given human readable part
  static String encode(String humanReadablePart, Uint8List data) {
    final List<int> converted = _convertBits(data, 8, 5);
    const bech32Codec = Bech32Codec();
    final bech32Data = Bech32(humanReadablePart, converted as Uint8List);
    return bech32Codec.encode(bech32Data);
  }

  /// for bech32 coding
  static Uint8List _convertBits(
      List<int> data,
      int from,
      int to, {
        bool pad = true,
      }) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << to) - 1;

    for (var v in data) {
      if (v < 0 || (v >> from) != 0) {
        throw Exception();
      }
      acc = (acc << from) | v;
      bits += from;
      while (bits >= to) {
        bits -= to;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (to - bits)) & maxv);
      }
    } else if (bits >= from) {
      throw Exception('illegal zero padding');
    } else if (((acc << (to - bits)) & maxv) != 0) {
      throw Exception('non zero');
    }

    return Uint8List.fromList(result);
  }

  static Uint8List decode(String data) {
    const bech32Codec = Bech32Codec();
    final bech32Data = bech32Codec.decode(data);
    final list = _convertBits(bech32Data.data, 5, 8);
    return Uint8List.fromList(list);
  }
}
