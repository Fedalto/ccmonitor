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
      build_type = specs.build_type,
      recent = specs.recent,
      time_since_green = specs.time_since_green,
      buildUrl = specs.buildUrl,
      assignUrl = specs.assignUrl,
      assignedTo = specs.assignedTo,
      element = null,
      api = {};

  function refreshPlacement() {
    api.element().appendTo(dashboard.containers[state]());
  }  

  api.build_type = function () { return build_type; };
  api.recent = function () { return recent; };
  api.time_since_green = function () { return time_since_green; };

  api.state = function (newState) { 
    if (newState === undefined) {
      return state;
    }
    api.element().removeClass(state);
    state = newState || state; 
    api.element().addClass(state);
    refreshPlacement();
    return state;
  };

  api.element = function () {
    element = element || $("<div/>", { 'class': state }).addClass("cell").addClass(build_type); 
    element.empty();

    state === 'failure' && element.append($('<div>', { 'class': 'rightAlign' })
      .append($('<a>', { 
        href: assignUrl,
        target: "_blank",
        html: assignedTo
      }))
    );

    state === 'success' && element.append($('<div>', { 'class': 'rightAlign' })
      .append($('<a>', { 
        html: "-"
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
        html: build_type
      }))
    );

    recent === 'true' && element.addClass("recent");

    var max_time = 172800;

    var ra = Math.floor(time_since_green / (max_time / 160));
    var ga = Math.floor(time_since_green / (max_time / 40));
    var ba = Math.floor(time_since_green / (max_time / 40));
    state === 'failure' && element.css('background', 'rgb(' + (160-ra) + ',' + (40-ga) + ',' + (40-ba) + ')')

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
    cells = [];
    dashboard.containers.clear();
  }
  
  function process (cell) {
    if (cell.recent() === true) {
      $("#" + cell.state() + "_sound").trigger("play");
    }
  }

  function populateCells(input) {
    resetState();
    var json = $.parseJSON(input);
    $(json.projects).each(function (index, project) {
      var cell = createCell(project);
      process(cell);
      cells.push(cell);
    });
  }
  
  api.cells = function () { return cells; };
  api.oldCells = function () { return oldCells; };
  api.refresh = function () { ajax.get(uris.refresh, populateCells); };

  api.refresh();

  return api;
};
