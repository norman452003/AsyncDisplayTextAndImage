//
//  DefineConstant.h
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#ifndef DefineConstant_h
#define DefineConstant_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define EmojiRegular @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
#define URLRegular @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?"
#define AccountRegular @"@[\u4e00-\u9fa5a-zA-Z0-9_-]{2,30}"
#define TopicRegular @"#[^#]+#"
#define kTextShouldRespondTap @"TextShouldRespondTap"
#define Min(A,B) ((A) < (B) ? (A) : (B))
#define imageW ((kScreenWidth - 60)/3)

#endif /* DefineConstant_h */
