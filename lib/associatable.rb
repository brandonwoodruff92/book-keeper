require_relative 'searchable'
require_relative 'assoc_options'
require 'active_support/inflector'

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      belongs_to_options = self.class.assoc_options[name]
      foreign_key = self.send(belongs_to_options.foreign_key)
      model_class = belongs_to_options.model_class

      model_class.where(belongs_to_options.primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      has_many_options = self.class.assoc_options[name]
      primary_key = self.send(has_many_options.primary_key)
      model_class = has_many_options.model_class

      model_class.where(has_many_options.foreign_key => primary_key)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      source_table = source_options.table_name
      through_foreign_key_val = self.send(through_options.foreign_key)

      results = DBConnection.execute(<<-SQL, through_foreign_key_val)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_options.foreign_key} = #{source_table}.#{source_options.primary_key}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end
