require "spec_helper"

class StringSet

  def initialize(param=[])
    @set = param
  end

  def contains?(word)
    @set.collect(&:downcase).include? word.downcase
  end

  def empty!
    @set = []
  end

  def intersect(wordset)
    set = StringSet.new
    @set.each do |var|
      if wordset.contains? var
        set.add var
      end
    end
    set
  end

  def union(wordset)
    set = wordset.clone
    @set.each { |var| set.add(var) }
    set
  end

  def add(word)
    unless self.contains? word
      @set << word
    end
  end

  def remove(word)
    @set.delete(word)
  end

  def count
    @set.size
  end

  def to_s
    "#{self.class}: {#{ @set.collect { |s| "'#{s}'" }.join(', ') }}"
  end
end

describe StringSet do

  it "should initalize with default values" do
    s = StringSet.new(['a', 'b'])
    s.contains?('a').should be_true
    s.contains?('b').should be_true
  end

  it "should check if the set contains a string" do
    subject.contains?("string").should be_false
  end

  it "should add a string to the set" do
    subject.add("julianachata")
    subject.contains?("julianachata").should be_true
  end

  it "should add two strings to the set" do
    subject.add("brunno")
    subject.add("jessica")
    subject.contains?("brunno").should be_true
    subject.contains?("jessica").should be_true
  end

  it "should not add duplicated elements" do
    subject.add("brunno")
    subject.add("brunno")
    subject.count.should == 1
  end

  it "should remove elements" do
    subject.add "brunno"
    expect {
      subject.remove "brunno"
    }.should change(subject, :count).by(-1)
  end

  it "should empty set" do
    subject.add "casa"
    subject.add "pc"
    expect {
      subject.empty!
    }.should change(subject, "count").by(-2)
  end

  it "should intersect two sets" do
    s = StringSet.new
    s.add("ximbica")
    subject.add("ruby")
    subject.add("ximbica")
    subject.intersect(s).contains?("ximbica").should be_true
  end

  it "should count correctly when intersecting sets" do
    s = StringSet.new
    s.add("ximbica")
    subject.add("ruby")
    subject.add("ximbica")
    subject.intersect(s).count.should == 1
  end

  it "should count correctly when joining sets" do
    s = StringSet.new
    s.add("ximbica")
    subject.add("ruby")
    subject.add("ximbica")
    subject.union(s).count.should == 2
  end

  it "should join two sets" do
    s = StringSet.new
    s.add("ximbica")
    subject.add("ruby")
    subject.add("ximbica")
    joined_set = subject.union(s)
    joined_set.contains?("ximbica").should be_true
    joined_set.contains?("ruby").should be_true
  end

  it "should generate string" do
    subject.add("brunnocabuloso")
    subject.add("revenge")
    subject.to_s.should == "StringSet: {'brunnocabuloso', 'revenge'}"
  end

  it "should not be case-sensitive" do
    subject.add("brunno")
    subject.contains?("Brunno").should be_true
  end
end
