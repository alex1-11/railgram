require 'rails_helper'

RSpec.describe "comments/new", type: :view do
  before(:each) do
    assign(:comment, Comment.new(
      text: "MyString",
      user: nil,
      post: nil
    ))
  end

  it "renders new comment form" do
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do

      assert_select "input[name=?]", "comment[text]"

      assert_select "input[name=?]", "comment[user_id]"

      assert_select "input[name=?]", "comment[post_id]"
    end
  end
end
