require 'spec_helper'

# Monkey-patch to allow resetting state
class Roster
  def reset
    @roster = {}
  end
end

describe Roster do
  before :each do
    Roster.reset
  end

  describe '#update_presence_for' do
    it 'should take a string JID as input' do
      Roster.update_presence_for 'lpradovera@mojolingo.com/broken_macbook_pro', :available
      Roster.presence_for('lpradovera@mojolingo.com').should be :available
    end

    it 'should not allow a string JID that is lacking a resource' do
      expect { Roster.update_presence_for 'lpradovera@mojolingo.com', :available }.to raise_error
    end

    it 'should allow Blather::JID object as input' do
      jid = Blather::JID.new 'rmendoza', 'mojolingo.com', 'taikwondo'
      Roster.update_presence_for(jid, :away)
      Roster.presence_for('rmendoza@mojolingo.com').should be :away
    end
  end

  describe '#presence_for' do
    before :each do
      Roster.update_presence_for 'lgleason@mojolingo.com/tennessee', :xa
    end

    after :each do
      Roster.reset
    end

    it 'should take a string JID as input' do
      Roster.presence_for('lgleason@mojolingo.com').should be :xa
    end

    it 'should take a Blather::JID object as input' do
      jid = Blather::JID.new 'lgleason@mojolingo.com'
      Roster.presence_for(jid).should be :xa
    end

    it 'should return :available in preference to all other states' do
      Roster.update_presence_for 'lgleason@mojolingo.com/wine_cellar', :dnd
      Roster.update_presence_for 'lgleason@mojolingo.com/home', :available
      Roster.update_presence_for 'lgleason@mojolingo.com/car', :away
      Roster.update_presence_for 'lgleason@mojolingo.com/transatlantic_flight', :xa
      Roster.presence_for('lgleason@mojolingo.com').should be :available
    end

    it 'should return :away in preference to everything but :available' do
      Roster.update_presence_for 'lgleason@mojolingo.com/wine_cellar', :dnd
      Roster.update_presence_for 'lgleason@mojolingo.com/car', :away
      Roster.update_presence_for 'lgleason@mojolingo.com/transatlantic_flight', :xa
      Roster.presence_for('lgleason@mojolingo.com').should be :away
    end

    it 'should return :xa in preference to everything but :available and :away' do
      Roster.update_presence_for 'lgleason@mojolingo.com/wine_cellar', :dnd
      Roster.update_presence_for 'lgleason@mojolingo.com/transatlantic_flight', :xa
      Roster.presence_for('lgleason@mojolingo.com').should be :xa
    end

    it 'should return :dnd in preference to everything but :available, :away and :xa' do
      Roster.update_presence_for 'lgleason@mojolingo.com/tennessee', :unavailable
      Roster.update_presence_for 'lgleason@mojolingo.com/wine_cellar', :dnd
      Roster.update_presence_for 'lgleason@mojolingo.com/home', :foo
      Roster.update_presence_for 'lgleason@mojolingo.com/car', :bar
      Roster.update_presence_for 'lgleason@mojolingo.com/transatlantic_flight', :baz
      Roster.presence_for('lgleason@mojolingo.com').should be :dnd
    end
    
    it 'should return presence for a specific resource when requested' do
      Roster.update_presence_for 'lgleason@mojolingo.com/wine_cellar', :dnd
      Roster.presence_for('lgleason@mojolingo.com/wine_cellar').should be :dnd
      Roster.presence_for('lgleason@mojolingo.com/tennessee').should be :xa
    end
  end

  describe "presence helpers" do
    it 'should track state changes' do
      Roster.update_presence_for 'bklang@mojolingo.com/home', :available
      Roster.online?('bklang@mojolingo.com').should == true
      Roster.update_presence_for 'bklang@mojolingo.com/home', :unavailable
      Roster.online?('bklang@mojolingo.com').should == false
    end

    it 'should treat :available as online? and available?' do
      Roster.update_presence_for 'blangfeld@mojolingo.com/team_lime', :available
      Roster.online?('blangfeld@mojolingo.com').should == true
      Roster.available?('blangfeld@mojolingo.com').should == true
    end

    it 'should treat :away as online? but not available?' do
      Roster.update_presence_for 'brite@mojolingo.com/team_maple', :away
      Roster.online?('brite@mojolingo.com').should == true
      Roster.available?('brite@mojolingo.com').should == false
    end

    it 'should return :unavailable when requesting presence for an unseen JID' do
      Roster.presence_for('no_such_person@mojolingo.com').should be :unavailable
    end
  end
end