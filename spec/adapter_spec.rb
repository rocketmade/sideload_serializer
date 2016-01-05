require 'active_model'
require 'active_model_serializers'
require 'sideload_serializer/adapter'
require 'pry'

SpecAlbum = Struct.new(:id, :name, :artist, :songs) do
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  def attributes
    { id: id, name: name }
  end

  def updated_at
    DateTime.now
  end
end

SpecSong = Struct.new(:id, :name, :artist, :album) do
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  def attributes
    { id: id, name: name }
  end

  def updated_at
    DateTime.now
  end
end

SpecArtist = Struct.new(:id, :name) do
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  def attributes
    { id: id, name: name }
  end
  def updated_at
    DateTime.now
  end
end

class SpecAlbumSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :songs
  has_one :artist
end

class SpecSongSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :album
  has_one :artist
end

class SpecArtistSerializer < ActiveModel::Serializer
  attributes :id, :name
end

RSpec.describe SideloadSerializer::Adapter do
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
  let(:include_string) { '**' }
  let(:adapter) { SideloadSerializer::Adapter.new serializer, include: include_string }
  let(:serializable_hash) { adapter.serializable_hash.with_indifferent_access }
  let(:json_hash) { adapter.as_json.with_indifferent_access }
  let(:json) { adapter.to_json }
  let(:serialized_album) { json_hash[:spec_albums].first }

  it "serializes the main object in a collection" do
    expect(serializable_hash).to have_key :spec_songs
    expect(serializable_hash[:spec_songs]).to be_a Array
  end

  it "includes meta data to identify the primary object" do
    expect(json_hash).to have_key :meta
    expect(json_hash[:meta]).to have_key :primary_resource_collection
    expect(json_hash[:meta]).to have_key :primary_resource_id
    expect(json_hash[:meta][:primary_resource_collection].to_s).to eq 'spec_albums'
    expect(json_hash[:meta][:primary_resource_id]).to eq 1
  end

  it "embeds ids for associations" do
    expect(serialized_album).to have_key :song_ids
    expect(serialized_album).to have_key :artist_id
    expect(serialized_album[:song_ids]).to be_a Array
  end

  it "includes associations" do
    expect(json_hash).to have_key :spec_artists
    expect(json_hash).to have_key :spec_songs
  end

  it "gives only one copy of each record" do
    expect(json_hash[:spec_albums].length).to eq 1
    expect(json_hash[:spec_artists].length).to eq 1
    expect(json_hash[:spec_songs].length).to eq songs.length
  end

  context "when inclusions are turned off" do
    let(:include_string) { '' }

    it "does not include any associations" do
      expect(json_hash).not_to have_key :spec_artists
      expect(json_hash).not_to have_key :spec_songs
    end

    it "does not include the id parameters for the associations" do
      expect(serialized_album).not_to have_key :song_ids
      expect(serialized_album).not_to have_key :artist_id
    end
  end
end
