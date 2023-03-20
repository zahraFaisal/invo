import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cryptography/cryptography.dart' as CryptographyPack;

class Decrypt {
  String iv;
  String value;
  Decrypt(this.iv, this.value);

  decryptData() {
    // try {
    //   if (value == null) {
    //     return '';
    //   }
    //   var hash = ConvertPack.base64Decode("ADAjz79+bRJw0xRM8h+FvVtsC3QpYENZyVi/xY2gAyY=");
    //   var iv = ConvertPack.base64Decode(this.iv);

    //   var cipherText = ConvertPack.base64Decode(value);

    //   // final algorithm = CryptographyPack.AesCbc.with128bits(
    //   //   macAlgorithm: CryptographyPack.Hmac.sha256(),
    //   // );
    //   // final secretKey = algorithm.se  CryptographyPack.SecretKey(hash);
    //   // final nonce = algorithm.no();

    //   // Decrypt
    //   var algorithm = CryptographyPack.AesCbc.with128bits(macAlgorithm: CryptographyPack.Hmac.sha256());
    //   final secretKey = algorithm.newSecretKeyFromBytes(hash);

    //   var plaintext = algorithm.decryptString(CryptographyPack.SecretBox(cipherText, nonce: algorithm.newNonce(), mac: Mac()), secretKey: CryptographyPack.SecretKey(hash));
    //   // algorithm.decrypt(cipherText, secretKey: hash);

    //   // var decrypted = CryptographyPack.AesCbc.decryptSync(cipherText, secretKey: CryptographyPack.SecretKey(hash), nonce: CryptographyPack.Nonce(iv));
    //   // var plaintext = ConvertPack.utf8.decode(decrypted);
    //   return plaintext;
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  void saveFile() async {
    File file = File(await getFilePath()); // 1
    file.writeAsString("${this.iv},${this.value}"); // 2
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/licence.txt'; // 3

    return filePath;
  }
}
