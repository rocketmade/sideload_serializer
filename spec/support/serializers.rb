
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
