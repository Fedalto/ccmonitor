var dashboard = {};

dashboard.state = (function () {
  return {
    failure: "failure",
    success: "success"
  };
}());

dashboard.ajax = (function () { //getting shit done
  return {
    get: function (uri, callback) { $.get(uri, null, callback); }
  }
}());

dashboard.containers = (function () {
  var api = {},
      selectors = {success: "#success_box", failure: "#failure_box"};
  api.success = function () { return $(selectors.success); };
  api.failure = function () { return $(selectors.failure); };
  api.clear = function () {
    api.success().empty();
    api.failure().empty();
  };
  return api;
}());

dashboard.cell = function (specs) {
  var state = specs.state, 
      project = specs.name,
      type = specs.type,
      buildUrl = specs.buildUrl,
      assignUrl = specs.assignUrl,
      assignedTo = specs.assignedTo,
      element = null,
      id = specs.name + specs.type
      api = {};

  function refreshPlacement() {
    api.element().appendTo(dashboard.containers[state]());
  }  

  api.id = function () { return id; };
  api.type = function () { return type; };

  api.state = function (newState) { 
    api.element().removeClass(state);
    state = newState || state; 
    api.element().addClass(state);
    refreshPlacement();
    return state;
  };

  api.element = function () {
    element = element || $("<div/>", { 'class': state }).addClass("cell").addClass(type); 
    element.empty();

    state === 'failure' && element.append($('<div>', { 'class': 'rightAlign' })
      .append($('<a>', { 
        href: assignUrl,
        target: "_blank",
        html: assignedTo
      }))
    );

    element.append($('<div>')
      .append($('<a>', { 
        href: buildUrl,
        target: "_blank"
      })
        .append($('<h4>', {
          html: project
        }))
      )
    );

    element.append($('<div>')
      .append($('<h5>', { 
        html: type
      }))
    );
    
    return element;
  };

  refreshPlacement();

  return api;
};

dashboard.manager = function (specs) {
  var api = {},
      config = specs || {}
      ajax = config.ajax || dashboard.ajax,
      startOfParams = window.location.href.indexOf('?'),
      uris = config.uris || {refresh: '/all_projects' + (startOfParams == -1 ? '' : window.location.href.slice(startOfParams))},
      cells = []; 
      oldCells = [];

  function createCell(project) {
    return dashboard.cell(project)
  }

  function resetState() {
    oldCells = cells;
    cells = [];
    dashboard.containers.clear();
  }

  function processSound (cell) {
    $.each(oldCells, function (i, val) {
      if (val.id() === cell.id()) {
        if (val.state() != cell.state()) {
          $("#" + cell.state() + "_sound").trigger("play");
        }
        return
      }
    });
  }

  function populateCells(input) {
    resetState();
    var json = $.parseJSON(input);
    $(json.projects).each(function (index, project) {
      var cell = createCell(project);
      processSound(cell);
      cells.push(cell);
    });
  }
  
  api.cells = function () { return cells; };
  api.oldCells = function () { return oldCells; };
  api.refresh = function () { ajax.get(uris.refresh, populateCells); };

  api.refresh();

  return api;
};
