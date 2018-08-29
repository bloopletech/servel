var Gallery = (function() {
  var $;
  var $gallery;
  var mediaEntries = [];
  var currentIndex = 0;
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

    var entry = mediaEntries[currentIndex];

    var url = entry.href;
    var type = entry.media_type;

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
    if(index >= mediaEntries.length) return mediaEntries.length - 1;
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
    var index = mediaEntries.findIndex(function(entry) {
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

      if(e.target.matches("a.media:not(.new-tab)")) {
        e.preventDefault();
        jump(e.target.dataset.url);
      }
      else if(e.target.matches("#page-back")) {
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
        e.stopPropagation();
        $("#listing").scrollIntoView();
      }
      else if(e.target.closest("#page-max-item")) {
        e.stopPropagation();
        layoutItemMax = !layoutItemMax;
        layout();
      }
    });

    window.addEventListener("keydown", function(e) {
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
    $("#controls").style.height = viewportHeight;

    var maxHeight = layoutItemMax ? "none" : viewportHeight;
    $("#image").style.maxHeight = maxHeight;
    $("#video").style.maxHeight = maxHeight;
    $("#audio").style.maxHeight = maxHeight;
  }

  function initLayout() {
    window.addEventListener("resize", layout);
    layout();
  }

  function onEntriesInit() {
    onEntriesUpdate();

    if(mediaEntries.length > 0) {
      $gallery.style.display = "flex";

      initEvents();
      initLayout();
    }
  }

  function onEntriesUpdate() {
    currentIndex = 0;
    mediaEntries = [];
    for(var i = 0; i < entries.length; i++) {
      if(entries[i].media) mediaEntries.push(entries[i]);
    }

    if(mediaEntries.length > 0) render();
  }

  window.addEventListener("DOMContentLoaded", function() {
    $ = document.querySelector.bind(document);
    $gallery = $("#gallery");
  });

  return {
    onEntriesInit: onEntriesInit,
    onEntriesUpdate: onEntriesUpdate,
    go: go,
    prev: prev,
    next: next,
    rewind: rewind,
    fastForward: fastForward,
    jump: jump
  };
})();
