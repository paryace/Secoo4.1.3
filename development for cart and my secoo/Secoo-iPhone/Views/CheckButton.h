//
//  CheckButton.h
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-26.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum mobilePayType {
    DelivePayType = 1,          //货到付款
    BankPayType,                //银行汇款
    UnionPayType,               //银联支付
    WeChatPayType,              //微信支付
    AlixPayType                 //支付宝支付
}MobilePayType;

typedef enum deliverType {
    ExpressDeliverType = 1,     //快递送货
    ToShopDeliverType           //到店自提
}DeliverType;

typedef enum invoiceType {
    InvoiceTypeNo = 1,          //不要发票
    InvoiceTypePersonal,        //个人
    InvoiceTypeComponty         //公司
}InvoiceType;


@protocol CheckButtonDelegate;

@interface CheckButton : UIButton

@property (nonatomic, weak)           id<CheckButtonDelegate> delegate;
@property (nonatomic, copy, readonly)   NSString                *groupId;
@property (nonatomic, assign)           BOOL                    checked;

@property (nonatomic, assign)           MobilePayType           mobilePayType;
@property (nonatomic, assign)           DeliverType             deliverType;
@property (nonatomic, assign)           InvoiceType             invoiceType;

@property (nonatomic, assign)           int                     index;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end


@protocol CheckButtonDelegate <NSObject>

@optional
- (void)didSelectedRadioButton:(CheckButton *)radio groupId:(NSString *)groupId;
- (void)didSetCheckedOfCheckButton:(CheckButton *)checkButton checked:(BOOL)checked;

@end
