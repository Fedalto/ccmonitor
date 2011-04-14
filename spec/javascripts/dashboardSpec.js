var sandbox = (function () {
  var api = {};
  api.create = function () { $('body').append($("<div>", {id:"sandbox", "class":"sandbox"})); };
  api.container = function () { return $("#sandbox"); };
  api.destroy = function () { api.container().remove(); };
  api.createWithContainers = function () {
    api.create();
    api.container().append($('<div>', {id:'success_box', 'class': 'success_box'})).
                    append($('<div>', {id:'failure_box', 'class': 'failure_box'}));
  };

  return api;
}());

describe("the statuses", function () {
  it("should have the failure state", function () {
    expect(dashboard.state.failure).toEqual("failure");
  });

  it("should have the success state", function () {
    expect(dashboard.state.success).toEqual("success");
  });
});

describe("the containers", function () {
  beforeEach(sandbox.createWithContainers);
  afterEach(sandbox.destroy);

  it('should point to the success container', function () {
    expect(dashboard.containers.success().attr('id')).toEqual('success_box');
    expect(dashboard.containers.success().attr('tagName')).toEqual('DIV');
  });

  it('should point to the failure container', function () {
    expect(dashboard.containers.failure().attr('id')).toEqual('failure_box');
    expect(dashboard.containers.failure().attr('tagName')).toEqual('DIV');
  });
});

describe("a cell", function () {
  var cell;

  afterEach(sandbox.destroy);
  
  beforeEach(function () {
    sandbox.createWithContainers();
    cell = dashboard.cell({project: 'AwesomeProject', state: dashboard.state.failure});
  });

  it("should know its project and state", function () {
    expect(cell.project()).toEqual('AwesomeProject');
    expect(cell.state()).toEqual(dashboard.state.failure);
  });
  
  it("should move itself to the correct container at creation time", function () {
    expect(cell.element().parent().attr("id")).toEqual("failure_box");
  });
  
  it("should create a html element to represent itself", function () {
    expect(cell.element()).not.toBeNull();
    expect(cell.element().attr("tagName")).toEqual("DIV");
    expect(cell.element().attr("class")).toMatch(cell.state());
    expect(cell.element().attr("class")).toMatch("cell");
  });

  it("should create a single element", function () {
    var element1 = cell.element();
    var element2 = cell.element();

    expect(element2).toBe(element1);
  });

  it("should update element class when state changes", function () {
    cell.state(dashboard.state.success);
    expect(cell.element().attr("class")).toMatch(dashboard.state.success);
    expect(cell.element().attr("class")).toMatch("cell");
    cell.state(dashboard.state.failure);
    expect(cell.element().attr("class")).toMatch(dashboard.state.failure);
    expect(cell.element().attr("class")).toMatch("cell");
  });

  it("should move itself to the success container when changing state to success", function () {
    cell.state(dashboard.state.success);
    expect(dashboard.containers.success().find('.cell').size()).toEqual(1);
    expect(dashboard.containers.failure().find('.cell').size()).toEqual(0);
  });

  it("should move itself to the failure container when changing state to failure", function () {
    cell.state(dashboard.state.failure);
    expect(dashboard.containers.failure().find('.cell').size()).toEqual(1);
    expect(dashboard.containers.success().find('.cell').size()).toEqual(0);
  });
  
}); 

describe("manager", function () {
  var marco, json, ajaxStub, ajaxMock;

  afterEach(sandbox.destroy);

  beforeEach(function () {
    sandbox.createWithContainers();
    json = {projects: [
      {name: "Awesome Project", state: dashboard.state.success},
      {name: "Fun Project", state: dashboard.state.failure},
      {name: "Great Project", state: dashboard.state.success},
      {name: "Interesting Project", state: dashboard.state.failure}
    ]};
    ajaxMock = { get: function () { return json; } };
    marco = dashboard.manager({ajax: ajaxMock});
  });

  it("should manage to create a collection of cells according to input", function () {
    expect(marco.cells().length).toEqual(4);
  });

  it("should manager delegate the refresh action to the ajax service", function () {
    marco = dashboard.manager({ajax: ajaxMock, uris: {refresh: "/refreshment"}});
    spyOn(ajaxMock, "get").andCallThrough();

    marco.refresh();

    expect(ajaxMock.get).toHaveBeenCalledWith("/refreshment");
  });

  it("should create the cells using the ajax response", function () {
    marco = dashboard.manager({ajax: ajaxMock, uris: {refresh: "/refreshment"}});

    expect(marco.cells()[0].project()).toEqual("Awesome Project");
  });

});
