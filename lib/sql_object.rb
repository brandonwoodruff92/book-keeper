require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'
require 'active_support/inflector'

class SQLObject
  extend Searchable, Associatable

  def self.columns
    if @columns
      return @columns
    end

    data = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    @columns = data.first.map do |column_name|
      column_name.to_sym
    end
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") do |value|
        attributes[column] = value
      end

      define_method(column) do
        attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    all = "#{table_name}.*"

    results = DBConnection.execute(<<-SQL)
      SELECT
        #{all}
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map do |obj_hash|
      self.new(obj_hash)
    end
  end

  def self.find(id)
    all = "#{table_name}.*"
    obj_id = "#{table_name}.id"

    results = DBConnection.execute(<<-SQL, id)
      SELECT
        #{all}
      FROM
        #{table_name}
      WHERE
        #{obj_id} = ?
      LIMIT 1
    SQL

    if results.empty?
      nil
    else
      self.new(results.first)
    end
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_sym = attr_name.to_sym
      class_columns = self.class.columns

      if class_columns.include?(attr_sym)
        send("#{attr_sym}=", value)
      else
        raise "unknown attribute '#{attr_sym}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    class_columns = self.class.columns

    class_columns.map do |col|
      send(col)
    end
  end

  def insert
    class_table = self.class.table_name
    class_columns = self.class.columns

    col_names = (class_columns - [:id]).join(", ")
    question_marks = (["?"] * (class_columns.length - 1)).join(", ")
    vals = attribute_values[1..-1]

    DBConnection.execute(<<-SQL, *vals)
      INSERT INTO
        #{class_table} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    send("id=", DBConnection.last_insert_row_id)
  end

  def update
    class_table = self.class.table_name
    class_columns = self.class.columns

    set_vals = (class_columns - [:id]).map { |col| "#{col} = ?" }.join(", ")
    vals = attribute_values.rotate

    DBConnection.execute(<<-SQL, *vals)
      UPDATE
        #{class_table}
      SET
        #{set_vals}
      WHERE
        id = ?
    SQL
  end

  def save
    if send(:id)
      update
    else
      insert
    end
  end
end
