# book-keeper

Book Keeper is descriptionA light-weight Ruby ORM modelled after Ruby on Rails' ActiveRecord, featuring basic object querying, as well as object association methods. With Book Keeper, you can map and query your Ruby objects to and from your database with ease!

## Demo

### Database

|id|name|color|gender|
|--|----|-----|------|
|1|Oscar|black|male|
|2|Misty|white|female|
|3|Sparkles|orange|male|
|4|Patches|brown|female|
|5|Tigger|orange|male|

### SQLObject

```ruby
class Cat < SQLObject
end 
```

### ::find

`::find` allows you to find a single SQLObject from the database by its id.

```ruby
oscar = Cat.find(1)
```

Result

```ruby
{
  id: 1,
  name: 'Oscar',
  color: 'black',
  gender: 'male'
}
```

### ::find_by

`::find_by` allows you to find a single SQLObject from the database by any attribute and value passed in as a key-value pair.

```ruby
oscar = Cat.find_by(name: 'Oscar')
```

Result

```ruby
{
  id: 1,
  name: 'Oscar',
  color: 'black',
  gender: 'male'
}
```

### ::find_all_by

`::find_all_by` allows you to find all SQLObjects from the database by any attribute and value passed in as a key-value pair.

```ruby
cats = Cat.find_all_by(gender: 'male')
```

Result

```ruby
{
  id: 1,
  name: 'Oscar',
  color: 'black',
  gender: 'male'
},
{
  id: 3,
  name: 'Sparkles',
  color: 'orange',
  gender: 'male'
},
{
  id: 5,
  name: 'Tigger',
  color: 'Orange',
  gender: 'male
}
```

### #insert

`#insert` allows you to insert a newly created SQLObject into the database, and automatically assigns it a valid id.

```ruby
bella = Cat.new(name: 'Bella', color: 'white', gender: 'female')
bella.insert
```
New Database

|id|name|color|gender|
|--|----|-----|------|
|1|Oscar|black|male|
|2|Misty|white|female|
|3|Sparkles|orange|male|
|4|Patches|brown|female|
|5|Tigger|orange|male|
|6|Bella|white|female|

### #update

`#update` allows you to update an existing SQLObject to the database.

```ruby
oscar = Cat.find(1)
oscar.color = 'brown'
oscar.update
```

New Database

|id|name|color|gender|
|--|----|-----|------|
|1|Oscar|brown|male|
|2|Misty|white|female|
|3|Sparkles|orange|male|
|4|Patches|brown|female|
|5|Tigger|orange|male|
|6|Bella|white|female|

### #save

`#save` allows you to insert a new SQLObject or update an existing SQLObject if it already exists.

```ruby
oscar = Cat.find(1)
oscar.color = 'black'
felix = Cat.new(name: 'felix', color: 'grey', gender: 'male')

oscar.save
felix.save
```

New Database

|id|name|color|gender|
|--|----|-----|------|
|1|Oscar|black|male|
|2|Misty|white|female|
|3|Sparkles|orange|male|
|4|Patches|brown|female|
|5|Tigger|orange|male|
|6|Bella|white|female|
|7|Felix|grey|male|
