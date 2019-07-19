package app.eeui.framework.extend.integration.glide.load.resource.gif;

import android.graphics.Bitmap;
import android.support.annotation.NonNull;
import app.eeui.framework.extend.integration.glide.gifdecoder.GifDecoder;
import app.eeui.framework.extend.integration.glide.load.Options;
import app.eeui.framework.extend.integration.glide.load.ResourceDecoder;
import app.eeui.framework.extend.integration.glide.load.engine.Resource;
import app.eeui.framework.extend.integration.glide.load.engine.bitmap_recycle.BitmapPool;
import app.eeui.framework.extend.integration.glide.load.resource.bitmap.BitmapResource;

/**
 * Decodes {@link Bitmap}s from {@link GifDecoder}s representing a particular frame of a particular
 * GIF image.
 */
public final class GifFrameResourceDecoder implements ResourceDecoder<GifDecoder, Bitmap> {
  private final BitmapPool bitmapPool;

  public GifFrameResourceDecoder(BitmapPool bitmapPool) {
    this.bitmapPool = bitmapPool;
  }

  @Override
  public boolean handles(@NonNull GifDecoder source, @NonNull Options options) {
    return true;
  }

  @Override
  public Resource<Bitmap> decode(@NonNull GifDecoder source, int width, int height,
      @NonNull Options options) {
    Bitmap bitmap = source.getNextFrame();
    return BitmapResource.obtain(bitmap, bitmapPool);
  }
}
