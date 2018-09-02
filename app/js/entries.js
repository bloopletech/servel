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

  function sortByName(entries) {
    return naturalOrderBy.orderBy(entries, function(entry) {
      return entry.name.toLowerCase();
    }, sortDirection);
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
    if(sortMethod == "name") return sortByName(entries);

    var sortFunction;
    if(sortMethod == "mtime") sortFunction = sortByMtime;
    else if(sortMethod == "size") sortFunction = sortBySize;
    else if(sortMethod == "type") sortFunction = sortByType;

    entries.sort(sortFunction);
    if(sortDirection == "desc") entries.reverse();

    return entries;
  }

  function updateLists() {
    specialEntries = window.specialEntries.slice();
    directoryEntries = runSort(runFilter(window.directoryEntries.slice()));
    fileEntries = runSort(runFilter(window.fileEntries.slice()));

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