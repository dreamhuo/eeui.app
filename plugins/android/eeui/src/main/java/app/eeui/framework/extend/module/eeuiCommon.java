package app.eeui.framework.extend.module;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ListAdapter;
import android.widget.ListView;

import com.alibaba.fastjson.JSONObject;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.ui.action.BasicComponentData;
import com.taobao.weex.utils.WXFileUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.CountDownLatch;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import app.eeui.framework.extend.integration.glide.Glide;
import app.eeui.framework.extend.integration.glide.load.engine.DiskCacheStrategy;
import app.eeui.framework.extend.integration.glide.request.RequestOptions;
import app.eeui.framework.extend.integration.glide.request.target.SimpleTarget;
import app.eeui.framework.extend.integration.glide.request.transition.Transition;
import app.eeui.framework.extend.integration.xutils.common.util.FileUtil;
import app.eeui.framework.extend.integration.xutils.x;
import app.eeui.framework.extend.interfaces.OnStringListener;
import app.eeui.framework.extend.module.rxtools.tool.RxEncryptTool;
import app.eeui.framework.extend.module.utilcode.util.PermissionUtils;
import app.eeui.framework.ui.eeui;

public class eeuiCommon {

    private static Map<String, Object> variate = new HashMap<>();

    /**
     * 保存缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @param data
     * @return
     */
    public static JSONObject setCaches(Context context, String index, String key, String data) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(index, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(key, data);
        editor.apply();
        return eeuiJson.parseObject(data);
    }

    /**
     * 获取缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @return
     */
    public static JSONObject getCaches(Context context, String index, String key) {
        try {
            SharedPreferences sharedPreferences = context.getSharedPreferences(index, Context.MODE_PRIVATE);
            String data = sharedPreferences.getString(key, "");
            return eeuiJson.parseObject(data);
        }catch (NullPointerException e) {
            return eeuiJson.parseObject(null);
        }
    }

    /**
     * 保存缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @param data
     * @return
     */
    public static String setCachesString(Context context, String index, String key, String data) {
        return setCachesString(context, index, key, data, 0);
    }

    /**
     * 删除缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @return
     */
    public static String removeCachesString(Context context, String index, String key) {
        return setCachesString(context, index, key, "", 0);
    }

    /**
     * 保存缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @param data
     * @return
     */
    public static String setCachesString(Context context, String index, String key, String data, long expired) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(index, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(key, data);
        editor.putLong(key + "::expired", expired > 0 ? (expired + timeStamp()) : expired);
        editor.apply();
        return data;
    }

    /**
     * 获取缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @return
     */
    public static String getCachesString(Context context, String index, String key, String defaultVal) {
        try {
            SharedPreferences sharedPreferences = context.getSharedPreferences(index, Context.MODE_PRIVATE);
            long expired = sharedPreferences.getLong(key + "::expired", 0);
            if (expired > 0 && expired < timeStamp()) {
                return defaultVal;
            }
            return sharedPreferences.getString(key, defaultVal);
        }catch (NullPointerException e) {
            return defaultVal;
        }
    }

    /**
     * 获取缓存信息
     *
     * @param context
     * @param index
     * @param key
     * @return
     */
    public static String getCachesString(Context context, String index, String key) {
        return getCachesString(context, index, key, "");
    }

    /**
     * 设置全局变量
     *
     * @param key
     * @param val
     */
    public static void setVariate(String key, Object val) {
        variate.put(key, val);
    }

    /**
     * 获取全局变量
     *
     * @param key
     * @return
     */
    public static Object getVariate(String key) {
        try {
            return variate.get(key);
        } catch (Exception e) {
            return null;
        }
    }

    public static String getVariateStr(String key) {
        return eeuiParse.parseStr(getVariate(key), "");
    }

    public static String getVariateStr(String key, String defaultVal) {
        return eeuiParse.parseStr(getVariate(key), defaultVal);
    }

    public static int getVariateInt(String key) {
        return eeuiParse.parseInt(getVariate(key), 0);
    }

    public static long getVariateLong(String key) {
        return eeuiParse.parseLong(getVariate(key), 0);
    }

