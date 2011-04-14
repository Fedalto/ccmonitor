var dashboard = {};

dashboard.state = (function () {
  return {
    failure: "failure",
    success: "success"
  };
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

  api.state = function (newState) { 
    api.element().removeClass(state);
    state = newState || state; 
    api.element().addClass(state);
    api.element().appendTo(dashboard.containers[state]());
    return state;
  };

  api.element = function () {
    return element = element || $("<div/>", { 'class': state }).addClass("cell"); 
  };

  return api;
};

dashboard.manager = function (specs) {
  var api = {},
      ajax = specs.ajax || dashboard.ajax, //improve this
      uris = specs.uris || {refresh: "/all" }; //improve this

  api.cells = function () { return specs.ajax.get(uris.refresh).projects; };
  api.refresh = function () { ajax.get(uris.refresh); };

  return api;
};
