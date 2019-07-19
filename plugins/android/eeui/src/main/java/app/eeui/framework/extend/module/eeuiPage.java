package app.eeui.framework.extend.module;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSONObject;
import com.taobao.weex.WXSDKInstance;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import app.eeui.framework.BuildConfig;
import app.eeui.framework.activity.PageActivity;
import app.eeui.framework.activity.PageActivityNoTransparent;
import app.eeui.framework.activity.PageActivityTransparent;
import app.eeui.framework.extend.bean.PageBean;
import app.eeui.framework.extend.integration.swipebacklayout.BGAKeyboardUtil;
import app.eeui.framework.extend.module.rxtools.tool.RxFileTool;

/**
 * Created by WDM on 2018/3/25.
 */

public class eeuiPage {

    private static final String TAG = "eeuiPage";

    private static Map<String, PageBean> mPageBean = new HashMap<>();

    private static Map<String, Long> openTime = new HashMap<>();

    public static Map<String, String> mAppboardContent = new HashMap<>();

    public static void setPageBean(String key, PageBean var) {
        mPageBean.put(key, var);
    }

    public static PageBean getPageBean(String key) {
        return mPageBean.get(key);
    }

    public static void removePageBean(String key) {
        if (key != null) {
            mPageBean.remove(key);
        }
    }

    /**
     * 打开页面
     * @param context
     * @param mBean
     */
    public static void openWin(Context context, PageBean mBean) {
        if (mBean == null) {
            return;
        }
        if (mBean.getPageName() == null) {
            mBean.setPageName("open_" + eeuiCommon.randomString(8));
        } else {
            if (System.currentTimeMillis() - eeuiParse.parseLong(openTime.get(mBean.getPageName())) < 1000) {
                return;
            }
            openTime.put(mBean.getPageName(), System.currentTimeMillis());
        }
        if (mPageBean.get(mBean.getPageName()) != null) {
            mBean.setPageName("open_" + mBean.getPageName() + "_" + eeuiCommon.randomString(6));
        }
        mPageBean.put(mBean.getPageName(), mBean);
        //
        if (mBean.getCallback() != null) {
            Map<String, Object> ret = new HashMap<>();
            ret.put("pageName", mBean.getPageName());
            ret.put("status", "ready");
            mBean.getCallback().invokeAndKeepAlive(ret);
        }
        //
        if (context instanceof PageActivity) {
            PageBean currentInfo = ((PageActivity) context).getPageInfo();
            if ("".equals(mBean.getStatusBarColor())) {
                mBean.setStatusBarColor(currentInfo.getStatusBarColor());
            }else if ("".equals(mBean.getBackgroundColor())) {
                mBean.setBackgroundColor(currentInfo.getBackgroundColor());
            }
        }
        if ("".equals(mBean.getStatusBarColor())) {
            mBean.setStatusBarColor("#3EB4FF");
        }else if ("".equals(mBean.getBackgroundColor())) {
            mBean.setBackgroundColor("#ffffff");
        }
        //
        Intent intent = new Intent();
        intent.setClass(context, mBean.isTranslucent() ? PageActivityTransparent.class : PageActivityNoTransparent.class);
        intent.putExtra("name", mBean.getPageName());
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
        //
        if (!mBean.isAnimated()) {
            ((Activity) context).overridePendingTransition(0, 0);
        }
    }

    /**
     * 获取页面详细参数
     * @param name
     * @return
     */
    public static PageBean getWinInfo(String name) {
        if (name == null) {
            return null;
        }
        PageBean mBean = getPageBean(name);
        if (mBean == null) {
            return null;
        }
        Activity activity = mBean.getActivity();
        if (activity == null) {
            return null;
        }
        if (activity instanceof PageActivity) {
            return ((PageActivity) activity).getPageInfo();
        }
        return null;
    }

    /**
     * 刷新页面
     * @param name
     */
    public static void reloadWin(String name) {
        if (name == null) {
            return;
        }
        PageBean mBean = getPageBean(name);
        if (mBean == null) {
            return;
        }
        Activity activity = mBean.getActivity();
        if (activity == null) {
            return;
        }
        if (activity instanceof PageActivity) {
            ((PageActivity) activity).reload();
        }
    }

    /**
     * 关闭页面按pageName
     * @param name
     */
    public static void closeWin(String name) {
        if (name == null) {
            return;
        }
        PageBean mBean = getPageBean(name);
        if (mBean == null) {
            return;
        }
        Activity activity = mBean.getActivity();
        if (activity == null) {
            return;
        }
        BGAKeyboardUtil.closeKeyboard(activity);
        activity.finish();
    }

    /**
     * 关闭页面按activity
     * @param activity
     */
    public static void closeActivity(Activity activity) {
        if (activity == null) {
            return;
        }
        if (activity instanceof PageActivity) {
            closeWin(((PageActivity) activity).getPageInfo().getPageName());
        }else{
            BGAKeyboardUtil.closeKeyboard(activity);
            activity.finish();
        }
    }

    /**
     * 获取页面名称
     * @param object
     * @return
     */
    public static String getPageName(String object) {
        JSONObject json = eeuiJson.parseObject(object);
        if (json.size() == 0) {
            json.put("pageName", object);
        }
        String pageName = json.getString("pageName");
        if (pageName == null) {
            pageName = "";
        }
        return pageName;
    }

    /**
     * 获取页面名称
     * @param activity
     * @return
     */
    public static String getPageName(Activity activity) {
        if (activity instanceof PageActivity) {
            return ((PageActivity) activity).getPageInfo().getPageName();
        }else{
            return null;
        }
    }

