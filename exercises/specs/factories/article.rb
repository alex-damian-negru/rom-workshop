Factory.define :article do |f|
  f.title { fake(:name) }
  f.published true
end
