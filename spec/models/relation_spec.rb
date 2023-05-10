require 'rails_helper'

RSpec.describe Relation, type: :model do
  let(:user)     { create :user }
  let(:user2)    { create :user }
  let(:relation) { Relation.new(follower: user, followed: user2) }

  it 'is a valid object' do
    expect(relation).to be_valid
    expect { relation.save }.to change(Relation, :count).by(1)
  end

  it 'can create active relation' do
    relation.save
    expect(user.active_relations.last).to eq(relation)
  end

  it 'has follow method to create active relation (follow a user)' do
    user.follow(user2)
    expect(Relation.last).to be_valid
  end
end
