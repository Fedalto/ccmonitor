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
    cell = dashboard.cell({name: 'AwesomeProject', state: dashboard.state.failure, 'type': 'quick', 'buildUrl': 'someUrl'});
  });

  it("should know its project and state", function () {
    expect(cell.project()).toEqual('AwesomeProject');
    expect(cell.state()).toEqual(dashboard.state.failure);
  });

  it("should know its type", function () {
    expect(cell.type()).toEqual('quick');
  });

  it("should know the project build page", function () {
    expect(cell.buildUrl()).toEqual('someUrl');
  });

  it("should contain a header with the project name", function () {
    expect(cell.element().find('h4').html()).toEqual(cell.project());
  });

  it("should contain a header with the build type", function () {
    expect(cell.element().find('h5').size()).toEqual(1);
    expect(cell.element().find('h5').html()).toEqual(cell.type());
  });
  
  it("should move itself to the correct container at creation time", function () {
    expect(cell.element().parent().attr("id")).toEqual("failure_box");
  });
  
  it("should create a html element to represent itself", function () {
    expect(cell.element()).not.toBeNull();
    expect(cell.element().attr("tagName")).toEqual("DIV");
    expect(cell.element().attr("class")).toMatch(cell.state());
    expect(cell.element().attr("class")).toMatch("cell");
    expect(cell.element().children('a')[0].href).toMatch(cell.buildUrl());
    expect(cell.element().children('a')[0].innerHTML).toMatch("<h4>" + cell.project() + "</h4>");
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
    json = '{"projects": [' + 
      '{"name": "Awesome Project", "state": "success", "type": "quick"}, ' +
      '{"name": "Fun Project", "state": "success", "type": "quick"}, ' +
      '{"name": "Great Project", "state": "success", "type": "metrics"}, ' +
      '{"name": "Interesting Project", "state": "failure", "type": "package"} ' +
    ']}';
    ajaxMock = { get: function (url, callback) { callback(json); } };
    marco = dashboard.manager({ajax: ajaxMock});
  });

  it("should manage to create a collection of cells according to input", function () {
    expect(marco.cells().length).toEqual(4);
  });

  it("should clear the cell list when refreshing", function () {
    marco = dashboard.manager({ajax: ajaxMock, uris: {refresh: "/refreshment"}});
    expect(marco.cells().length).toEqual(4);
    marco.refresh();
    expect(marco.cells().length).toEqual(4);
  });

  it("should clear the containers when refreshing", function () {
    dashboard.containers.success().append($('<br>'));
    dashboard.containers.failure().append($('<br>'));

    marco.refresh();

    expect(dashboard.containers.success().find('br').length).toEqual(0);
    expect(dashboard.containers.failure().find('br').length).toEqual(0);
  });

  it("should create the cells using the ajax response", function () {
    marco = dashboard.manager({ajax: ajaxMock, uris: {refresh: "/refreshment"}});

    expect(marco.cells()[0].project()).toEqual("Awesome Project");
    expect(marco.cells()[0].type()).toEqual("quick");
  });

});
