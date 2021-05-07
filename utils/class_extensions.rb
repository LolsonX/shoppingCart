class String
  def camelize
    is_snake = split("_").length > 1
    is_snake ? split("_").map(&:capitalize).join : self
  end

  def to_underscore
    to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end

  def pluralize
    if length >= 2
      last_letters = chars.last(2).join
      if %w[ss sh ch].include?(last_letters) || %w[s x z o].include?(last_letters[-1])
        self + "es"
      elsif last_letters[-1] == "f"
        self[..-2] + "ves"
      elsif last_letters == "fe"
        self[..-3] + "ves"
      elsif %w[b c d f g j k l m n p q s t v x z].include?(last_letters[0]) && last_letters[-1] == "y"
        self[..-2] + "ies"
      else
        self + "s"
      end
    else
      self + "s"
    end
  end
end
