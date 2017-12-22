var pages = null;
var currentPage = 1;

function loadPages() {
  pages = [];

  var links = document.querySelectorAll("#listing a.viewable");
  for(var i = 0; i < links.length; i++) {
    var link = links[i];
    var type = link.classList.contains("image") ? "image" : "video";
    pages.push({ url: link.href, type: type });
  }
}

function page(index) {
  if(arguments.length == 1) {
    if(isNaN(index) || index < 1) index = 1;
    if(index > pages.length) index = pages.length;
    
    currentPage = index;
    showCurrentPage();
  }
  else {
    var index = currentPage;
    if(isNaN(index) || index < 1) index = 1;
    return index;
  }
}

function atBottom() {
  return (window.scrollY + window.innerHeight) == document.body.scrollHeight;
}

function initPaginator() {
  document.querySelector("#page-back").addEventListener("click", function(e) {
    e.stopPropagation();
    page(page() - 1);
  });
  document.querySelector("#page-back-10").addEventListener("click", function(e) {
    e.stopPropagation();
    page(page() - 10);
  });
  document.querySelector("#page-next").addEventListener("click", function(e) {
    e.stopPropagation();
    page(page() + 1);
  });
  document.querySelector("#page-next-10").addEventListener("click", function(e) {
    e.stopPropagation();
    page(page() + 10);
  });
  document.querySelector("#page-toggle-size").addEventListener("click", function(e) {
    e.stopPropagation();
    document.body.classList.toggle("split-screen");
  });

  window.addEventListener("keydown", function(event) {
    if(event.keyCode == 39 || ((event.keyCode == 32 || event.keyCode == 13) && atBottom())) {
      event.preventDefault();
      page(page() + 1);
    }
    else if(event.keyCode == 8 || event.keyCode == 37) {
      event.preventDefault();
      page(page() - 1);
    }
  });
}

function showCurrentPage() {
  window.scrollTo(0, 0);
  var page = pages[currentPage - 1];
  if(!page) return;
  
  if(page.type == "image") {
    document.querySelector("#gallery #video").classList.add("hidden");
    document.querySelector("#gallery #image").classList.remove("hidden");
    document.querySelector("#gallery #image").src = page.url;
  }
  else {
    document.querySelector("#gallery #image").classList.add("hidden");
    document.querySelector("#gallery #video").classList.remove("hidden");
    document.querySelector("#gallery #video").src = page.url;
  }

  //if(currentPage < imageUrls.length) (new Image()).src = imageUrls[currentPage];
}

function openLink(event) {
  event.preventDefault();

  for(var i = 0; i < pages.length; i++) {
    if(pages[i].url == this.href) {
      page(i + 1);
      return;
    }
  }
}

function initGallery() {
  if(!document.querySelector("#gallery")) return;

  initPaginator();
  loadPages();

  document.body.addEventListener("click", function(e) {
    console.log("clicked, e: ", e);
    if(e.target && e.target.matches("a.viewable")) openLink.call(e.target, e);
  });

  page(1);
}

window.addEventListener("DOMContentLoaded", initGallery);