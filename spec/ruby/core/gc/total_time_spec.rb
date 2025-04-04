require_relative '../../spec_helper'

describe "GC.total_time" do
  it "returns an Integer" do
    GC.total_time.should be_kind_of(Integer)
  end

  it "increases as collections are run" do
    time_before = GC.total_time
    GC.start
    GC.total_time.should >= time_before
  end
end
