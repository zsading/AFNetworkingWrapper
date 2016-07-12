# AFNetworkingWrapper

基于AES和RSA加密方案AFNetworking封装层

###加密原理

由于RSA加解密速度慢，不适合大量数据文件加密，因此在网络中完全用公开密码体制传输机密信息是没有必要，也是不太现实的。<br>
加密速度很快，但是在网络传输过程中如何安全管理密钥是保证加密安全的重要环节。如果在传送机密信息的双方，使用对称密码体制对传输数据加密，同时使用不对称密码体制来传送的密钥，就可以综合发挥的优点同时避免它们缺点来实现一种新的数据加密方案。


###Schematic Diagram

![](https://github.com/zsading/AFNetworkingWrapper/blob/master/AFNetworkingWrapper/5066741493393_thumbs.jpg)


###Basic usage

####Use DJEncrypt solely

	//RSA
	[DJRSAEncrypt RSAEncrypotoTheData:TheStringYouWantToEncode RSAEncrypotoSpliter:@"#PART#"];
	//AES
	[DJAESEncrypt AES256EncryptWithKey:AESKey self:YourDataKey];
    [DJAESEncrypt AES256DecryptWithKey:AESKey self:YourDataKey];