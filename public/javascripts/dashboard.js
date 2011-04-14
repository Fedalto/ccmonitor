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
  return {
    failure: function () { return $("#failure_box"); },
    success: function () { return $("#success_box"); }
  };
}());

dashboard.cell = function (specs) {
  var state = specs.state, 
      project = specs.project,
      element = null,
      api = {};

  api.project = function () { return project; };
  
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
    return element = element || $("<div/>", { 'class': state }).addClass("cell"); 
  };

  refreshPlacement();

  return api;
};

dashboard.manager = function (specs) {
  var api = {},
      ajax = specs.ajax || dashboard.ajax, //improve this
      uris = specs.uris || {refresh: "/all" },
      cells = []; 

  function createCell(project) {
    return dashboard.cell({project: project.name, state: project.state});
  }

  function populateCells(json) {
    cells = [];
    $(json.projects).each(function (index, project) {
      cells.push(createCell(project));
    });
  }
  
  api.cells = function () { return cells; };
  api.refresh = function () { ajax.get(uris.refresh, populateCells); };

  api.refresh();

  return api;
};

