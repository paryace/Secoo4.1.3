//
//  SecooInfoOriginViewController.m
//  Secoo-iPhone
//
//  Created by WuYikai on 14-9-15.
//  Copyright (c) 2014年 secoo. All rights reserved.
//

#import "SecooInfoOriginViewController.h"

@interface SecooInfoOriginViewController ()
@property(nonatomic, weak) UITextView *textView;
@end

@implementation SecooInfoOriginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width = -10;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToPreviousViewController:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpace, backBar];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView = textView;
    textView.editable = NO;
    
    
    switch (self.secooInfoName) {
        case SecooInfoOrigin:
            [self setTheContentsOfTextViewForOrigin];
            break;
        case SecooInfoHonor:
            [self setTheContentsOfTextViewForHonor];
            break;
        case SecooInfoShopstore:
            [self setTheContentsOfTextViewForShopstore];
            break;
        case SecooInfoClub:
            [self setTheContentsOfTextViewForClub];
            break;
        case SecooInfoAuthenticate:
            [self setTheContentsOfTextViewForAuthenticate];
            break;
        case SecooInfoConserve:
            [self setTheContentsOfTextViewForConserve];
            break;
        case SecooInfoSchool:
            [self setTheContentsOfTextViewForSchool];
            break;
            
        default:
            break;
    }
    [self.view addSubview:textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textView.frame = self.view.bounds;
    
    [MobClick beginLogPageView:@"SecooInfoOrigin"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SecooInfoOrigin"];
}

- (void)backToPreviousViewController:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置内容
- (void)setTheContentsOfTextViewForOrigin
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"寺库起源\n"];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:0 fontSize:14 bold:NO];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"1500多年前，《南史•甄法崇传》载，宋江陵令甄法崇孙甄彬，“尝以一束茔就州长沙寺质钱，后赎茔还，于茔中得五两金，以手巾裹之。彬得，送还寺库。”\n寺库，是今日寄卖、典当行业的鼻祖。\n"];
    [self setStyleWithAttribute:text headIndent:30 firstHeadIndent:30 fontSize:12 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"关于我们\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"寺库致力打造全球最大奢侈品交流平台。总部位于中国北京，高端库会所设于北京、上海、成都、香港、东京等繁华之都，并筹建全球最大奢侈品养护工厂。\n"];
    [self setStyleWithAttribute:text headIndent:30 firstHeadIndent:30 fontSize:12 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"寺库业务涉及：奢侈品鉴定、销售、养护及线下交流会所。\n"];
    [self setStyleWithAttribute:text headIndent:30 firstHeadIndent:30 fontSize:12 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"寺库文化\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"寺库本业——做109年以上的企业；\n品牌标准——正人、正品、正思；\n企业精神——诚信为先，让资源价值得到最大化利用；\n"];
    [self setStyleWithAttribute:text headIndent:30 firstHeadIndent:30 fontSize:12 bold:NO];
    [attribute appendAttributedString:text];
    
    self.textView.attributedText = attribute;
}

- (void)setTheContentsOfTextViewForHonor
{
    NSString *text = @"⊙寺库中国荣膺2012（第十二届）中国企业“未来之星”！（2012中国企业家杂志社评选\n⊙全国寄卖工作委员会会长单位《全国寄卖行业管理规范（审议草案）》起草单位\n⊙对外经贸大学奢侈品研究中心战略合作伙伴\n⊙2012年，与新浪奢品达成战略合作，成为新浪奢侈品指定奢侈品售后服务中心\n⊙2012年，成为中国315电子商务诚信平台官方指定唯一奢侈品鉴定评估中心\n⊙2011年，YOKA奢侈品商城官方奢侈品鉴定指定机构\n⊙2011年，与中国青少年发展基金会管理的大型公益慈善活动“爱心衣橱”结成战略合作伙伴，并与新浪、凡客、远东一起被选为四大荣誉理事单位。携百位明星参与，倾注对弱势群体的仁爱之心。\n⊙2011年时尚大典主赞助商、星光大典特别赞助商、凤凰网2011年会高级赞助商\n⊙搜房网高端市场活动战略合作伙伴\n⊙中国互联网络信息中心可信网站示范单位\n⊙“最受风险投资青睐的创业项目”称号（2010年国际人力资源协会等联合评选）\n⊙中国最具成长魅力企业30强（2009清华大学媒介调查实验室）\n⊙“中国企业未来之星”百强（2010中国企业家杂志社）\n⊙最受关注创新商业模式电商（《中国经营报》2011年中小企业高峰论坛）\n⊙保利拍卖奢侈品专场主要委托人\n⊙中国互联网络信息中心可信网站示范单位";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:0 fontSize:12 bold:NO];
    self.textView.attributedText = attribute;
}

- (void)setTheContentsOfTextViewForShopstore
{
    self.textView.text = @"";
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"官方网站www.secoo.com\n"];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"上万款一线品牌产品，潮流的款式，优异的价格！同事提供在线购买、在线寄卖服务。来自全球的奢侈品服务商，将最优秀的产品及服务汇集于此。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"手机网站m.secoo.com\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"最新上架的商品，第一时间查看，随时随地的购买。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"客户端\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"物流信息，第一时间推送；个性化首页，专属的高端服务；专业客服，支持语音咨询。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    self.textView.attributedText = attribute;
}