    /**
     * 规范化url
     * @param url
     * @return
     */
    public static String realUrl(String url) {
        return eeuiHtml.realUrl(url);
    }

    /**
     * 补全地址
     * @param context
     * @param url
     * @return
     */
    public static String rewriteUrl(Context context, String url) {
        return eeuiHtml.repairUrl(context, url);
    }

    /**
     * url添加js后缀
     * @param pageType
     * @param url
     * @return
     */
    public static String suffixUrl(String pageType, String url) {
        if (pageType.equals("app") || pageType.equals("weex")) {
            String[] array = url.split("/");
            String lastUrl = array.length > 0 ? array[array.length - 1] : url;
            if (!(url.startsWith("http://") || url.startsWith("https://") || url.startsWith("ftp://") || url.startsWith("file://"))
                && !lastUrl.contains(".")) {
                url = url + ".js";
            }
        }
        return url;
    }

    /**
     * 获取Appboard内容
     * @param context
     * @return
     */
    public static String getAppboardContent(Context context) {
        try {
            String[] files = context.getAssets().list("eeui/appboard");
            if (files != null) {
                for (String file : files) {
                    if (!TextUtils.isEmpty(file) && file.endsWith(".js")) {
                        if (!BuildConfig.DEBUG && (file.endsWith(".dev.js") || file.endsWith(".debug.js"))) {
                            continue;
                        }
                        String key = "appboard/" + file;
                        String temp = mAppboardContent.get(key);
                        if (temp == null) {
                            temp = eeuiBase.config.verifyAssets(context, "file://assets/eeui/appboard/" + file);
                            mAppboardContent.put(key, temp);
                        }
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        StringBuilder appboard = new StringBuilder();
        for (Map.Entry<String, String> entry : mAppboardContent.entrySet()) {
            if (!TextUtils.isEmpty(entry.getValue())) {
                appboard.append(entry.getValue());
                appboard.append(";");
            }
        }
        if (TextUtils.isEmpty(appboard)) {
            return "";
        }
        if (!appboard.toString().startsWith("// { \"framework\": \"Vue\"}")) {
            appboard.insert(0, "// { \"framework\": \"Vue\"}\nif(typeof app==\"undefined\"){app=weex}\n");
        }
        return appboard.toString();
    }

    /**
     * 缓存页面
     * @param context   上下文
     * @param url       缓存地址
     * @param cache     缓存时长，单位：毫秒
     * @param params    传递参数
     * @param mOnCachePageCallback
     */
    public static void cachePage(Context context, String url, long cache, Object params, OnCachePageCallback mOnCachePageCallback) {
        if (url == null || mOnCachePageCallback == null) {
            return;
        }
        if (url.startsWith("file://")) {
            cache = 0;
        }
        Map<String, Object> resParams = new HashMap<>();
        resParams.put(WXSDKInstance.BUNDLE_URL, url);
        resParams.put("params", params);
        //
        String appboard = eeuiPage.getAppboardContent(context);
        if (cache >= 1000 || !TextUtils.isEmpty(appboard)) {
            if (url.startsWith("file://")) {
                String tempUrl = saveCachePage(context, url, appboard + eeuiCommon.getAssetsFile(context, url));
                if (tempUrl == null) {
                    Log.d(TAG, "cachePage assetsError: " + url);
                    mOnCachePageCallback.success(resParams, url);
                }else{
                    Log.d(TAG, "cachePage assetsSuccess: " + url);
                    mOnCachePageCallback.success(resParams, tempUrl);
                }
            }else{
                Map<String, Object> data = new HashMap<>();
                data.put(WXSDKInstance.BUNDLE_URL, url);
                data.put("params", params);
                data.put("setting:cache", cache);
                data.put("setting:cacheLabel", "page");
                eeuiIhttp.get("eeuiPage", url, data, new eeuiIhttp.ResultCallback() {
                    @Override
                    public void success(String resData, boolean isCache) {
                        String tempUrl = saveCachePage(context, url, appboard + resData);
                        if (tempUrl == null) {
                            Log.d(TAG, "cachePage errors: " + url);
                            mOnCachePageCallback.success(resParams, url);
                        }else{
                            Log.d(TAG, "cachePage success: " + url);
                            mOnCachePageCallback.success(resParams, tempUrl);
                        }
                    }

                    @Override
                    public void error(String error) {
                        Log.d(TAG, "cachePage error: " + url);
                        mOnCachePageCallback.success(resParams, url);
                    }

                    @Override
                    public void complete() {

                    }
                });
            }
        }else{
            Log.d(TAG, "cachePage nocache: " + url);
            mOnCachePageCallback.success(resParams, url);
        }
    }

    /**
     * 保存缓存页面
     * @param context
     * @param url
     * @param string
     * @return
     */
    private static String saveCachePage(Context context, String url, String string) {
        String path = "/";
        try {
            URL tmp = new URL(url);
            int lastIndex = tmp.getPath().lastIndexOf("/");
            if (lastIndex > -1){
                path = tmp.getPath().substring(0, lastIndex);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        File tempPath = context.getExternalFilesDir("page_cache" + path);
        if (tempPath == null) {
            return null;
        }
        tempPath = new File(tempPath.getPath() + "/" + eeuiCommon.md5(url));
        if (!RxFileTool.writeFileFromString(tempPath, string, false)) {
            return null;
        }
        return "file://" + tempPath.getPath();
    }

    /**
     * 缓存页面相应函数
     */
    public interface OnCachePageCallback {
        void success(Map<String, Object> resParams, String newUrl);
    }
}