    /**
     * 时间戳转换成日期格式字符串
     *
     * @param seconds 精确到秒的字符串
     * @param format
     * @return
     */
    @SuppressLint("SimpleDateFormat")
    public static String formatDate(String seconds, String format) {
        if (seconds == null || seconds.isEmpty() || seconds.equals("null")) {
            return "";
        }
        if (format == null || format.isEmpty()) {
            format = "yyyy-MM-dd HH:mm:ss";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(new Date(Long.valueOf(seconds + "000")));
    }

    /**
     * 时间戳获取年月日（如果是今年只返回月日）
     * @param seconds
     * @return
     */
    public static String yyyyMMddMini(String seconds) {
        String yyyy = eeuiCommon.formatDate(seconds, "yyyy");
        String MMdd = eeuiCommon.formatDate(seconds, "MM-dd");
        if (yyyy.equals(eeuiCommon.formatDate(String.valueOf(eeuiCommon.timeStamp()), "yyyy"))) {
            return MMdd;
        }else{
            return yyyy + "-" + MMdd;
        }
    }

    /**
     * 日期格式字符串转换成时间戳
     *
     * @param date_str 字符串日期
     * @param format   如：yyyy-MM-dd HH:mm:ss
     * @return
     */
    @SuppressLint("SimpleDateFormat")
    public static String formatTimeStamp(String date_str, String format) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            return String.valueOf(sdf.parse(date_str).getTime() / 1000);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 取得当前时间戳（精确到秒）
     *
     * @return
     */
    public static long timeStamp() {
        long time = System.currentTimeMillis();
        return time / 1000;
    }

    /**
     * 取今天最后一秒的时间戳
     * @return
     */
    public static long getTodayEndTime() {
        Calendar todayEnd = Calendar.getInstance();
        todayEnd.set(Calendar.HOUR_OF_DAY, 23);
        todayEnd.set(Calendar.MINUTE, 59);
        todayEnd.set(Calendar.SECOND, 59);
        todayEnd.set(Calendar.MILLISECOND, 999);
        return todayEnd.getTime().getTime() / 1000;
    }

    /**
     * 字符串是否数字
     */
    public static boolean isNumeric(String str) {
        if (str == null || str.trim().isEmpty()) {
            return false;
        }
        Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        return isNum.matches();
    }

    /**
     * 字符串是否包含
     *
     * @param string
     * @param find
     * @return
     */
    public static boolean strExists(String string, String find) {
        return string != null && find != null && string.contains(find);
    }

    /**
     * 左边是否包含
     *
     * @param string
     * @param find
     * @return
     */
    public static boolean leftExists(String string, String find) {
        return string != null && find != null && string.startsWith(find);
    }

    /**
     * 右边是否包含
     *
     * @param string
     * @param find
     * @return
     */
    public static boolean rightExists(String string, String find) {
        return string != null && find != null && string.endsWith(find);
    }

    /**
     * 获取中间字符串
     *
     * @param string
     * @param start
     * @param end
     * @return
     */
    public static String getMiddle(String string, String start, String end) {
        String text = string;
        if (text != null) {
            if (start != null && !start.isEmpty() && text.contains(start)) {
                text = text.substring(text.indexOf(start) + start.length());
            }
            if (end != null && !end.isEmpty() && text.contains(end)) {
                text = text.substring(0, text.indexOf(end));
            }
        }
        return text;
    }

    /**
     * 删除前后字符串
     *
     * @param string
     * @param del
     * @return
     */
    public static String trim(String string, String del) {
        String text = string;
        if (text != null) {
            if (del == null || del.equals(" ")) {
                return string.trim();
            }
            if (text.startsWith(del)) {
                text = text.substring(del.length());
            }
            if (text.endsWith(del)) {
                text = text.substring(0, text.length() - del.length());
            }
        }
        return text;
    }

    /**
     * 获取地址文件名称
     * @param url
     * @return
     */
    public static String getUrlName(String url) {
        Uri uri = Uri.parse(url);
        List<String> pathSegList = uri.getPathSegments();
        String name = "";
        for (String key : pathSegList) {
            if (!key.isEmpty()) name = key;
        }
        return name;
    }

    /**
     * 生成随机字符串
     *
     * @param length
     * @return
     */
    public static String randomString(int length) {
        String base = "ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678oOLl9gqVvUuI1";
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int number = random.nextInt(base.length());
            sb.append(base.charAt(number));
        }
        return sb.toString();
    }

