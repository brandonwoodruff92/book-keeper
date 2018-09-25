# book-keeper

Book Keeper is descriptionA light-weight Ruby ORM modelled after Ruby on Rails' ActiveRecord, featuring basic object querying, as well as object association methods. With Book Keeper, you can map and query your Ruby objects to and from your database with ease!

## Demo

### Databases

#### Cats
|id|owner_id|name|color|gender|
|--|----|-----|------|
|1|1|Oscar|black|male|
|2|1|Misty|white|female|
|3|3|Sparkles|orange|male|
|4|2|Patches|brown|female|
|5|4|Tigger|orange|male|

#### People
|id|name|gender|
|--|----|------|
|1|Tim|male|
|2|Mary|female|
|3|Molly|female|
|4|John|male|

### SQLObject

```ruby
class Cat < SQLObject
end 

class Person < SQLObject
end
```

### ::all

`::all` allows you to find all SQLObjects from a table in the database.

```ruby
people = Person.all
```

Result

```ruby
{
  name: 'Tim',
  gender: 'female'
},
{
  name: 'Mary',
  gender: 'female'
},
{
  name: 'Molly',
  gender: 'female'
},
{
  name: 'John',
  gender: 'male'
}
```

### ::find

`::find` allows you to find a single SQLObject from the database by its id.

```ruby
tim = Person.find(1)
```

Result

```ruby
{
  id: 1,
  name: 'Tim',
  gender: 'male'
}
```

### ::find_by

`::find_by` allows you to find a single SQLObject from the database by any attribute and value passed in as a key-value pair.

```ruby
time = Person.find_by(id: 1)
```

Result

```ruby
{
  id: 1,
  name: 'Tim',
  gender: 'male'
}
```

### #insert

`#insert` allows you to insert a newly created SQLObject into the database, and automatically assigns it a valid id.

```ruby
mike = Person.new(name: 'Mike', gender: 'male')
mike.insert
```
New Database

|id|name|gender|
|--|----|------|
|1|Tim|male|
|2|Mary|female|
|3|Molly|female|
|4|John|male|
|5|Mike|male|

### #update

`#update` allows you to update an existing SQLObject to the database.

```ruby
tim = Person.find(1)
tim.name = 'Bob'
tim.update
```

New Database

|id|name|gender|
|--|----|------|
|1|Bob|male|
|2|Mary|female|
|3|Molly|female|
|4|John|male|
|5|Mike|male|

### #save

`#save` allows you to insert a new SQLObject or update an existing SQLObject if it already exists.

```ruby
bob = Person.find(1)
bob.name = 'Tim'
jenn = Person.new(name: 'Jenn', gender: 'female')

bob.save
jenn.save
```

New Database

|id|name|gender|
|--|----|------|
|1|Tim|male|
|2|Mary|female|
|3|Molly|female|
|4|John|male|
|5|Mike|male|
|6|Jenn|female|

### ::where

`::where` allows you to find all SQLObjects from the database by any attribute and value passed in as a key-value pair.

```ruby
people = Person.where(gender: male)
```

Result

```ruby
{
  name: 'Tim',
  gender: 'male'
},
{
  name: 'John',
  gender: 'male'
},
{
  name: 'Mike',
  gender: 'male'
}
```

