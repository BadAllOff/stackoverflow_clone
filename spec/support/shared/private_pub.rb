shared_examples_for "Private_pub" do
  it "should publish after" do
    expect(PrivatePub).to receive(:publish_to).with(channel, kind_of(Hash))
    object
  end
end