    /**
     * 动态设置ListView高度
     * @param listView
     */
    public static void setListViewHeightBasedOnChildren(ListView listView) {
        ListAdapter listAdapter = listView.getAdapter();
        if (listAdapter == null) {
            return;
        }
        int totalHeight = 0;
        for (int i = 0, len = listAdapter.getCount(); i < len; i++) {
            View listItem = listAdapter.getView(i,null, listView);
            listItem.measure(0, 0);
            totalHeight += listItem.getMeasuredHeight();
        }
        ViewGroup.LayoutParams params = listView.getLayoutParams();
        params.height = totalHeight + (listView.getDividerHeight() * (listAdapter.getCount() - 1));
        listView.setLayoutParams(params);
        listView.invalidate();
    }

    /**
     * 获取状态栏高度
     *
     * @param context
     * @return
     */
    public static int getStatusBarHeight(Context context) {
        return eeuiStatusBarUtils.getStatusBarHeight(context);
    }

    /**
     * 获取虚拟键盘高度
     *
     * @param context
     * @return
     */
    public static int getNavigationBarHeight(Context context) {
        return eeuiStatusBarUtils.getNavigationBarHeight(context);
    }

    /**
     * 设置view宽高
     *
     * @param view
     * @param width
     * @param height
     */
    public static void setViewWidthHeight(View view, int width, int height) {
        ViewGroup.LayoutParams params = view.getLayoutParams();
        if (params == null) {
            return;
        }
        if (width > -1) {
            params.width = width;
        }
        if (height > -1) {
            params.height = height;
        }
        view.setLayoutParams(params);
    }

    /**
     * 设置 Margins
     *
     * @param v
     * @param l
     * @param t
     * @param r
     * @param b
     */
    public static void setMargins(View v, int l, int t, int r, int b) {
        if (v.getLayoutParams() instanceof ViewGroup.MarginLayoutParams) {
            ViewGroup.MarginLayoutParams p = (ViewGroup.MarginLayoutParams) v.getLayoutParams();
            p.setMargins(l, t, r, b);
            v.requestLayout();
        }
    }

    /**
     * 等比计算宽度
     *
     * @param newHeight
     * @param oldWidth
     * @param oldHeight
     * @return
     */
    public static double scaleWidth(double newHeight, double oldWidth, double oldHeight) {
        return oldWidth / oldHeight * newHeight;
    }

    /**
     * 等比计算高度
     *
     * @param newWidth
     * @param oldWidth
     * @param oldHeight
     * @return
     */
    public static double scaleHeight(double newWidth, double oldWidth, double oldHeight) {
        return oldHeight / oldWidth * newWidth;
    }

    public static String formatNum(double i) {
        DecimalFormat decimalFormat= new DecimalFormat(".0");
        String str = String.valueOf(i);
        String unit = "";
        if (i > 100000000) {
            str = decimalFormat.format((i / 100000000));
            unit = "亿";
        }else if (i > 10000000) {
            str = decimalFormat.format((i / 10000000));
            unit = "千万";
        }else if (i > 1000000) {
            str = decimalFormat.format((i / 1000000));
            unit = "百万";
        }else if (i > 10000) {
            str = decimalFormat.format((i / 10000));
            unit = "万";
        }
        if (rightExists(str, ".0")) {
            str = str.substring(0, str.length() - 2);
        }
        return str + unit;
    }

    /**
     * 保存图片（会申请权限）
     * @param context
     * @param bmp
     * @param fileName      自定义文件名
     * @param appDir        保存目录地址
     * @param onStringListener
     */
    @SuppressLint("WrongConstant")
    public static void saveImageToGallery(Context context, Bitmap bmp, String fileName, File appDir, OnStringListener onStringListener) {
        Context finalContext = context != null ? context : eeui.getActivityList().getLast();
        String path = imageToGallery(finalContext, bmp, fileName, appDir);
        if (path != null) {
            onStringListener.doSomething(path);
            return;
        }
        PermissionUtils.permission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                .rationale(shouldRequest -> PermissionUtils.showRationaleDialog(finalContext, shouldRequest, "存储"))
                .callback(new PermissionUtils.FullCallback() {
                    @Override
                    public void onGranted(List<String> permissionsGranted) {
                        onStringListener.doSomething(imageToGallery(finalContext, bmp, fileName, appDir));
                    }

                    @Override
                    public void onDenied(List<String> permissionsDeniedForever, List<String> permissionsDenied) {
                        if (!permissionsDeniedForever.isEmpty()) {
                            PermissionUtils.showOpenAppSettingDialog(finalContext, "存储");
                        }
                        onStringListener.doSomething(null);
                    }
                }).request();
    }

