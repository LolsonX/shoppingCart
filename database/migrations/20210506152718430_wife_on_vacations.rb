# frozen_string = true

class WifeOnVacation < DbMigration
  @filename = "20210506152718430_wife_on_vacations"
  @object_name = "WifeOnVacations"
  @fields = [
    {:name=>"name", :type=>"string"},
    {:name=>"age", :type=>"integer"}
  ]
  def initialize(db)
    super(db)
  end
end
