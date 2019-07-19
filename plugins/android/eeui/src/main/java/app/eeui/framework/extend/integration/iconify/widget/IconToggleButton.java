package app.eeui.framework.extend.integration.iconify.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ToggleButton;
import app.eeui.framework.extend.integration.iconify.Iconify;
import app.eeui.framework.extend.integration.iconify.internal.HasOnViewAttachListener;

public class IconToggleButton extends ToggleButton implements HasOnViewAttachListener {

    private HasOnViewAttachListenerDelegate delegate;

    public IconToggleButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public IconToggleButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public IconToggleButton(Context context) {
        super(context);
        init();
    }

    private void init() {
        setTransformationMethod(null);
    }

    @Override
    public void setText(CharSequence text, BufferType type) {
        super.setText(Iconify.compute(getContext(), text, this), BufferType.NORMAL);
    }

    @Override
    public void setOnViewAttachListener(OnViewAttachListener listener) {
        if (delegate == null) delegate = new HasOnViewAttachListenerDelegate(this);
        delegate.setOnViewAttachListener(listener);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        delegate.onAttachedToWindow();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        delegate.onDetachedFromWindow();
    }

}
