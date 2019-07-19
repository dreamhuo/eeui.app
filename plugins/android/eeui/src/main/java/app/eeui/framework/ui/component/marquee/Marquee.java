package app.eeui.framework.ui.component.marquee;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.ui.action.BasicComponentData;
import com.taobao.weex.ui.component.WXVContainer;

import java.util.Map;

import app.eeui.framework.R;
import com.alibaba.fastjson.JSONObject;

import app.eeui.framework.extend.module.eeuiCommon;
import app.eeui.framework.extend.module.eeuiConstants;
import app.eeui.framework.extend.module.eeuiJson;
import app.eeui.framework.extend.module.eeuiParse;
import app.eeui.framework.extend.module.eeuiScreenUtils;
import app.eeui.framework.extend.view.FocusedTextView;

/**
 * Created by WDM on 2018/3/5.
 */

public class Marquee extends WXVContainer<ViewGroup> {

    private static final String TAG = "Marquee";

    private View mView;

    private String mText = "";

    private LinearLayout v_body;

    private FocusedTextView v_autotext;

    public Marquee(WXSDKInstance instance, WXVContainer parent, BasicComponentData basicComponentData) {
        super(instance, parent, basicComponentData);
    }

    @Override
    protected ViewGroup initComponentHostView(@NonNull Context context) {
        mView = ((Activity) context).getLayoutInflater().inflate(R.layout.layout_eeui_marquee, null);
        initPagerView();
        appleStyleAfterCreated();
        //
        if (getEvents().contains(eeuiConstants.Event.READY)) {
            fireEvent(eeuiConstants.Event.READY, null);
        }
        //
        return (ViewGroup) mView;
    }

    @Override
    public void addSubView(View view, int index) {

    }

    @Override
    protected boolean setProperty(String key, Object param) {
        return initProperty(key, param) || super.setProperty(key, param);
    }

    private boolean initProperty(String key, Object val) {
        switch (eeuiCommon.camelCaseName(key)) {
            case "eeui":
                JSONObject json = eeuiJson.parseObject(eeuiParse.parseStr(val, ""));
                if (json.size() > 0) {
                    for (Map.Entry<String, Object> entry : json.entrySet()) {
                        initProperty(entry.getKey(), entry.getValue());
                    }
                }
                return true;

            case "text":
            case "content":
                setText(eeuiParse.parseStr(val, ""));
                return true;

            case "color":
                setTextColor(eeuiParse.parseStr(val, "#000000"));
                return true;

            case "fontSize":
                setTextSize(val);
                return true;

            case "textAlign":
                setTextAlign(val);
                return true;

            case "backgroundColor":
                setBackgroundColor(eeuiParse.parseStr(val, "#00ffffff"));
                return true;

            default:
                return false;
        }
    }

    private void initPagerView() {
        v_body = mView.findViewById(R.id.v_body);
        v_autotext = mView.findViewById(R.id.v_autotext);
    }

    private void appleStyleAfterCreated() {
        setTextSize(24);
    }

    /***************************************************************************************************/
    /***************************************************************************************************/
    /***************************************************************************************************/

    /**
     * 设置文本
     * @param var
     */
    @JSMethod
    public void setText(String var) {
        if (var != null) {
            mText = var;
        }
        v_autotext.setText(mText);
    }

    /**
     * 添加文本
     * @param var
     */
    @JSMethod
    public void addText(String var) {
        if (var == null) {
            return;
        }
        setText(mText + var);
    }

    /**
     * 获取文本
     * @return
     */
    @JSMethod(uiThread = false)
    public String getText() {
        return mText;
    }

    /**
     * 设置文字大小
     * @param var
     */
    @JSMethod
    public void setTextSize(Object var) {
        v_autotext.setTextSize(TypedValue.COMPLEX_UNIT_PX, eeuiScreenUtils.weexPx2dp(getInstance(), var, 24));
    }
    /**
     * 设置文字水平对齐
     * @param var
     */
    @JSMethod
    public void setTextAlign(Object var) {
        switch (eeuiParse.parseStr(var, "").toLowerCase()) {
            case "center":
                v_autotext.setGravity(Gravity.CENTER);
                break;
            case "left":
                v_autotext.setGravity(Gravity.CENTER_VERTICAL | Gravity.START);
                break;
            case "right":
                v_autotext.setGravity(Gravity.CENTER_VERTICAL | Gravity.END);
                break;
        }
    }

    /**
     * 设置文字颜色
     * @param var
     */
    @JSMethod
    public void setTextColor(String var) {
        v_autotext.setTextColor(eeuiParse.parseColor(var));
    }

    /**
     * 设置文字背景颜色
     * @param var
     */
    @JSMethod
    public void setBackgroundColor(String var) {
        v_body.setBackgroundColor(eeuiParse.parseColor(var));
    }
}
