"use strict";

var Gallery = (function() {
  var $;
  var $gallery;
  var currentIndex;
  var layoutItemMax = false;

  function renderText(url) {
    var http = new XMLHttpRequest();
    http.open("GET", url);
    http.onload = function() {
      $("#text-content").innerHTML = ume(http.responseText);
      $("#text").scrollTop = 0;
      $("#text-anchor").focus();
    }
    http.send();
  }

  function clearContent() {
    $gallery.classList.remove("image", "video", "audio", "text");
    $("#image").src = "about:none";
    $("#video").src = "about:none";
    $("#audio").src = "about:none";
    $("#text-content").innerHTML = "";
  }

  function render() {
    clearContent();

    var entry = Entries.media()[currentIndex];

    var url = entry.href;
    var type = entry.mediaType;

    $gallery.classList.add(type);

    if(type == "text") {
      renderText(url);
    }
    else {
      var $element = $("#" + type);
      $element.src = url;
      $element.focus();
    }

    window.scrollTo(0, 0);

    //if(currentPage < imageUrls.length) (new Image()).src = imageUrls[currentPage];
  }

  function clamp(index) {
    if(index == null || isNaN(index) || index < 0) return 0;
    if(index >= Entries.media().length) return Entries.media().length - 1;
    return index;
  }

  function go(index) {
    var newIndex = clamp(index);
    if(newIndex == currentIndex) return;

    currentIndex = newIndex;
    render();
  }

  function prev() {
    go(currentIndex - 1);
  }

  function next() {
    go(currentIndex + 1);
  }

  function rewind() {
    go(currentIndex - 10);
  }

  function fastForward() {
    go(currentIndex + 10);
  }

  function jump(url) {
    var index = Entries.media().findIndex(function(entry) {
      return entry.href == url;
    });
    go(index);
  }

  function atBottom() {
    return (window.scrollY + window.innerHeight) == document.body.scrollHeight;
  }

  function initEvents() {
    document.body.addEventListener("click", function(e) {
      if(!e.target) return;

      if(e.target.matches("#page-back")) {
        e.stopPropagation();
        prev();
      }
      else if(e.target.matches("#page-back-10")) {
        e.stopPropagation();
        rewind();
      }
      else if(e.target.matches("#page-next")) {
        e.stopPropagation();
        next();
      }
      else if(e.target.matches("#page-next-10")) {
        e.stopPropagation();
        fastForward();
      }
      else if(e.target.matches("#page-jump-listing")) {
        e.preventDefault();
        Index.jumpListing();
      }
      else if(e.target.closest("#page-max-item")) {
        e.stopPropagation();
        layoutItemMax = !layoutItemMax;
        layout();
      }
    });

    window.addEventListener("keydown", function(e) {
      if(e.target == $("#search")) return;

      if(e.keyCode == 39 || ((e.keyCode == 32 || e.keyCode == 13) && atBottom())) {
        e.preventDefault();
        next();
      }
      else if(e.keyCode == 8 || e.keyCode == 37) {
        e.preventDefault();
        prev();
      }
    });
  }

  function layout() {
    var viewportHeight = document.documentElement.clientHeight + "px";
    $gallery.style.minHeight = viewportHeight;

    var maxHeight = layoutItemMax ? "none" : viewportHeight;
    $("#image").style.maxHeight = maxHeight;
    $("#video").style.maxHeight = maxHeight;
    $("#audio").style.maxHeight = maxHeight;
  }

  function initLayout() {
    window.addEventListener("resize", layout);
    layout();
  }

  function onEntriesUpdate() {
    currentIndex = 0;
    if(Entries.hasMedia()) render();
  }

  function init() {
    $ = document.querySelector.bind(document);
    $gallery = $("#gallery");

    onEntriesUpdate();

    if(Entries.hasMedia()) {
      document.body.classList.add("has-gallery");

      initEvents();
      initLayout();
    }
  }

  return {
    init: init,
    onEntriesUpdate: onEntriesUpdate,
    go: go,
    prev: prev,
    next: next,
    rewind: rewind,
    fastForward: fastForward,
    jump: jump
  };
})();

window.addEventListener("DOMContentLoaded", Gallery.init);