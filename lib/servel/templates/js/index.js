"use strict";

var Index = (function() {
  var $;
  var inited = false;

  function entriesURL() {
    var sortable = $("th.sortable.sort-active");
    return `${location.pathname}?_servel_sort_method=${sortable.dataset.sortMethod}&_servel_sort_direction=${sortable.dataset.sortDirection}`;
  }

  function onEntriesLoad() {
    if(inited) {
      Gallery.onEntriesUpdate();
      Listing.onEntriesUpdate();
    }
    else {
      inited = true;
      Gallery.onEntriesInit();
      Listing.onEntriesInit();
    }

    $("#loading").style.display = "none";
  }

  function loadEntries() {
    $("#loading").style.display = "flex";

    var http = new XMLHttpRequest();
    http.open("GET", entriesURL());

    http.onreadystatechange = function() {
      if(http.readyState === 4 && http.status === 200) {
        window.entries = JSON.parse(http.responseText);
        setTimeout(onEntriesLoad, 0);
      }
    };

    http.setRequestHeader("Accept", "application/json");
    http.send();
  }

  window.addEventListener("DOMContentLoaded", function() {
    $ = document.querySelector.bind(document);
    loadEntries();
  });

  return {
    loadEntries: loadEntries
  };
})();
