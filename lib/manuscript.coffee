class @Manuscript extends Minimongoid
  @_collection: new Meteor.Collection "manuscripts"

  @traditions: [
    "Amharic"
    "Armenian"
    "Coptic"
    "Gǝʿǝz" #changed from "Ge'ez" - changed in DB
    "Latin"
    "Syriac"
  ]

  @languages: [
    "Amharic"
    "Arabic"
    "Armenian"
    "Church Slavonic"
    "Coptic"
    "Gǝʿǝz" #changed from "Ge'ez" - Changed in DB
    "Georgian"
    "Greek"
    "Hebrew"
    "Kurdish"
    "Latin"
    "Old Church Slavonic"
    "Persian"
    "Polish"
    "Russian"
    "Syriac"
    "Turkish"
    "Ukrainian" #changed from "Ukranian" - changed in db
  ]

  @regions: [
    "All"
    "Paris Basin"
    "Lombardy"
    "Southern France"
    "Lorraine and Franconia"
    "Swabia and Bavaria"
    "Jura"
    "Saxony and the eastern Marches"
    "Central Italy and Rome"
    "Other"
  ]

  @alphabet: [
    "Arabic"
    "Armenian"
    "Coptic"
    "Cyrillic"
    "Gǝʿǝz" #changed from "Ge'ez" - changed in DB
    "Georgian"
    "Greek"
    "Hebrew or Aramaic" #changed from "Hebrew (or Armanic)" - changed in db
    "Roman"
    "Syriac"
  ]

  @scripts: [
    "Abbasid bookhand"
    "Ancient Roman"
    "Asomtavruli"
    "Beneventan"
    "Bolorgir"
    "Bookhand"
    "Carolingian"
    "Christian Palestinian Aramaic"
    "Coptic"
    "Cyrillic bookhand"
    "Cyrillic cursive"
    "Cursive"
    "Dīwānī"
    "Early Jewish"
    "East Syriac"
    "Erkat’agir"
    "Erkat’agir-bolorgir"
    "Estrangela"
    "Gǝʿǝz"
    "Glagolitic"
    "Gothic"
    "Half-Uncial"
    "Hasmonean"
    "Herodian"
    "Humanist"
    "Insular"
    "Maghribi"
    "Melkite"
    "Minuscule"
    "Muḥaqqaq"
    "Mxedruli"
    "Naskh"
    "Nastaʿlīq"
    "New Abbasid style"
    "Nōtrgir"
    "Nusxuri"
    "Papyri bookhand"
    "Papyri cursive"
    "Rayḥān"
    "Riqāʿ"
    "Ruqʿa"
    "Semi-cursive"
    "Semiuncial"
    "Serto"
    "Shikasta"
    "Šłagir"
    "Taʿlīq"
    "Tawqīʿ"
    "Thuluth"
    "Uncial"
    "Visigothic"
  ]
