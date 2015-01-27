class VoterSim
	def initialize
		@person_array = []
		choose_action
	end

	def choose_action
		puts "What would you like to do? Create, List, Update, Vote, or Leave"
		choice = (gets.chomp.downcase)
		case choice
		when "create" then create
		when "list" then list
		when "update" then update
		when "vote" then vote
		when "leave" then abort "Thanks for using our voting sim!"
		end 
	end

	def create
		puts "What would you like to create? Politician or Voter"
		create_choice = gets.chomp.downcase
		if(create_choice=="politician")
			puts "Name?"
			name = gets.chomp.downcase
			puts "Party? Democrat or Republican"
			party = gets.chomp.downcase
			@person_array.push(Politician.new(name,party))
		elsif(create_choice=="voter")
			puts "Name?"
			name = gets.chomp.downcase
			puts "Politics? Liberal, Conservative, Tea Party, Socialist, or Neutral"
			party = gets.chomp.downcase
			party = "tea_party" if party == "tea party"
			@person_array.push(Voter.new(name,party))
		end
		choose_action
	end

	def list
		@person_array.each{|person|
			puts "* #{person.class}, #{person.name}, #{person.party_choice}"
		}
		choose_action
	end

	def update_party_choice(person_type)

	end

	def update
		puts "Whom would you like to update?"
		search_name = gets.chomp.capitalize
		@person_array.each do |person|
			if search_name == person.name # what if there are two people w/ same name
				puts "New name?"
				person.name = gets.chomp.capitalize
				if person.class.to_s == "Voter"
					puts "New Politics?"
				elsif person.class.to_s == "Politician"
					puts "New Party?"
				end
				person.party_choice = gets.chomp.capitalize
				person.party_choice = "Tea_party" if person.party_choice == "tea party"
			end
		end
		choose_action
	end

	def vote
		@voter_array = []
		@politician_array = []
		#Splits the person array into voter and politician arrays.
		@person_array.each do |person|
			if person.class.to_s == "Voter"
				@voter_array.push(person)
			elsif person.class.to_s == "Politician"
				person.num_votes = 1
				@politician_array.push(person)
			end
		end

		#Sets the default vote for each voter (at random)
		@voter_array.each do |voter|
			voter.current_vote = @politician_array[rand(@politician_array.length)]
			puts voter.current_vote.name
		end

		#Iterates through the voter array
		@voter_array.each do |voter|
			puts "\nCurrent voter: #{voter.name}"
			#Gets the relevant convince chance out of the politics hash.
			convince_chance = voter.politics[voter.party_choice.downcase.to_sym]
			puts "Convince chance: #{convince_chance}"
			#Shuffles the politician array to change up the order of stump speeches.
			temp_array = @politician_array.shuffle
			 
			#The stump speech logic. Each politician has a chance to convince each voter
			temp_array.each do |politician|
				puts "Current politician: #{politician.name}"
				if(politician.party_choice == "Republican") #if the politician is Republican
					if(rand(100)+1 <= convince_chance) #generate a random number to see if they convince the voter
						voter.current_vote = politician #Switch the voter's vote if they are convinced
						puts "Vote switched! #{voter.current_vote.name}"
					else
						puts "Vote not switched! #{voter.current_vote.name}"
					end
				elsif(politician.party_choice == "Democrat") #same procedure as Republican
					if(rand(100)+1 > convince_chance) #but the odds of convincing are opposite
						voter.current_vote = politician
						puts "Vote switched! #{voter.current_vote.name}"
					else
						puts "Vote not switched! #{voter.current_vote.name}"
					end
				end
			end
			puts voter.current_vote.num_votes +=1 #Increases the vote count once the voter has decided on who to vote for.
		end

		puts ""

		#Sorts the politician array based on the number of votes they each have.
		@politician_array.sort!{|a,b| b.num_votes <=> a.num_votes}

		#Outputs the amount of votes tallied for each politician.
		@politician_array.each do |politician|
		 	puts "#{politician.name} tallied #{politician.num_votes} votes"
		end

		#Figures out the winner(s)
		winner_array = @politician_array.reject{|x| x.num_votes!=@politician_array[0].num_votes}

		#Ouputs the result of the vote.
		if(winner_array.length>1)
			puts "\nIt's a tie between:"
		else
			puts "\nThe winner is:"
		end
		winner_array.each do |politician|
			puts "#{politician.name} "
		end
		puts ""

		choose_action
	end
end

class Voter
	attr_reader :politics
	attr_accessor :party_choice, :name, :current_vote

	def initialize(name, party_choice)
		@name = name.capitalize
		@party_choice = party_choice.capitalize
		@politics = {
			tea_party: 90,
			conservative: 75,
			neutral: 50,
			liberal: 25,
			socialist: 10
		}
	end
end

class Politician < Voter
	attr_accessor :num_votes

	def initialize(name, party_choice)
		@name = name.capitalize
		@party_choice = party_choice.capitalize
		@num_votes = 1
		@win_tie_or_lose = ""
	end
end

# $test_array = []
# $test_array.push(Voter.new("Bob", "Liberal"))
# $test_array.push(Politician.new("Ted", "Democrat"))
# $test_array.push(Voter.new("Jane", "Conservative"))
# $test_array.push(Voter.new("Chris", "Neutral"))
# $test_array.push(Politician.new("Jenny", "Republican"))
# $test_array.push(Politician.new("Sam", "Democrat"))
# $test_array.push(Voter.new("Betty", "Tea_Party"))

VoterSim.new







