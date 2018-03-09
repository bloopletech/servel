var Gallery = (function() {
  var urls = [];
  var types = [];
  var currentIndex = 0;

  function initItems() {
    var links = document.querySelectorAll("#listing a.default.media");
    for(var i = 0; i < links.length; i++) {
      var link = links[i];

      urls.push(link.href);
      types.push(link.dataset.type);
    }
  }

  function render() {
    var url = urls[currentIndex];
    var type = types[currentIndex];

    var galleryElement = document.querySelector("#gallery");
    galleryElement.classList.remove("image", "video", "audio");
    galleryElement.classList.add(type);

    document.getElementById(type).src = url;

    window.scrollTo(0, 0);

    //if(currentPage < imageUrls.length) (new Image()).src = imageUrls[currentPage];
  }

  function clamp(index) {
    if(index == null || isNaN(index) || index < 0) return 0;
    if(index >= urls.length) return urls.length - 1;
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
    go(urls.indexOf(url));
  }

  function atBottom() {
    return (window.scrollY + window.innerHeight) == document.body.scrollHeight;
  }

  function initEvents() {
    document.body.addEventListener("click", function(e) {
      if(!e.target) return;

      if(e.target.matches("a.media:not(.new-tab)")) {
        e.preventDefault();
        jump(e.target.href);
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
      else if(e.target.matches("#page-toggle-size")) {
        e.stopPropagation();
        document.body.classList.toggle("split-screen");
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

  function init() {
    initItems();
    initEvents();
    render();
  }

  return {
    init: init,
    render: render,
    clamp: clamp,
    go: go,
    prev: prev,
    next: next,
    rewind: rewind,
    fastForward: fastForward,
    jump: jump
  };
})();

function initGallery() {
  if(!document.querySelector("#gallery")) return;
  Gallery.init();
}

window.addEventListener("DOMContentLoaded", initGallery);