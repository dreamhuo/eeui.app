package app.eeui.framework.extend.module;

import android.graphics.Color;

/**
 * Created by WDM on 2018/3/17.
 */

public class eeuiParse {

    /**
     * 转字符串
     *
     * @param var
     * @return
     */
    public static String parseStr(Object var, String defaultVal) {
        if (var == null) {
            return defaultVal;
        }
        if (var.equals("null")) {
            return defaultVal;
        }
        try {
            return String.valueOf(var);
        }catch (Exception e) {
            return defaultVal;
        }
    }

    public static String parseStr(Object var) {
        return parseStr(var, "");
    }

    /**
     * 转逻辑
     * @param var
     * @return
     */
    public static boolean parseBool(Object var, boolean defaultVal) {
        if (var == null) {
            return defaultVal;
        }
        if (var instanceof Boolean) {
            return (Boolean) var;
        }
        if (var instanceof Number) {
            return ((Number) var).intValue() == 1;
        }
        if (var instanceof String) {
            String strVal = (String) var;
            if (strVal.length() == 0 || "null".equals(strVal)) {
                return defaultVal;
            }
            if ("true".equalsIgnoreCase(strVal) || "1".equals(strVal)) {
                return Boolean.TRUE;
            }
            if ("false".equalsIgnoreCase(strVal) || "0".equals(strVal)) {
                return Boolean.FALSE;
            }
        }
        return defaultVal;
    }

    public static boolean parseBool(Object var) {
        return parseBool(var, false);
    }

    /**
     * 转整数
     * @param var
     * @return
     */
    public static int parseInt(Object var, int defaultVal) {
        if (var == null) {
            return defaultVal;
        }
        if (var instanceof Number) {
            return ((Number) var).intValue();
        }
        try {
            return Integer.parseInt(String.valueOf(var));
        }catch (Exception e) {
            return defaultVal;
        }
    }

    public static int parseInt(Object var) {
        return parseInt(var, 0);
    }

    /**
     * 转Double
     * @param var
     * @return
     */
    public static double parseDouble(Object var, double defaultVal) {
        if (var == null) {
            return defaultVal;
        }
        if (var instanceof Number) {
            return ((Number) var).doubleValue();
        }
        try {
            return Double.parseDouble(String.valueOf(var));
        }catch (Exception e) {
            return defaultVal;
        }
    }

    public static double parseDouble(Object var) {
        return parseDouble(var, 0);
    }

    /**
     * 转浮点数
     * @param var
     * @return
     */
    public static float parseFloat(Object var, float defaultVal) {
        if (var == null) {
            return defaultVal;
        }
        if (var instanceof Number) {
            return ((Number) var).floatValue();
        }
        try {
            return Float.parseFloat(String.valueOf(var));
        }catch (Exception e) {
            return defaultVal;
        }
    }

    public static float parseFloat(Object var) {
        return parseFloat(var, 0);
    }

    /**
     * 转long
     * @param var
     * @return
     */
    public static long parseLong(Object var, long defaultVal) {
        if (var == null) {
            return defaultVal;
        }
        if (var instanceof Number) {
            return ((Number) var).longValue();
        }
        try {
            return Long.parseLong(String.valueOf(var));
        }catch (Exception e) {
            return defaultVal;
        }
    }

    public static long parseLong(Object var) {
        return parseLong(var, 0);
    }

    /**
     * 转颜色int
     * @param colorString
     * @return
     */
    public static int parseColor(Object colorString) {
        try{
            return Color.parseColor(eeuiParse.parseStr(colorString));
        }catch (Exception e) {
            return -1;
        }
    }
}
