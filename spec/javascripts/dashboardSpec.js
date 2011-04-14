var sandbox = (function () {
  var api = {};
  api.create = function () { $('body').append($("<div>", {id:"sandbox", "class":"sandbox"})); };
  api.container = function () { return $("#sandbox"); };
  api.destroy = function () { api.container().remove(); };

  return api;
}());

describe("containers", function () {
  beforeEach(function () {
    sandbox.create();
    sandbox.container().append($('<div>', {id:'success_box', 'class': 'success_box'}));
    sandbox.container().append($('<div>', {id:'failure_box', 'class': 'failure_box'}));
  });
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

  beforeEach(function () {
    cell = dashboard.cell({project: 'AwesomeProject', state: dashboard.state.failure});
  });

  it("should know its project and state", function () {
    expect(cell.project()).toEqual('AwesomeProject');
    expect(cell.state()).toEqual(dashboard.state.failure);
  });
  
  it("should create a html element to represent itself", function () {
    expect(cell.element()).not.toBeNull();
    expect(cell.element().attr("tagName")).toEqual("DIV");
    expect(cell.element().attr("class")).toEqual(cell.state());
  });

  it("should create a single element", function () {
    var element1 = cell.element();
    var element2 = cell.element();

    expect(element2).toBe(element1);
  });

  it("should update element class when state changes", function () {
    cell.state(dashboard.state.success);
    expect(cell.element().attr("class")).toEqual(dashboard.state.success);
    cell.state(dashboard.state.failure);
    expect(cell.element().attr("class")).toEqual(dashboard.state.failure);
  });

  it("should move itself to the failure container when changing state to failure", function () {
  });
  
}); 

