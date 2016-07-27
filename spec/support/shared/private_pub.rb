shared_examples_for 'Publishable' do
  it 'should publish after' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    object
  end
end
