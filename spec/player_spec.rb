require 'spec_helper'

describe Player do

  it { is_expected.to respond_to(:choose).with(1).argument }

  describe 'choose' do
    it 'changes choice to the players choice' do
      subject.choose('rock')
      expect(subject.choice).to eq 'rock'
    end

    it 'knows that a choice hasnt yet been made' do # have a go at passing these tests
      expect(subject).not_to have_chosen
    end

    it 'raises an error if player has not yet made a choice' do
      expect { subject.choice }.to raise_error 'Player has not yet made a choice'
    end
  end
end
