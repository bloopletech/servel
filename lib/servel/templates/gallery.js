var currentPage = 1;

function page(index) {
  if(arguments.length == 1) {
    if(isNaN(index) || index < 1) index = 1;
    if(index > imagePaths.length) index = imagePaths.length;
    
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
  document.querySelector("#image").src = imagePaths[currentPage - 1];
  if(currentPage < imagePaths.length) (new Image()).src = imagePaths[currentPage];
}

function init() {
  initPaginator();
  showCurrentPage();
}

window.addEventListener("DOMContentLoaded", init);