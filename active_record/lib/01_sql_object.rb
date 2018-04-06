
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    cols.map!(&:to_sym)
    @columns = cols
  end



  def self.finalize!
    self.columns.each do |name|
      define_method(name) {@attributes[name]}
      define_method("#{name}=") do |val|
        self.attributes[name] = val
      end
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name ||= table_name

  end

  def self.table_name
    # ...
    @table_name || "#{self.to_s.tableize}"
  end

  def self.all
    # ...
    rows = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}



    SQL
    parse_all(rows)
  end

  def self.parse_all(results)
    # ...
    # results.each do |k,v|
    #   debugger
      # self.new(results)
    # end
    # debugger
    results.map {|result| self.new(result)}


  end

  def self.find(id)
    # ...
    val = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        
      WHERE
        id = ?
      LIMIT 1


    SQL
  end

  def initialize(params = {})
    # ...
    params.each do |name,val|
      n = name.to_sym
      if self.class.columns.include?(n)
        self.send("#{n}=",val)
      else
        raise "unknown attribute '#{name}'"
      end
    end
  end

  def attributes
    # ...
    @attributes || @attributes = {}



  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
