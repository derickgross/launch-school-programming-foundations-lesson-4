require 'pry'

def generate_uuid
  characters = ('a'..'f').to_a + ('0'..'9').to_a
  section_lengths = [8, 4, 4, 4, 12]
  sections = []

  section_lengths.each do |length|
    sections << "#{characters.sample(length).join}"
  end
  
  sections.join("-")
end

generate_uuid