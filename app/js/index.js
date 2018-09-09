"use strict";

var Index = (function() {
  function jumpListing() {
    document.body.classList.remove("gallery");
    document.body.classList.add("listing");
  }

  function jumpGallery() {
    document.body.classList.remove("listing");
    document.body.classList.add("gallery");
  }

  function init() {
    if(document.body.classList.contains("has-gallery")) jumpGallery();
    else jumpListing();
  }

  return {
    init: init,
    jumpListing: jumpListing,
    jumpGallery: jumpGallery
  };
})();

window.addEventListener("DOMContentLoaded", Index.init);