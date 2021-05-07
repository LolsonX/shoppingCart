class DbMigration
  attr_reader :db

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def initialize(db)
    @db = db
  end

  def filename
    self.class.instance_variable_get(:"@filename")
  end

  def object_name
    self.class.instance_variable_get(:"@object_name")
  end

  def fields
    self.class.instance_variable_get(:"@fields")
  end

  def migrate
    puts filename
    db["migrations"] << filename
    db["database"][object_name] = {}
    db["database"][object_name]["fields"] = fields
    db
  end

  def rollback
    db["migrations"].pop(filename)
    db["database"].delete(object_name)
    db
  end
end
