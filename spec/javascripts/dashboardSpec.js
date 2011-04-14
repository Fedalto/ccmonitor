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
  
}); 

