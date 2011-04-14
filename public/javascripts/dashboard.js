var dashboard = {};

dashboard.state = (function () {
  return {
    failure: "failure",
    success: "success"
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
    return state;
  };
  api.element = function () {
    return element = element || $("<div/>", { 'class': state }); 
  };

  return api;
};
