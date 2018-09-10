"use strict";

var Index = (function() {
  function galleryVisible() {
    return document.body.classList.contains("gallery");
  }

  function listingVisible() {
    return document.body.classList.contains("listing");
  }

  function jumpListing() {
    document.body.classList.remove("gallery");
    document.body.classList.add("listing");
  }

  function jumpGallery() {
    document.body.classList.remove("listing");
    document.body.classList.add("gallery");
  }

  function jumpScroll() {
    if(galleryVisible()) {
      jumpListing();
      window.scrollTo(0, 0);
    }
    else {
      jumpGallery();
      window.scrollTo(0, document.body.scrollHeight);
    }
  }

  function atTop() {
    return window.scrollY == 0;
  }

  function bottomScrollDown(event) {
    return galleryVisible() && atBottom() && event.deltaY > 0;
  }

  function topScrollUp(event) {
    return listingVisible() && atTop() && event.deltaY < 0;
  }

  function initEvents() {
    var scrollSize = 0;

    window.addEventListener("wheel", function(event) {
      if(bottomScrollDown(event) || topScrollUp(event)) {
        scrollSize += Math.abs(event.deltaY);

        if(scrollSize >= 1500) {
          scrollSize = 0;
          jumpScroll();
        }
      }
      else {
        scrollSize = 0;
      }
    });
  }

  function init() {
    if((Entries.media().length / Entries.all().length) >= 0.5) jumpGallery();
    else jumpListing();

    initEvents();
  }

  return {
    init: init,
    galleryVisible: galleryVisible,
    listingVisible: listingVisible,
    jumpListing: jumpListing,
    jumpGallery: jumpGallery
  };
})();

window.addEventListener("DOMContentLoaded", Index.init);