    /**
     * 保存图片
     * @param context
     * @param bmp
     * @param fileName      自定义文件名
     * @param appDir        保存目录地址
     * @return
     */
    private static String imageToGallery(Context context, Bitmap bmp, String fileName, File appDir) {
        if (appDir == null) {
            appDir = FileUtil.getCacheDir("image");
        }
        if (fileName == null) {
            fileName = System.currentTimeMillis() + ".jpg";
        }
        if (appDir != null && (appDir.exists() || appDir.mkdirs())) {
            // 保存图片
            File currentFile = new File(appDir, fileName);
            FileOutputStream fos = null;
            try {
                fos = new FileOutputStream(currentFile);
                bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
                fos.flush();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (fos != null) {
                        fos.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            // 通知图库更新
            context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(new File(currentFile.getPath()))));
            //
            if (currentFile.exists()) {
                return currentFile.getPath();
            }
        }
        return null;
    }

    /**
     * 大陆号码或香港号码均可
     */
    public static boolean isPhoneLegal(String str)throws PatternSyntaxException {
        return isChinaPhoneLegal(str) || isHKPhoneLegal(str);
    }

    /**
     * 大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
     * 此方法中前三位格式有：
     * 13+任意数
     * 15+除4的任意数
     * 18+除1和4的任意数
     * 17+除9的任意数
     * 147
     */
    public static boolean isChinaPhoneLegal(String str) throws PatternSyntaxException {
        String regExp = "^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$";
        Pattern p = Pattern.compile(regExp);
        Matcher m = p.matcher(str);
        return m.matches();
    }

    /**
     * 香港手机号码8位数，5|6|8|9开头+7位任意数
     */
    public static boolean isHKPhoneLegal(String str)throws PatternSyntaxException {
        String regExp = "^(5|6|8|9)\\d{7}$";
        Pattern p = Pattern.compile(regExp);
        Matcher m = p.matcher(str);
        return m.matches();
    }

