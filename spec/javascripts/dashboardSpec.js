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
  var recent_cell;

  afterEach(sandbox.destroy);
  
  beforeEach(function () {
    sandbox.createWithContainers();
    cell = dashboard.cell({name: 'AwesomeProject', state: dashboard.state.failure, 'activity': 'sleeping', 'build_type': 'quick', 'buildUrl': 'someUrl', 'recent': false, 'time_since_green':172800, 'assignedTo': 'person', 'assignUrl': 'assignUrl'});
    building_cell = dashboard.cell({name: 'OtherProject', state: dashboard.state.failure, 'activity': 'building', 'build_type': 'quick', 'buildUrl': 'someUrl', 'recent': false, 'time_since_green':172800});
    recent_cell = dashboard.cell({name: 'BetterProject', state: dashboard.state.failure, 'activity': 'sleeping', 'build_type': 'quick', 'buildUrl': 'someUrl', 'recent': true, 'time_since_green':0, 'assignedTo': 'person', 'assignUrl': 'assignUrl'});
  });

  it("should have a activity attribute", function () {
    expect(cell.activity()).toEqual('sleeping');
    expect(building_cell.activity()).toEqual('building');
  });

  it("should have a recent attribute", function () {
    expect(cell.recent()).toEqual(false);
    expect(recent_cell.recent()).toEqual(true);
  });

  it("should have a build type", function () {
    expect(cell.build_type()).toEqual("quick");
  });
  
  it("should have a time_since_green attribute", function () {
    expect(cell.time_since_green()).toEqual(172800);
    expect(recent_cell.time_since_green()).toEqual(0);
  });

  it("should not contain a recent class if the build is not recent", function () {
    expect(cell.element().attr("class")).not.toMatch("recent");
  });

  it("should contain a building class if and only if the build is building", function () {
    expect(cell.element().attr("class")).not.toMatch("building");
    expect(building_cell.element().attr("class")).toMatch("building");
  });
  
  it("should contain a recent class if the build is recent", function () {
    expect(recent_cell.element().attr("class")).toMatch("recent");
  });

  it("should contain a header with the project name", function () {
    expect(cell.element().find('h4').html()).toEqual("AWESOMEPROJECT");
  });

  it("should contain a header with the build type", function () {
    expect(cell.element().find('h5').size()).toEqual(1);
    expect(cell.element().find('h5').html()).toEqual("quick");
  });

  it("should contain the name of the project as a link the build page", function () {
    expect(cell.element().find('a')[1].href).toMatch("someUrl");
    expect(cell.element().find('a')[1].innerHTML).toMatch("<h4>" + "AWESOMEPROJECT" + "</h4>");
  });

  it("should contain a link to the assign page", function () {
    expect(cell.element().find('a')[0].href).toMatch('assignUrl');
    expect(cell.element().find('a')[0].innerHTML).toMatch('person');
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
    expect(dashboard.containers.failure().find('.cell').size()).toEqual(2);
  });

  it("should move itself to the failure container when changing state to failure", function () {
    cell.state(dashboard.state.failure);
    expect(dashboard.containers.failure().find('.cell').size()).toEqual(3);
    expect(dashboard.containers.success().find('.cell').size()).toEqual(0);
  });
  
}); 

describe("manager", function () {
  var marco, json, ajaxStub, ajaxMock;

  afterEach(sandbox.destroy);

  beforeEach(function () {
    sandbox.createWithContainers();
    json = '{"projects": [' + 
      '{"name": "Awesome Project", "state": "success", "build_type": "quick"}, ' +
      '{"name": "Fun Project", "state": "success", "build_type": "quick"}, ' +
      '{"name": "Great Project", "state": "success", "build_type": "metrics"}, ' +
      '{"name": "Interesting Project", "state": "failure", "build_type": "package"} ' +
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

    expect(marco.cells().length).toEqual(4);
  });

});
