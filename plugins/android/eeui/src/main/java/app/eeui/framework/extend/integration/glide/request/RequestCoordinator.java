package app.eeui.framework.extend.integration.glide.request;

/**
 * An interface for coordinating multiple requests with the same {@link
 * app.eeui.framework.extend.integration.glide.request.target.Target}.
 */
public interface RequestCoordinator {

  /**
   * Returns true if the {@link Request} can display a loaded bitmap.
   *
   * @param request The {@link Request} requesting permission to display a bitmap.
   */
  boolean canSetImage(Request request);

  /**
   * Returns true if the {@link Request} can display a placeholder.
   *
   * @param request The {@link Request} requesting permission to display a placeholder.
   */
  boolean canNotifyStatusChanged(Request request);

  /**
   * Returns {@code true} if the {@link Request} can clear the
   * {@link app.eeui.framework.extend.integration.glide.request.target.Target}.
   */
  boolean canNotifyCleared(Request request);

  /**
   * Returns true if any coordinated {@link Request} has successfully completed.
   *
   * @see Request#isComplete()
   */
  boolean isAnyResourceSet();

  /**
   * Must be called when a {@link Request} coordinated by this object completes successfully.
   */
  void onRequestSuccess(Request request);

  /** Must be called when a {@link Request} coordinated by this object fails. */
  void onRequestFailed(Request request);
}
