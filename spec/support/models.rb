
SpecAlbum = Struct.new(:id, :name, :artist, :songs) do
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  def attributes
    { id: id, name: name }
  end
end

SpecSong = Struct.new(:id, :name, :artist, :album) do
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  def attributes
    { id: id, name: name }
  end
end

SpecArtist = Struct.new(:id, :name) do
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  def attributes
    { id: id, name: name }
  end
end