- (void)setTheContentsOfTextViewForClub
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"设立在全国一线城市顶级商业圈，开阔舒适的购物环境，别致的VIP包间，品鉴式服务，让您体验高端会所式服务模式\n"];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"1、SECOO（寺库）金宝街奢侈品库会所\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"地址：上海市静安区南京西路758号博爱大厦三楼\n电话：400-658-6659\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"3、SECOO（寺库）成都奢侈品库会所\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"地址：成都市人民南路111号航天科技大厦3层\n电话：400-658-6659\n028-62100285\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    self.textView.attributedText = attribute;
}

- (void)setTheContentsOfTextViewForAuthenticate
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"鉴定中心简介\n"];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"“对每一件奢侈品，我们都十足挑剔。”\n全国权威奢侈品鉴定评估机构，全国寄卖工作委员会授权单位，为您带来奢侈品鉴定评估技术的专业服务。鉴定评估物品范围包括奢侈品皮具、腕表、珠宝饰品等。SECOO奢侈品鉴定评估技术中心的每一项鉴定工艺，都遵循严苛的标准和严谨的服务流程，确保每一件寄卖商品为真品。\n中国315电子商务诚信平台官方指定唯一奢侈品鉴定评估中心。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"鉴定评估范围\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"SECOO奢侈品鉴定评估技术中心主要提供皮具、腕表、珠宝玉器、艺术品等物品的鉴定评估服务和相应技术交流活动。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"资质\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"全国寄卖工作委员会授权合作单位\n对外经济贸易大学奢侈品职业技能培训中心战略合作伙伴\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"贵宾专线：400-658-6659\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"地址：中国北京市东城区金宝街18-8号\n营业时间：早10：00--晚19：00（节假日不休）\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    self.textView.attributedText = attribute;
}

- (void)setTheContentsOfTextViewForConserve
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"售后服务中心养护工厂简介\n"];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"SECOO奢侈品售后服务养护工厂是与日本最大奢侈品腕表维修工厂五十君合作成立，位于中国北京，占地3000平米，是目前国内功能最全、规格最高、面积最大的高档箱包、腕表和宝石维修保养工厂，可为100多个品牌做全套基础及深度售后服务，其高、精、尖的技术达国际专业水准。实力强大的团队与领先的技术，是售后服务中心最具影响力的基础核心。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"团队阵容\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"由国内外各专业领域最具实力的专业高级技师组成，拥有人数超过23人，其中国家级高级工程师5人、奢侈品皮具养护高级技师6人、国际名表维修高级技师7人。售后服务中心设皮具养护事业部、名表维修事业部、宝石养护事业部三大事业部，采用国际专业售后精细分类处理方式，保障最高品质服务质量。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"创新传统技术、引进一流设备，在高级皮具、腕表、珠宝等售后服务方面的技术达国际一线水准。皮具奢护，独家采用专业测色、调色仪、蒸汽去污机、日本进口手动缝制工具等先进设备，解决深层清洁、喷色且保留原线等多种难度大的问题，达到“还原性”养护效果；名表维修事业部，采用进口专业精密仪器，潜水表测试仪、防磁实验仪、防震实验仪、pc500较钟仪等进口设备，无尘维修车间。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"完美来源于专业，感动来源于真诚！SECOO奢侈品售后服务中心以专业的技艺、真诚的服务为您珍爱的每一件皮具、每一块腕表、每一枚钻饰提供专业化、精细化、个性化养护等一站式服务。\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"荣誉\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:14 bold:YES];
    [attribute appendAttributedString:text];
    
    text = [[NSMutableAttributedString alloc] initWithString:@"中国钟表协会会员单位\n中国皮革协会会员\n北京洗染行业协会会员单位\nRCLUX-SECOO奢侈品职业技能培训中心合作单位\n"];
    [self setStyleWithAttribute:text headIndent:0 firstHeadIndent:0 fontSize:13 bold:NO];
    [attribute appendAttributedString:text];

    self.textView.attributedText = attribute;
}

- (void)setTheContentsOfTextViewForSchool
{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"师资力量雄厚，由国内奢侈品领域权威性大学教授、行业专家、奢侈品品牌高管等担任。课程涉及奢侈品文化管理、鉴定、营销等方面"];
    [self setStyleWithAttribute:attribute headIndent:0 firstHeadIndent:30 fontSize:13 bold:NO];
    self.textView.attributedText = attribute;
}

- (void)setStyleWithAttribute:(NSMutableAttributedString *)text headIndent:(CGFloat)headIndent firstHeadIndent:(CGFloat)firstHeadIndent fontSize:(CGFloat)size bold:(BOOL)bold
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    style.headIndent = headIndent;
    style.firstLineHeadIndent = firstHeadIndent;
    UIFont *font = nil;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:size];
    } else {
        font = [UIFont systemFontOfSize:size];
    }
    [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
