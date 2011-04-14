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

describe("containers", function () {
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

