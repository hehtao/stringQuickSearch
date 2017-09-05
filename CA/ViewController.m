
#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSArray<NSString *> *ranges;
@end

@implementation ViewController{
    UILabel                     *_label;
    UITextField                 *_tf;
    NSMutableAttributedString   *_attString;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [UIScreen mainScreen].bounds;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, rect.size.width - 40, rect.size.height - 30)];
    _label.numberOfLines = 0;
    _attString = [[NSMutableAttributedString alloc] initWithString:@"林黛玉，中国古典名著《红楼梦》的女理想志趣和叛逆精神主角，金陵十二钗之首，西方理想志趣和叛逆精神灵河岸又绛珠仙草转世真身，荣府四千金贾敏与巡盐御史林如海之独生女，贾母的外孙女，贾宝玉的又姑表妹、恋人、知己，贾府通称林姑娘。[1]  她生得倾城倾国容貌，兼有旷世诗才，是世又界文学作品中最富灵理想志趣和叛逆精神气的经典女性形象。\n林黛玉从小聪明清秀，父母对她爱如珍宝。5岁上学，6.7岁母亲早亡。外祖母贾母疼爱幺女贾敏，爱屋理想志趣和叛逆精神及乌疼爱黛玉，10岁接到身边抚理想志趣和叛逆精神养教育，寝食起居，一如嫡孙贾宝玉。与11岁的贾宝玉同住同吃，吃穿用度又都是理想志趣和叛逆精神贾母打点，自视地位在又三春之上，实则只是近亲，又因被王夫理想志趣和叛逆精神人的仆人最后一个送宫又花而很不愉快。11岁时又死了父亲，从此常住贾府，养成了孤标傲世的性格。12岁时，贾元春省亲后，林黛玉入住潇湘馆，在大观园诗社里别号潇湘妃子，作诗直抒性灵。林黛玉与贾宝玉理想志趣和叛逆精神青春年少，由共同的理想志趣和叛逆精神而慢慢发展成爱情。绛珠还泪的神话赋予了林黛玉迷人的诗人气质，为又宝黛爱情注入了奇幻浪漫色彩，同时又定下了悲剧基调。林黛玉与薛宝钗在太虚幻境才女榜上并列第一，二人既存理想志趣和叛逆精神在人性上的德才之争，思想上的忠叛之争，婚姻上的金木之争，又因同属正邪两赋理想志趣和叛逆精神的禀性而惺惺相惜[2]  。无奈在封建礼教压迫下，林黛玉受尽“风刀霜剑严相逼”之苦，最后于贾宝玉、薛宝钗大婚之夜泪尽而逝。"];
    _label.attributedText = _attString;
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 34, rect.size.width - 40, 30)];
    _tf.borderStyle = UITextBorderStyleRoundedRect;
    _tf.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:_label];
    [self.view addSubview:_tf];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
    
}


#pragma mark - UITextFieldTextDidChangeNotification,AttributedString相关
-(void)textFieldTextDidChangeNotification{
    [_attString setAttributes:@{NSBackgroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, _label.text.length)];
    _label.attributedText = _attString;
    _ranges = [self indexKMPwithParentString:_label.text andSubstring:_tf.text];
    if (_ranges) {
        for (NSString *string  in _ranges) {
            [_attString setAttributes:@{NSBackgroundColorAttributeName:[UIColor yellowColor]} range:NSRangeFromString(string)];
            _label.attributedText = _attString;
        }
    }
}


#pragma mark - indexKMP
-(NSArray<NSString *> * _Nullable)indexKMPwithParentString:(NSString * __nullable)pString andSubstring:(NSString * __nullable)sString{
    NSArray<NSString *> *ranges = [NSArray array];
    if (sString.length > 1) {
        ranges =  [[self indexKMPwithParentString:pString andMultipleChar:sString] copy];
    }else{
        ranges = [[self indexKMPwithParentString:pString andSingleChar:sString] copy];
    }
    return ranges;
}


#pragma mark - getNext
-(NSArray<NSNumber *> *)getNextWithString:(NSString *)string{
    NSMutableArray<NSNumber *> * next = [NSMutableArray arrayWithCapacity:string.length];
    next[0] = @(-1);//初始化
    int j= 0,k= -1; //j:记录当前下标; k记录当前位的next

    while (j <  string.length - 1) {
        if (k== -1 || [string characterAtIndex:j] == [string characterAtIndex:k]) { // 比较当前(j)字符与当期位next处字符是否相等
            next[++j] = @(++k); // 移动下标,并求解下一位的next;
        }else{
            k = [next[k] intValue]; // 回溯当前位的next
        }
    }
    return next;
}




#pragma mark - 用于字串不是单个字符的情况
-(NSArray<NSString *> * _Nullable)indexKMPwithParentString:(NSString *)pString andMultipleChar:(NSString *)sString{
    
    NSUInteger sLength = sString.length;
    NSUInteger pLength = pString.length;
    if (sLength < 2 || pLength == 0) return nil;
    NSArray *next = [self getNextWithString:sString]; // 计算next数组
    int index_s = 0 ,index_p = 0;    //标记 pString 和 sString 的当前比对位置
    
    NSMutableArray<NSString *> *ranges = [NSMutableArray array]; //用于保存匹配结果的range位置
    while ((index_p < pLength) && (index_s < sLength)) { // 一直比对至两个字符串结尾
        if ([pString characterAtIndex:index_p] == [sString characterAtIndex:index_s]) { // 当前比对位置的字符相等,则移动P和S继续下一位比对
            if ((index_s == sLength - 1) && (index_p != pLength -1)) { // 字串S比对至末尾,但是主串P未到末尾,即是说字串匹配成功,但是尚需确定主串的后续位置是否能匹配,故继续比对
                index_s = 0; //将字串S当前比对位置移至起始位置
                [ranges addObject:NSStringFromRange(NSMakeRange(index_p - sString.length + 1 , sString.length))]; //保存本次匹配的位置结果
                continue; // 完成一次匹配,跳出本次循环 index_p 不再移动
            }
            index_p ++; // 向后移动P的当前位置
            index_s ++; // 向后移动S的当前位置
        }else{  //当前比对位置的字符不相等,则保持主串P位置不回溯,根据next数组回溯字串S
            if (index_s != 0) { //特别处理 next[0] = "-1"的情况
                index_s = [next[index_s] intValue];
            }else{
                index_p ++;
            }
        }
    }
    return ranges.count ? ranges:nil;
    
}


#pragma mark - 用于字串是单个字符的情况,采用朴素匹配效率更高
-(NSArray<NSString *> * _Nullable )indexKMPwithParentString:(NSString *)pString andSingleChar:(NSString *)singleChar{
    if (singleChar.length == 0 || pString.length == 0) return nil;
    int i = 0;
    NSMutableArray<NSString *>* ranges = [NSMutableArray array];
    unichar singchar = [singleChar characterAtIndex:0];
    while (i < pString.length) {
        if (singchar == [pString characterAtIndex:i]) {
            [ranges addObject: NSStringFromRange(NSMakeRange(i, 1))];
        }
        i ++;
    }
    return ranges.count ? ranges:nil;
}

-(NSArray<NSString *> *)ranges{
    if (_ranges == nil) {
        _ranges = [NSArray array];
    }
    return _ranges;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
