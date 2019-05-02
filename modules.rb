class Book

  def initialize()
    @title = title
    @subtitle = subtitle
    @edition = edition
    @year = year
    @editor = editor
    @publisher = publisher
    @city = city
    @country = country
    @chapters = chapters
    @isbn = isbn
  end

end

class Paper

  def initialize()
    @title = title
    @subtitle = subtitle
    @year = year
    @journal = journal
    @volume = volume
    @issue = issue
    @pages = pages
    @doi = doi
  end

end

class Author

  def initialize(name = "", first_name = "", last_name = "")
    @name = name
    @first_name = !first_name.empty? ? first_name : (!name.empty? ? name.split.first : "")
    @last_name = !last_name.empty? ? last_name : (!name.empty? ? name.split[1..-1].join(" ") : "")
    @surname = @last_name
  end

end

class Theorem

  def initialize(name = "", author = "", statement = "", description = "", tags = [])
    @name = name
    @author = author
    @statement = statement
    @description = description
    @tags = tags
  end

end