    /**
     * 获取本地软件版本号
     * @param ctx
     * @return
     */
    public static int getLocalVersion(Context ctx) {
        int localVersion = 0;
        try {
            PackageInfo packageInfo = ctx.getApplicationContext().getPackageManager().getPackageInfo(ctx.getPackageName(), 0);
            localVersion = packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return localVersion;
    }

    /**
     * 获取本地软件版本号名称
     * @param ctx
     * @return
     */
    public static String getLocalVersionName(Context ctx) {
        String localVersion = "";
        try {
            PackageInfo packageInfo = ctx.getApplicationContext().getPackageManager().getPackageInfo(ctx.getPackageName(), 0);
            localVersion = packageInfo.versionName;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return localVersion;
    }

    /**
     * 比较版本号的大小,前者大则返回一个正数,后者大返回一个负数,相等则返回0
     *
     * @param version1
     * @param version2
     */
    public static int compareVersion(String version1, String version2) throws Exception {
        if (version1 == null || version2 == null) {
            throw new Exception("compareVersion error:illegal params.");
        }
        String[] versionArray1 = version1.split("\\.");
        String[] versionArray2 = version2.split("\\.");
        int idx = 0;
        int minLength = Math.min(versionArray1.length, versionArray2.length);
        int diff = 0;
        while (idx < minLength
                && (diff = versionArray1[idx].length() - versionArray2[idx].length()) == 0
                && (diff = versionArray1[idx].compareTo(versionArray2[idx])) == 0) {
            ++idx;
        }
        diff = (diff != 0) ? diff : versionArray1.length - versionArray2.length;
        return diff;
    }



    /**
     * 字符串MD5加密
     * @param string
     * @return
     */
    public static String md5(String string) {
        if (TextUtils.isEmpty(string)) {
            return "";
        }
        MessageDigest md5;
        try {
            md5 = MessageDigest.getInstance("MD5");
            byte[] bytes = md5.digest(string.getBytes());
            StringBuilder result = new StringBuilder();
            for (byte b : bytes) {
                String temp = Integer.toHexString(b & 0xff);
                if (temp.length() == 1) {
                    temp = "0" + temp;
                }
                result.append(temp);
            }
            return result.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 秒转化为天小时分秒字符串
     *
     * @param seconds
     * @return String
     */
    public static String formatSeconds(long seconds) {
        String timeStr = seconds + "秒";
        if (seconds > 60) {
            long second = seconds % 60;
            long min = seconds / 60;
            timeStr = min + "分" + second + "秒";
            if (min > 60) {
                min = (seconds / 60) % 60;
                long hour = (seconds / 60) / 60;
                //timeStr = hour + "时" + min + "分" + second + "秒";
                timeStr = hour + "时" + min + "分";
                if (hour > 24) {
                    hour = ((seconds / 60) / 60) % 24;
                    long day = (((seconds / 60) / 60) / 24);
                    //timeStr = day + "天" + hour + "时" + min + "分" + second + "秒";
                    timeStr = day + "天" + hour + "时" + min + "分";
                }
            }
        }
        return timeStr;
    }

    /**
     * 获取IMEI
     * @param ctx
     * @return
     */
    @SuppressLint({"MissingPermission", "NewApi", "HardwareIds", "WrongConstant"})
    public static String getImei(Context ctx) {
        final String[] result = {null};
        final CountDownLatch latch = new CountDownLatch(1);
        new Thread(() -> PermissionUtils.permission(Manifest.permission.READ_PHONE_STATE)
                .rationale(shouldRequest -> PermissionUtils.showRationaleDialog(ctx, shouldRequest, "电话"))
                .callback(new PermissionUtils.FullCallback() {
                    @Override
                    public void onGranted(List<String> permissionsGranted) {
                        String imei = "";
                        TelephonyManager tm = (TelephonyManager) ctx.getSystemService(Context.TELEPHONY_SERVICE);
                        if (tm != null) {
                            try {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    imei = tm.getImei();
                                }else{
                                    imei = tm.getDeviceId();
                                }
                            } catch (Exception ignored) {  }
                        }
                        result[0] = imei;
                        latch.countDown();
                    }

                    @Override
                    public void onDenied(List<String> permissionsDeniedForever, List<String> permissionsDenied) {
                        if (!permissionsDeniedForever.isEmpty()) {
                            PermissionUtils.showOpenAppSettingDialog(ctx, "电话");
                        }
                        result[0] = "";
                        latch.countDown();
                    }
                }).request()).start();
        try {
            latch.await();
        } catch (InterruptedException ignored) {
            //
        }
        return result[0];
    }

    /**
     * 获取activity上所有的控件
     * @param view
     * @return
     */
    public static List<View> getAllChildViews(View view) {
        List<View> allchildren = new ArrayList<>();
        if (view instanceof ViewGroup) {
            ViewGroup vp = (ViewGroup) view;
            for (int i = 0; i < vp.getChildCount(); i++) {
                View viewchild = vp.getChildAt(i);
                allchildren.add(viewchild);
                allchildren.addAll(getAllChildViews(viewchild));
            }
        }
        return allchildren;
    }

    /**
     * List 集合去除 null 元素
     * @param oldList
     * @param <T>
     * @return
     */
    public static <T> List<T> removeNull(List<? extends T> oldList) {
        List<T> listTemp = new ArrayList();
        for (int i = 0;i < oldList.size(); i++) {
            if (oldList.get(i) != null) {
                listTemp.add(oldList.get(i));
            }
        }
        return listTemp;
    }

    /**
     * 保存图片
     * @param context
     * @param url
     * @param mJSCallback
     */
    public static void saveImage(Context context, String url, JSCallback mJSCallback) {
        if (url == null) {
            if (mJSCallback != null) {
                Map<String, Object> data = new HashMap<>();
                data.put("status", "error");
                data.put("error", "地址出错");
                data.put("path", "");
                mJSCallback.invoke(data);
            }
            return;
        }
        final boolean[] loadSure = {false};
        Glide.with(context)
                .asBitmap()
                .load(url)
                .apply(new RequestOptions().diskCacheStrategy(DiskCacheStrategy.ALL))
                .into(new SimpleTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, Transition<? super Bitmap> transition) {
                        if (!loadSure[0]) {
                            loadSure[0] = true;
                            File appDir = new File(Environment.getExternalStorageDirectory(), x.app().getPackageName());
                            String fileName = RxEncryptTool.encryptMD5ToString(url) + ".jpg";
                            eeuiCommon.saveImageToGallery(context, resource, fileName, appDir, path -> {
                                if (mJSCallback != null) {
                                    Map<String, Object> data = new HashMap<>();
                                    data.put("status", "error");
                                    data.put("error", "保存失败");
                                    data.put("path", "");
                                    if (path != null) {
                                        data.put("status", "success");
                                        data.put("error", "");
                                        data.put("path", path);
                                    }
                                    mJSCallback.invoke(data);
                                }
                            });
                        }
                    }
                });
        new Handler().postDelayed(() -> {
            if (!loadSure[0]) {
                loadSure[0] = true;
                if (mJSCallback != null) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("status", "error");
                    data.put("error", "保存超时");
                    data.put("path", "");
                    mJSCallback.invoke(data);
                }
            }
        }, 10000);
    }

