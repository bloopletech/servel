var Listing = (function() {
  var $;
  var $container;
  var perPage = 99;
  var currentIndex = 0;
  var moreContent = true;
  var scrollDebounce = false;

  function escapeHTML(unsafe) {
    if(unsafe == null) return "";
    return unsafe.toString()
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function HTMLSafe(pieces) {
    var result = pieces[0];
    var substitutions = [].slice.call(arguments, 1);
    for(var i = 0; i < substitutions.length; ++i) result += escapeHTML(substitutions[i]) + pieces[i + 1];
    return result;
  }

  function renderRow(file) {
    return HTMLSafe`
      <tr>
        <td class="name">
          <span class="icon">${file.icon}</span>
          <a href="${file.href}" class="default ${file.class}" data-url="${file.href}" data-type="${file.media_type}">${file.name}</a>
        </td>
        <td class="new-tab">
          <a href="${file.href}" class="new-tab ${file.class}" target="_blank">(New tab)</a>
        </td>
        <td class="type">${file.type}</td>
        <td class="size">${file.size}</td>
        <td class="modified">${file.mtime}</td>
      </tr>
    `;
  }

  function renderTable(currentEntries) {
    var rows = currentEntries.map(function(entry) {
      return renderRow(entry);
    });

    return `
      <table>
        <tbody>
          ${rows.join("")}
        </tbody>
      </table>
    `;
  }

  function render() {
    var currentEntries = entries.slice(currentIndex, currentIndex + perPage);
    $container.insertAdjacentHTML("beforeend", renderTable(currentEntries));
  }

  function atBottom() {
    return (window.scrollY + window.innerHeight) == document.body.scrollHeight;
  }

  function onScrolled() {
    if(atBottom() && moreContent) {
      currentIndex += perPage;
      if(currentIndex >= entries.length) moreContent = false;
      render();
    }
    scrollDebounce = false;
  }

  function applySort(sortable) {
    var previousSortable = $("th.sortable.sort-active");
    previousSortable.classList.remove("sort-active", "sort-asc", "sort-desc");

    if(sortable == previousSortable) {
      sortable.dataset.sortDirection = sortable.dataset.sortDirection == "asc" ? "desc" : "asc";
    }

    sortable.classList.add("sort-active", "sort-" + sortable.dataset.sortDirection);

    Index.loadEntries();
  }

  function initEvents() {
    window.addEventListener("scroll", function(e) {
      if(!scrollDebounce) {
        scrollDebounce = true;
        setTimeout(onScrolled, 0);
      }
    });

    document.body.addEventListener("click", function(e) {
      if(!e.target) return;

      if(e.target.closest("th.sortable")) {
        e.preventDefault();
        applySort(e.target.closest("th.sortable"));
      }
    });
  }

  function onEntriesInit() {
    onEntriesUpdate();
    $("#listing").style.display = "block";
    initEvents();
  }

  function onEntriesUpdate() {
    $container.innerHTML = "";

    currentIndex = 0;
    moreContent = true;
    render();
  }

  window.addEventListener("DOMContentLoaded", function() {
    $ = document.querySelector.bind(document);
    $container = $("#listing-container");
  });

  return {
    onEntriesInit: onEntriesInit,
    onEntriesUpdate: onEntriesUpdate
  };
})();
