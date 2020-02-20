require 'pry'
class Dog
	attr_accessor :id, :name, :breed

	def initialize(dog)
		@name = dog[:name]
		@breed = dog[:breed]
	end

	def self.create_table
	  sql = <<-SQL
	    CREATE TABLE IF NOT EXISTS dogs (
  		  id INTEGER PRIMARY KEY,
  		  name TEXT,
  		  breed TEXT
	    ) 
	    SQL
	  DB[:conn].execute(sql)
	end

	def self.drop_table
	  sql = <<-SQL 
	    DROP TABLE dogs
	    SQL
	  DB[:conn].execute(sql)  
	end

	def save
	  sql = <<-SQL 
	    INSERT INTO dogs (name, breed)
	    VALUES (?, ?)
	    SQL

	  DB[:conn].execute(sql, self.name, self.breed)

	  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
	end

	def self.create(dog)
		dog = Dog.new(dog)
		dog.save
		dog
	end

	def self.new_from_db(row)
		# binding.pry
		new_dog = self.new(id: :nil, name: :name, breed: :breed)
		new_dog.id = row[0]
		new_dog.name = row[1]
		new_dog.breed = row[2]
		new_dog
	end

	def self.find_by_id(id)
	  sql = <<-SQL
	    SELECT *
	    FROM dogs
	    WHERE id = ?
	  SQL

	  DB[:conn].execute(sql,id).map do |row|
	    self.new_from_db(row)
	  end.first
	end

	def self.find_by_name(name)
	  sql = <<-SQL
	    SELECT *
	    FROM dogs
	    WHERE name = ?
	  SQL

	  DB[:conn].execute(sql,name).map do |row|
	    self.new_from_db(row)
	  end.first
	end

end