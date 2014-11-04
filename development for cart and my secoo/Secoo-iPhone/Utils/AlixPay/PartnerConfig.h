//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088801766902304"
//收款支付宝账号
#define SellerID  @"shuzhi_zsz@126.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"108uc1azfkiqjz6efpmbhfp03gesynqr"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIbh7mAv9OUfxZ8gszoblgWLP8FUCiwIM55QUCjFfdyU3/M5z/1Ad8SwgRTZ8Y8Vpi1iWYul6fon3B5FwL+3xYevxE2wMX9/FUQ43ii7msA9vqjawsscGn6bGdh1ai8KuyMMtbD6WCstc6eOpEIcWebp5PQT0Wi4fP8zAiea4lg5AgMBAAECgYEAg/qCAsAqAh/KgN/APzVK3/XW1lZi9Z6400mGhb5oXvOVBislZoo0JtMGGt7+S6FFTtcTA1++x7VE3qIl7fHlZmla0ur7g2DsRZ/wvvLasmgszfnWDT083yz6aVAN1b3uhsTz79HL+nnkZVSNh7COQI6rR9D7b6ScSpQWiVhsNgECQQC8GV41QoroEW0yMnMFncv9lmFDoeq+o1pTPGLx6ph+IfKQek++oEQhaOIYvouIkFgliQXMEcKE0QQwdp+qZVVZAkEAt5K1x1E7hUBZwoPz2J4KOEm5prawbij7YLrScucIgoFUXmRR89IbGNp2KCivMxDkjfBbS+1pogXWvmswXzld4QJAPniWZ03wYF7ZS2Ch/u2HgHNfXlz6X9JU/2wA2KO3fby8mOtmbMNBnW7+GIXARdzayayWdk43snDQ2V+sa6U4EQJAP7OjbNUdiHH6M+vCNIszFLFQwS9oLfH+uWRbHxBY/aCPfGnnnmpsiMVWdz0W/ut/xFmB9Okf3N+V02Iy2Ph5QQJAW5t+oM1CnFQaA3qjor9iC3SX999tGBeXF3DvHmd6tZZp8PnUhkHhnClHgAivLnEUz4lmTat7FY9GJQnMoo7Trg=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
