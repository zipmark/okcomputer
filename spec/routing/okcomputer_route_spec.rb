require "spec_helper"

describe OKComputer do
  it "routes the simple check as text" do
    pending "got routes working, now to get the specs to pass"
    {get: "/"}.should route_to({
      controller: "ok_computer",
      action: "show",
      check: "default",
      format: "text",
    })
  end

  it "routes the simple check as JSON"

  it "routes all checks as text"

  it "routes all checks as JSON"

  it "routes a specific check as text"

  it "routes a specific check as JSON"
end
