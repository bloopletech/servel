"use strict";

var Entries = (function() {
  //Lists
  var all;
  var media;
  var hasMedia;

  var sortMethod = "name";
  var sortDirection = "asc";
  var filterText = "";

  function runFilter(entries) {
    if(filterText == "") return entries;

    var filteredEntries = [];

    for(var i = 0; i < entries.length; i++) {
      var entry = entries[i];
      if(entry.name.toLowerCase().includes(filterText.toLowerCase())) filteredEntries.push(entry);
    }

    return filteredEntries;
  }

  function sortByName(a, b) {
    var aName = a.name.toLowerCase();
    var bName = b.name.toLowerCase();

    if(aName < bName) return -1;
    if(aName > bName) return 1;

    return 0;
  }

  function sortByMtime(a, b) {
    return b.mtime - a.mtime;
  }

  function sortBySize(a, b) {
    return b.size - a.size;
  }

  function sortByType(a, b) {
    var aType = a.type.toLowerCase();
    var bType = b.type.toLowerCase();

    if(aType < bType) return -1;
    if(aType > bType) return 1;

    return 0;
  }

  function runSort(entries) {
    var sortFunction;
    if(sortMethod == "name") sortFunction = sortByName;
    else if(sortMethod == "mtime") sortFunction = sortByMtime;
    else if(sortMethod == "size") sortFunction = sortBySize;
    else if(sortMethod == "type") sortFunction = sortByType;

    entries.sort(sortFunction);
    if(sortDirection == "desc") entries.reverse();
  }

  function updateLists() {
    specialEntries = window.specialEntries.slice();
    directoryEntries = runFilter(window.directoryEntries.slice());
    fileEntries = runFilter(window.fileEntries.slice());

    runSort(directoryEntries);
    runSort(fileEntries);

    all = [].concat(specialEntries, directoryEntries, fileEntries);

    media = [];
    for(var i = 0; i < fileEntries.length; i++) {
      if(fileEntries[i].media) media.push(fileEntries[i]);
    }

    hasMedia = media.length > 0;
  }

  function update() {
    updateLists();
    Gallery.onEntriesUpdate();
    Listing.onEntriesUpdate();
  }

  function sort(newSortMethod, newSortDirection) {
    sortMethod = newSortMethod;
    sortDirection = newSortDirection;
    update();
  }

  function filter(newFilterText) {
    filterText = newFilterText;
    update();
  }

  updateLists();

  return {
    all: function() {
      return all;
    },
    media: function() {
      return media;
    },
    hasMedia: function() {
      return hasMedia;
    },
    filter: filter,
    sort: sort
  };
})();