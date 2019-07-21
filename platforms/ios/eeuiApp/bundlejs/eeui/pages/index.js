// { "framework": "Vue"} 
if(typeof app=="undefined"){app=weex}
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 4);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */,
/* 1 */,
/* 2 */,
/* 3 */,
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(5)
)

/* script */
__vue_exports__ = __webpack_require__(6)

/* template */
var __vue_template__ = __webpack_require__(7)
__vue_options__ = __vue_exports__ = __vue_exports__ || {}
if (
  typeof __vue_exports__.default === "object" ||
  typeof __vue_exports__.default === "function"
) {
if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
__vue_options__ = __vue_exports__ = __vue_exports__.default
}
if (typeof __vue_options__ === "function") {
  __vue_options__ = __vue_options__.options
}
__vue_options__.__file = "D:\\study\\eeui.app\\src\\pages\\index.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-6be49aa4"
__vue_options__.style = __vue_options__.style || {}
__vue_styles__.forEach(function (module) {
  for (var name in module) {
    __vue_options__.style[name] = module[name]
  }
})
if (typeof __register_static_styles__ === "function") {
  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
}

module.exports = __vue_exports__
module.exports.el = 'true'
new Vue(module.exports)


/***/ }),
/* 5 */
/***/ (function(module, exports) {

module.exports = {
  "app": {
    "flex": 1
  },
  "navbar": {
    "width": "750",
    "height": "100"
  },
  "bg": {
    "backgroundColor": "#ff0000"
  },
  "navbar-main": {
    "flexDirection": "row",
    "alignItems": "center"
  },
  "navbar-logo": {
    "width": "36",
    "height": "36",
    "marginRight": "18"
  },
  "navbar-title": {
    "fontSize": "32",
    "color": "#ffffff"
  },
  "navbar-icon": {
    "width": "100",
    "height": "100",
    "color": "#ffffff"
  },
  "list": {
    "width": "750",
    "flex": 1
  },
  "list-title-box": {
    "flexDirection": "row",
    "alignItems": "center",
    "backgroundColor": "#ffffff"
  },
  "list-title": {
    "flex": 1,
    "paddingTop": "32",
    "paddingRight": "24",
    "paddingBottom": "32",
    "paddingLeft": "24",
    "fontSize": "28",
    "color": "#757575",
    "backgroundColor": "#ffffff"
  },
  "list-subtitle": {
    "paddingRight": "24",
    "fontSize": "24"
  },
  "list-item": {
    "flexDirection": "row",
    "alignItems": "center",
    "justifyContent": "space-between",
    "height": "100",
    "width": "750",
    "paddingLeft": "20",
    "paddingRight": "20",
    "borderTopWidth": "1",
    "borderTopColor": "#e8e8e8",
    "borderTopStyle": "solid"
  },
  "list-item-left": {
    "flexDirection": "row",
    "alignItems": "center",
    "justifyContent": "flex-start",
    "height": "100",
    "flex": 1
  },
  "list-left-icon": {
    "width": "60",
    "height": "60",
    "color": "#3EB4FF"
  },
  "list-left-title": {
    "color": "#242424",
    "paddingLeft": "12",
    "width": "380",
    "fontSize": "26",
    "textOverflow": "ellipsis",
    "lines": 1
  },
  "list-left-title-history": {
    "color": "#666666",
    "paddingLeft": "12",
    "width": "660",
    "fontSize": "26",
    "textOverflow": "ellipsis",
    "lines": 2
  },
  "list-right-title": {
    "color": "#a2a2a2",
    "paddingRight": "3",
    "fontSize": "22",
    "textOverflow": "ellipsis",
    "lines": 1
  },
  "list-right-icon": {
    "fontSize": "24",
    "width": "40",
    "height": "40",
    "color": "#C9C9CE",
    "content": "'tb-right'"
  },
  "list-item-right": {
    "flexDirection": "row",
    "alignItems": "center",
    "justifyContent": "flex-end",
    "height": "100"
  }
}

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

var eeui = app.requireModule('eeui');

exports.default = {
    data: function data() {
        return {
            components: [],
            uis: [],
            module: [],
            plugin: [],
            abouts: [],
            history: []
        };
    },
    created: function created() {
        this.components = [{
            title: '轮播控件',
            title_en: 'banner',
            icon: 'md-easel',
            url: this.resourceUrl + 'component_banner.js'
        }, {
            title: '常用按钮',
            title_en: 'button',
            icon: 'logo-youtube',
            url: this.resourceUrl + 'component_button.js'
        }, {
            title: '网格容器',
            title_en: 'grid',
            icon: 'md-grid',
            url: this.resourceUrl + 'component_grid.js'
        }, {
            title: '字体图标',
            title_en: 'icon',
            icon: 'logo-ionic',
            url: this.resourceUrl + 'component_icon.js'
        }, {
            title: '跑马文字',
            title_en: 'marquee',
            icon: 'md-code-working',
            url: this.resourceUrl + 'component_marquee.js'
        }, {
            title: '导航栏',
            title_en: 'navbar',
            icon: 'md-menu',
            url: this.resourceUrl + 'component_navbar.js'
        }, {
            title: '列表容器',
            title_en: 'scroll-view',
            icon: 'md-list',
            url: this.resourceUrl + 'component_list.js'
        }, {
            title: '滚动文字',
            title_en: 'scroll-text',
            icon: 'ios-more',
            url: this.resourceUrl + 'component_scroll_text.js'
        }, {
            title: '侧边栏',
            title_en: 'side-panel',
            icon: 'md-albums',
            url: this.resourceUrl + 'component_side_panel.js'
        }, {
            title: '标签页面',
            title_en: 'tabbar',
            icon: 'md-filing',
            url: this.resourceUrl + 'component_tabbar.js'
        }];
        this.uis = [{
            title: 'Echarts图表',
            title_en: 'w-echarts',
            icon: 'md-trending-up',
            url: this.resourceUrl + 'ui_echarts.js'
        }, {
            title: 'Switch开关',
            title_en: 'w-switch',
            icon: 'md-switch',
            url: this.resourceUrl + 'ui_switch.js'
        }];
        this.module = [{
            title: '页面功能',
            title_en: 'newPage',
            icon: 'md-book',
            url: this.resourceUrl + 'module_page.js'
        }, {
            title: '系统信息',
            title_en: 'system',
            icon: 'ios-cog',
            url: this.resourceUrl + 'module_system.js'
        }, {
            title: '数据缓存',
            title_en: 'caches',
            icon: 'md-beaker',
            url: this.resourceUrl + 'module_caches.js'
        }, {
            title: '确认对话框',
            title_en: 'alert',
            icon: 'md-alert',
            url: this.resourceUrl + 'module_alert.js'
        }, {
            title: '等待弹窗',
            title_en: 'loading',
            icon: 'tb-loading',
            url: this.resourceUrl + 'module_loading.js'
        }, {
            title: '验证弹窗',
            title_en: 'captcha',
            icon: 'md-checkmark-circle',
            url: this.resourceUrl + 'module_captcha.js'
        }, {
            title: '二维码扫描',
            title_en: 'scaner',
            icon: 'tb-scan',
            url: this.resourceUrl + 'module_scaner.js'
        }, {
            title: '跨域异步请求',
            title_en: 'ajax',
            icon: 'md-git-pull-request',
            url: this.resourceUrl + 'module_ajax.js'
        }, {
            title: '剪切板',
            title_en: 'clipboard',
            icon: 'md-copy',
            url: this.resourceUrl + 'module_plate.js'
        }, {
            title: '提示消息',
            title_en: 'toast',
            icon: 'md-notifications',
            url: this.resourceUrl + 'module_toast.js'
        }, {
            title: '广告弹窗',
            title_en: 'adDialog',
            icon: 'logo-buffer',
            url: this.resourceUrl + 'module_ad_dialog.js'
        }];
        this.plugin = [{
            title: '城市选择器',
            title_en: 'citypicker',
            icon: 'md-pin',
            url: this.resourceUrl + 'plugin_citypicker.js'
        }, {
            title: '图片选择器',
            title_en: 'picture',
            icon: 'md-camera',
            url: this.resourceUrl + 'plugin_picture.js'
        }, {
            title: '组件截图',
            title_en: 'screenshots',
            icon: 'md-crop',
            url: this.resourceUrl + 'plugin_screenshots.js'
        }, {
            title: '融云通信模块',
            title_en: 'rongim',
            icon: 'tb-community',
            url: this.resourceUrl + 'plugin_rongim.js'
        }, {
            title: '友盟推送模块',
            title_en: 'umeng',
            icon: 'md-send',
            url: this.resourceUrl + 'plugin_umeng.js'
        }, {
            title: '第三方支付(微信/支付宝)',
            title_en: 'pay',
            icon: 'tb-sponsor',
            url: this.resourceUrl + 'plugin_pay.js'
        }, {
            title: '即时通讯',
            title_en: 'websocket',
            icon: 'md-repeat',
            url: this.resourceUrl + 'plugin_websocket.js'
        }];
        this.abouts = [{
            title: '开发文档',
            title_en: 'document',
            icon: 'md-code-working',
            url: 'https://eeui.app'
        }, {
            title: '托管平台',
            title_en: 'github',
            icon: 'logo-github',
            url: 'https://github.com/kuaifan/eeui'
        }, {
            title: '个人博客',
            title_en: 'http://kuaifan.vip',
            icon: 'logo-rss',
            url: 'http://kuaifan.vip'
        }, {
            title: 'EEUI版本',
            title_en: eeui.getVersionName(),
            icon: 'md-information-circle',
            url: 'https://eeui.app'
        }];
        this.history = this.jsonParse(eeui.getCachesString("scaner", []), []);
        //
        eeui.setPageBackPressed(null, function () {
            eeui.confirm({
                title: "温馨提示",
                message: "你确定要退出eeui.app吗？",
                buttons: ["取消", "确定"]
            }, function (result) {
                if (result.status === "click" && result.title === "确定") {
                    eeui.closePage(null);
                }
            });
        });
    },


    methods: {
        scaner: function scaner() {
            var _this = this;

            eeui.openScaner(null, function (res) {
                if (res.status === "success") {
                    _this.history.unshift(res.text);
                    eeui.setCachesString("scaner", _this.jsonStringify(_this.history), 0);
                    _this.openAuto(res.text);
                }
            });
        },
        refresh: function refresh() {
            eeui.reloadPage();
        },
        clearHistory: function clearHistory() {
            var _this2 = this;

            eeui.confirm({
                title: "删除提示",
                message: "你确定要删除扫码记录吗？",
                buttons: ["取消", "确定"]
            }, function (result) {
                if (result.status === "click" && result.title === "确定") {
                    _this2.history = [];
                    eeui.setCachesString("scaner", _this2.jsonStringify(_this2.history), 0);
                }
            });
        },
        openUrl: function openUrl(url) {
            eeui.openPage({
                url: url,
                pageType: 'app'
            });
        },
        openWeb: function openWeb(url) {
            this.openViewUrl(url);
        },
        openAuto: function openAuto(url) {
            eeui.openPage({
                url: url,
                pageType: 'auto'
            });
        }
    }
};

/***/ }),
/* 7 */
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: ["app"]
  }, [_c('navbar', {
    staticClass: ["navbar"]
  }, [_c('navbar-item', {
    attrs: {
      "type": "title"
    }
  }, [_c('div', {
    staticClass: ["navbar-main"]
  }, [_c('text', {
    staticClass: ["navbar-title"]
  }, [_vm._v("我的第一个app")])])])], 1), _c('scroll-view', {
    staticClass: ["list"]
  }, [_c('div', {
    staticClass: ["bg"]
  }, [_c('image', {
    staticStyle: {
      height: "400",
      marginLeft: "20"
    },
    attrs: {
      "src": "./logo-white.png"
    }
  })])])], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ })
/******/ ]);