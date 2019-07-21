/**
 * 配置文件
 * 参数详细说明：https://eeui.app/guide/config.html
 */
module.exports = {
    "homePage": "",                                            //主页的JS地址（可选）
    "homePageParams": {},                                      //主页其他参数（可选）
    "appKey": "HV5Fe4OkLdXHHw8kHNclnM8DstoV3HUS",              //用于云平台管理（可选）
    "wxpay": {
        "appid": "wx76cd9902f7e09bf3"                          //微信支付appid（可选）
    },
    "rongim": {                                                //融云模块配置（可选）
        "ios": {
            "enabled": true,
            "appKey": "vnroth0kv8o7o",
            "appSecret": "5mILjdXtXid7iM"
        },
        "android": {
            "enabled": true,
            "appKey": "vnroth0kv8o7o",
            "appSecret": "5mILjdXtXid7iM"
        }
    },
    "umeng": {                                                //友盟模块配置（可选）
        "ios": {
            "enabled": true,
            "appKey": "5cfa398c3fc1959f7b000e9b",
            "channel": "eeuidemo"
        },
        "android": {
            "enabled": true,
            "appKey": "5cfa3958570df3a0e8001015",
            "messageSecret": "49d0bac141dc8dc6df35d210a9c79289",
            "channel": "eeuidemo"
        }
    }
};