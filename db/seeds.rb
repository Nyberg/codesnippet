course_list = [
  [ "Skutberget", "Karlstad", 1, 18],
  [ "Forshaga", "Forshaga", 2, 18]
]

course_list.each do |course, content, club_id, holes|
  Course.create(name: course, content: content, club_id: club_id, holes: holes)
end

tee_list = [
  [ "Red", 57, 1],
  [ "Svart", 57, 2]
]

tee_list.each do |tee, par, course_id|
  Tee.create(color: tee, par: par, course_id: course_id)
end

hole_list = [
  [1, 1, 4, 140, 1],
  [1, 2, 3, 110, 1],
  [1, 3, 4, 160, 1],
  [1, 4, 4, 176, 1],
  [1, 5, 3, 85, 1],
  [1, 6, 3, 95, 1],
  [1, 7, 3, 138, 1],
  [1, 8, 3, 65, 1],
  [1, 9, 3, 90, 1],
  [1, 10, 3, 78, 1],
  [1, 11, 3, 70, 1],
  [1, 12, 3, 86, 1],
  [1, 13, 3, 80, 1],
  [1, 14, 3, 94, 1],
  [1, 15, 3, 60, 1],
  [1, 16, 3, 102, 1],
  [1, 17, 3, 74, 1],
  [1, 18, 3, 78, 1],
  [2, 1, 3, 140, 2],
  [2, 2, 3, 110, 2],
  [2, 3, 3, 160, 2],
  [2, 4, 3, 176, 2],
  [2, 5, 3, 85, 2],
  [2, 6, 3, 95, 2],
  [2, 7, 3, 138, 2],
  [2, 8, 4, 65, 2],
  [2, 9, 4, 90, 2],
  [2, 10, 3, 78, 2],
  [2, 11, 3, 70, 2],
  [2, 12, 3, 86, 2],
  [2, 13, 3, 80, 2],
  [2, 14, 4, 94, 2],
  [2, 15, 3, 60, 2],
  [2, 16, 3, 102, 2],
  [2, 17, 3, 74, 2],
  [2, 18, 3, 78, 2]
]

hole_list.each do |course_id, number, par, length, tee_id|
  Hole.create(course_id: course_id, number: number, par: par, length: length, tee_id: tee_id)
end

clubs_list = ["Karlstad FSK", "Klarälvens DGK"]

clubs_list.each do |name|
  Club.create(name: name)
end

competitions_list = [
  ["KFSK Veckotävlingar", "", "", 1],
  ["Klarälvsdiscen", "", "", 2]
]

competitions_list.each do |name, title, content, club_id|
  Competition.create(name: name, title: title, content: content, club_id: club_id, date: "2015-01-01 00:00:00")
end

tour_parts_list = [
  ["Deltävling 1", "", 1, 1, 1],
  ["Deltävling 1", "", 2, 2, 2]
]

tour_parts_list.each do | name, content, course_id, competition_id, tee_id|
  TourPart.create(name: name, content: content, course_id: course_id, competition_id: competition_id, tee_id: tee_id, date: "2015-01-01 00:00:00")
end

users_list = [
  "Magnus Dunder", "Peter Jonsson", "Ulf Engström",
  "Magnus Siivonen",
  "Jimmy Gräsberg",
  "Christoffer Eriksson",
  "Jari Mansikkala",
  "Max Khokhlov",
  "Daniel Boström",
  "Henry Kjellström",
  "Adrian Pettersson",
  "Christian Granberg",
  "Simon Camitz",
  "Albin Långh",
  "Anders Camitz",
  "Robert Boström",
  "Jacob Andreasson",
  "Fredrik Petterson",
  "Nicklas Hedberg",
  "Liam Moynagh",
  "Nils-Erik Jonsson",
  "Mats Westerberg",
  "Robert Eriksson",
  "Erik Bonde",
  "Karl Letterström",
  "Daniel Camitz",
  "Claes Bonde",
  "Magnus Samuelsson",
  "Mikael Moberg",
  "Dennis Andersson",
  "Jacob CE Johansson",
  "Andreas Liljemark",
  "Rikard Frejgrim",
  "Albin Boström",
  "Lars Olsson",
  "Niclas Fredin",
  "Per Carlsson",
  "Hampus Magnusson",
  "Tomas Mansikkala",
  "Simon Didner",
  "Rasmus Norlen",
  "Staffan Jansson",
  "Love Johansson",
  "Nick Caspr",
  "Henrik Reimer",
  "Andreas Norlen",
  "Jonas Norlen",
  "Jacob Johansson",
  "Sabina Engström",
  "Kristoffer Gräsberg",
  "Nicklas Julin",
  "Johan Andersson",
  "Christoffer Nyberg",
  "Martin Johansson",
  "Hampus Piehl",
  "Marcus Thorsen",
  "Fredrik Lundberg",
  "Daniel Hällsten",
  "Noa Ekeberg",
  "Arvid Svensson",
  "Joel Svensson",
  "Richard Hammar"
]

users_list.each do |user|
  User.create(name: user, club_id: 1)
end
