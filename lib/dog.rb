class Dog
    attr_accessor :breed, :id, :name
    require 'pry'
    
    def initialize(breed:breed, id:id=nil, name:name) 
            @breed = breed 
            @id = id
            @name = name 
        
    end 


    def self.create_table 
        sql = <<-SQL
        Create table if not exists dogs ( 
            id integer primary key, 
            name  TEXT,
            breed text
        )
            SQL
        DB[:conn].execute(sql)
    end 


    def self.drop_table
        sql = "drop table dogs"
        DB[:conn].execute(sql)


    end 


    def save 
        sql = <<-SQL 
        insert into dogs ( name, breed
        ) VALUES (?, ? )
    
       SQL
       DB[:conn].execute(sql, self.name, self.breed)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

       return self 
       
    end 

    def self.create(name:, breed:)
        dog= Dog.new(name: name, breed: breed)
        dog.save 
        dog 
        
    end 

    def self.new_from_db(row)
        dog = Dog.new(id:row[0], name:row[1],breed: row[2])
        dog
        # binding.pry
        
    end

    def self.find_by_id(id)
        sql = "select name, breed from dogs where id = ? "

      array   = DB[:conn].execute(sql,id)
    #   binding.pry 
      dog = new(name:array[0][0],breed:[0][1],id: id)
     

    end 


    def self.find_or_create_by(name:, breed:)
        dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
        if !dog.empty? 
            dog_data = dog[0]
      dog= Dog.new(id:dog_data[0], name:dog_data[1],breed: dog_data[2])
        else 
           dog= Dog.create(name:name, breed:breed)
        end
    dog
        
    end 

    def self.find_by_name(name)
        sql = "select name, breed, id from dogs where name = ? "

      array   = DB[:conn].execute(sql,name)

      dog = new(name:array[0][0],breed:array[0][1],id:array[0][2])

    end

    def update
        
            sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
            DB[:conn].execute(sql, self.name, self.breed, self.id)
          

    end 





end