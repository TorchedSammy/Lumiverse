import { Some, None } from "../gleam_stdlib/gleam/option.mjs";
import { Uri } from "../gleam_stdlib/gleam/uri.mjs";

// EXPORTS ---------------------------------------------------------------------

export const init = (dispatch) => {
  document.body.addEventListener("click", (event) => {
    const a = find_anchor(event.target);

    if (!a) return;

    try {
      const url = new URL(a.href);
      const uri = uri_from_url(url);

      // If the link is to a different origin, let the browser handle it. Our
      // router only handles internal links.
      if (url.host !== window.location.host) {
        return;
      }

      event.preventDefault();

      window.history.pushState({}, "", a.href);
      window.requestAnimationFrame(() => {
        // The browser automatically attempts to scroll to an element with a matching
        // id if a hash is present in the URL. Because we need to `preventDefault`
        // the event to prevent navigation, we also need to manually scroll to the
        // element if a
        if (url.hash) {
          document.getElementById(url.hash.slice(1))?.scrollIntoView();
        }
      });

      return dispatch(uri);
    } catch {
      return;
    }
  });

  window.addEventListener("popstate", (e) => {
    e.preventDefault();

    const url = new URL(window.location.href);
    const uri = uri_from_url(url);

    window.requestAnimationFrame(() => {
      if (url.hash) {
        document.getElementById(url.hash.slice(1))?.scrollIntoView();
      }
    });

    dispatch(uri);
  });
};

export const get_current_href = () => {
  const url = new URL(window.location.href);
  return uri_from_url(url);
}

// UTILS -----------------------------------------------------------------------

const find_anchor = (el) => {
  if (el.tagName === "BODY") {
    return null;
  } else if (el.tagName === "A") {
    return el;
  } else {
    return find_anchor(el.parentElement);
  }
};

const uri_from_url = (url) => {
  return new Uri(
    /* scheme   */ new (url.protocol ? Some : None)(url.protocol),
    /* userinfo */ new None(),
    /* host     */ new (url.host ? Some : None)(url.host),
    /* port     */ new (url.port ? Some : None)(url.port),
    /* path     */ url.pathname,
    /* query    */ new (url.search ? Some : None)(url.search),
    /* fragment */ new (url.hash ? Some : None)(url.hash.slice(1)),
  );
};
