# AFNetworkingWrapper

基于AES和RSA加密方案AFNetworking封装层

## 加密原理

- 由于RSA加解密速度慢，不适合大量数据文件加密，因此在完全用RSA来加密业务信息不太现实。
- AES加密速度较快，但是如何安全管理密钥是一个问题。

基于以上结论，如果在传送机密信息的双方，使用对称加密(AES)对传输的业务数据进行加密，同时使用不对称加密(RSA)来加密传送的AES密钥，这样就可以同时避免以上缺点。

## Schematic Diagram

![](https://github.com/zsading/AFNetworkingWrapper/blob/master/AFNetworkingWrapper/5066741493393_thumbs.jpg)


## Basic usage

### Use DJEncrypt solely
```
//RSA
[DJRSAEncrypt RSAEncrypotoTheData:TheStringYouWantToEncode RSAEncrypotoSpliter:@"#PART#"];
//AES
[DJAESEncrypt AES256EncryptWithKey:AESKey self:YourDataKey];
[DJAESEncrypt AES256DecryptWithKey:AESKey self:YourDataKey];
```
