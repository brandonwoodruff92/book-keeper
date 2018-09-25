require_relative 'db_connection'

module Searchable
  def where(params)
    where_map = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
    val = params.values

    results = DBConnection.execute(<<-SQL, *val)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_map}
    SQL

    parse_all(results)
  end
end
