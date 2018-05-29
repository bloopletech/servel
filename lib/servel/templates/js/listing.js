function initListing() {
  $ = document.querySelector.bind(document);

  function applySort(sortable) {
    var params = new URLSearchParams(location.search.slice(1));
    params.set("_servel_sort_method", sortable.dataset.sortMethod);
    params.set("_servel_sort_direction", sortable.dataset.sortDirection);

    if('sortActive' in sortable.dataset) {
      params.set("_servel_sort_direction", sortable.dataset.sortDirection == "asc" ? "desc" : "asc");
    }

    location.href = location.pathname + "?" + params.toString();
  }

  document.body.addEventListener("click", function(e) {
    if(!e.target) return;

    if(e.target.closest("th.sortable")) {
      e.preventDefault();
      applySort(e.target.closest("th.sortable"));
    }
  });
}

window.addEventListener("DOMContentLoaded", initListing);