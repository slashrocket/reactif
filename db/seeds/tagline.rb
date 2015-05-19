[
    { header: "you can't even", query: "I can't even" },
    { header: "your shoes are filled with spiders", query: "nope" },
    { header: "it's too hard", query: "that's what she said" },
    { header: "drama incoming", query: "popcorn" },
    { header: "shit's going down", query: "dis gon b good"}
].each do |tagline|
  Tagline.first_or_create(header: tagline[:header], query: tagline[:query])
end
