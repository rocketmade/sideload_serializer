require 'spec_helper'

RSpec.describe SideloadSerializer::CamelizedAttributesAdapter do
  let(:artist) { SpecArtist.new(1, 'George Ezra') }
  let(:songs) do
    i = 0
    ['Blame It on Me', 'Budapest', 'Cassy O'].map do |name|
      i+=1
      SpecSong.new i, name, artist
    end
  end

  let!(:album) do
    a = SpecAlbum.new 1, 'Wanted On Voyage', artist, songs
    a.songs.each do |s|
      s.album = a
    end

    a
  end

  let(:serializer) { SpecAlbumSerializer.new(album) }
  let(:include_string) { '*' }
  let(:adapter) { described_class.new serializer, include: include_string }
  let(:serializable_hash) { adapter.serializable_hash.with_indifferent_access }
  let(:json_hash) { adapter.as_json.with_indifferent_access }
  let(:json) { adapter.to_json }

  it "serializes the main object as attributes would but camelized" do
    expect(serializable_hash).to have_key :songs
  end
end
