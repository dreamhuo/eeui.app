package app.eeui.framework.extend.integration.glide.load.engine.cache;

import android.annotation.SuppressLint;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import app.eeui.framework.extend.integration.glide.load.Key;
import app.eeui.framework.extend.integration.glide.load.engine.Resource;
import app.eeui.framework.extend.integration.glide.util.LruCache;

/**
 * An LRU in memory cache for {@link app.eeui.framework.extend.integration.glide.load.engine.Resource}s.
 */
public class LruResourceCache extends LruCache<Key, Resource<?>> implements MemoryCache {
  private ResourceRemovedListener listener;

  /**
   * Constructor for LruResourceCache.
   *
   * @param size The maximum size in bytes the in memory cache can use.
   */
  public LruResourceCache(long size) {
    super(size);
  }

  @Override
  public void setResourceRemovedListener(@NonNull ResourceRemovedListener listener) {
    this.listener = listener;
  }

  @Override
  protected void onItemEvicted(@NonNull Key key, @Nullable Resource<?> item) {
    if (listener != null && item != null) {
      listener.onResourceRemoved(item);
    }
  }

  @Override
  protected int getSize(@Nullable Resource<?> item) {
    if (item == null) {
      return super.getSize(null);
    } else {
      return item.getSize();
    }
  }

  @SuppressLint("InlinedApi")
  @Override
  public void trimMemory(int level) {
    if (level >= android.content.ComponentCallbacks2.TRIM_MEMORY_BACKGROUND) {
      // Nearing middle of list of cached background apps
      // Evict our entire bitmap cache
      clearMemory();
    } else if (level >= android.content.ComponentCallbacks2.TRIM_MEMORY_UI_HIDDEN) {
      // Entering list of cached background apps
      // Evict oldest half of our bitmap cache
      trimToSize(getMaxSize() / 2);
    }
  }
}