    /**
     * 中划线转换为驼峰
     * @param param
     * @return
     */
    public static String camelCaseName(String param) {
        if (param == null || "".equals(param.trim())) {
            return "";
        }
        char underLine = '-';
        int len = param.length();
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            char c = param.charAt(i);
            if (c == underLine) {
                if (++i < len) {
                    sb.append(Character.toUpperCase(param.charAt(i)));
                }
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    /**
     * 过滤已存在样式
     * @param basicComponentData
     * @param custom
     * @return
     */
    public static Map<String, Object> filterAlreadyStyle(BasicComponentData basicComponentData, Map<String, Object> custom) {
        Map<String, Object> newCustom = new HashMap<>();
        if (custom == null) {
            return newCustom;
        }
        for (Map.Entry<String, Object> entry : custom.entrySet()) {
            newCustom.put(eeuiCommon.camelCaseName(entry.getKey()), entry.getValue());
        }
        JSONObject json = eeuiJson.parseObject(basicComponentData.getAttrs().get("eeui"));
        if (json.size() > 0) {
            for (Map.Entry<String, Object> entry : json.entrySet()) {
                newCustom.remove(eeuiCommon.camelCaseName(entry.getKey()));
            }
        }
        for (Map.Entry<String, Object> entry : basicComponentData.getStyles().entrySet()) {
            newCustom.remove(eeuiCommon.camelCaseName(entry.getKey()));
        }
        return newCustom;
    }

    /**
     * 遍历删除目录下所有文件
     * @param dir
     * @return
     */
    public static JSONObject deleteAllInDir(File dir) {
        if (dir == null) return eeuiJson.parseObject("{error:0,success:0}");
        if (!dir.exists()) return eeuiJson.parseObject("{error:0,success:0}");
        if (!dir.isDirectory()) return eeuiJson.parseObject("{error:0,success:0}");
        int error = 0;
        int success = 0;
        File[] files = dir.listFiles();
        if (files != null && files.length != 0) {
            for (File file : files) {
                if (file.isFile()) {
                    if (file.delete()) {
                        success++;
                    }else{
                        error++;
                    }
                } else if (file.isDirectory()) {
                    JSONObject tmpData = eeuiCommon.deleteAllInDir(file);
                    error+= tmpData.getIntValue("error");
                    success+= tmpData.getIntValue("success");
                }
            }
        }
        if (dir.delete()) {
            success++;
        }
        JSONObject data = new JSONObject();
        data.put("error", error);
        data.put("success", success);
        return data;
    }

    /**
     * 获取assets文件夹下文件内容
     * @param context
     * @param fileName
     * @return
     */
    public static String getAssetsFile(Context context, String fileName) {
        Uri uri = Uri.parse(fileName);
        if (uri != null && uri.getPath() != null) {
            return WXFileUtils.loadAsset(uri.getPath().replaceFirst("/", ""), context);
        }
        return "";
    }
}
