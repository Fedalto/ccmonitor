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
      project = specs.project,
      type = specs.type,
      element = null,
      api = {};

  api.project = function () { return project; };
  api.type = function () { return type; };
  
  function refreshPlacement() {
    api.element().appendTo(dashboard.containers[state]());
  }  

  api.state = function (newState) { 
    api.element().removeClass(state);
    state = newState || state; 
    api.element().addClass(state);
    refreshPlacement();
    return state;
  };

  api.element = function () {
    element = element || $("<div/>", { 'class': state }).addClass("cell"); 
    element.empty();
    element.append($('<h4>', {'html': project}));
    element.append($('<h5>', {'html': type}));
    return element;
  };

  refreshPlacement();

  return api;
};

dashboard.manager = function (specs) {
  var api = {},
      config = specs || {}
      ajax = config.ajax || dashboard.ajax,
      uris = config.uris || {refresh: "/all_projects" },
      cells = []; 

  function createCell(project) {
    return dashboard.cell({project: project.name, state: project.state, type: project.type});
  }

  function resetState() {
    cells = [];
    dashboard.containers.clear();
  }

  function populateCells(input) {
    resetState();
    var json = $.parseJSON(input);
    $(json.projects).each(function (index, project) {
      cells.push(createCell(project));
    });
  }
  
  api.cells = function () { return cells; };
  api.refresh = function () { ajax.get(uris.refresh, populateCells); };

  api.refresh();

  return api;
};
