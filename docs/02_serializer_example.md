## SerializerImplementation



```ruby
# app/model/student.rb
class Student < ApplicationRecord
  # model has fields: "id", "first_name", "last_name", "date_of_birth", "private_note", "created_at", "updated_at"

  has_many :works
end
```

```ruby
# app/model/work.rb
class Work < ApplicationRecord
  # model has fields: "id", "title", "content", "created_at", "updated_at", "published_at", "student_id"

  belongs_to :student
  has_many :images
end
```

```ruby
# app/model/image.rb
class Image < ApplicationRecord
  # model has fields: "id", "priority", "work_id"

  belongs_to :work
  has_one_attached :picture   # rails 5.2 and above intreduce custom image upload called ActiveStorage
end
```

```ruby
# config/routes

Rails.application.routes.draw do
 resources :students, only: [:show]
end
```

```ruby
# app/controllers/students_controller.rb
class StudentsController < ApplicationController

  # GET /students/123?include?student.___
  def show
    student = Student.find(params[:id])
    include_model = PragmaticQL.include_model(params[:include])
    render json: StudentSerializer
       .new(student)
       .set_level_include_model(include_model)
       .as_json
  end
end
```

create folder `app/serializers` Rails should auto-detect it

```ruby
# app/serializers/student_serializer.rb
class StudentSerializer
  attr_accessor :include_model
  attr_reader :student

  def initialize(student)
    @student = student
  end

  def set_level_include_model(inc_model)
    self.include_model = inc_model.for(:student)
    self
  end

  def as_json
    hash = {id: student.id}
    hash.merge!(name_hash) if include_model.inclusive_of?(:name)
    hash.merge!(dob_hash) if include_model.inclusive_of?(:dob)
    hash.merge!(work_list_hash) if include_model.inclusive_of?(:work_list)
    hash
  end

  private

  # feel free to group multiple fields uder one include key as long as they make Domain and performance sense
  def name_hash
    {
       first_name: student.first_name,
       last_name:  student.last_name
    }
  end

  def dob_hash
    {
       date_of_birth: student.date_of_birth
    }
  end

  def work_list_hash
    { work_list: student.works.map { |work| work_as_json(work) } }
  end

  def work_as_json(work)
    WorkSerializer
      .new(work)
      .set_level_include_model(include_model)
      .as_json
  end
end
```


```ruby
app/serializers/work_serializer.rb

class WorkSerializer
  attr_accessor :include_model
  attr_reader :work

  def initialize(work)
    @work = work
  end

  def set_level_include_model(inc_model)
    self.include_model = inc_model.for(:work)
    self
  end

  def as_hash
    hash = { id: work.id }
    hash.merge!(title_hash) if include_model.inclusive_of?(:title)
    hash.merge!(content_hash) if include_model.inclusive_of?(:content)
    hash.merge!(timestamps_hash) if include_model.inclusive_of?(:timestamps)
    hash.merge!(image_list_hash) if include_model.inclusive_of?(:image_list)
    hash
  end

  private

  def title_hash
    { title: work.title }
  end

  # imagine the work.content is markdown text and it can be converted to HTML
  def content_hash
    {
       content_markdown: work.content,
       content_html: MarkdownToHTML.convert(work.content),
       content_updated_at: work.updated_at
    }
  end

  def timestamps_hash
    {
      created_at: work.created_at,
      published_at: work.published_at
    }
  end

  def image_list_hash
    { images: work.images.map { |img| image_as_json(img) } }
  end

  def image_as_json(image
    ImageSerializer
      .new(image)
      .set_level_include_model(include_model)
      .as_json
  end
end
```

```ruby
app/serializers/image_serializer.rb

class ImageSerializer
  attr_accessor :include_model
  attr_reader :image

  def initialize(image)
    @image = image
  end

  def set_level_include_model(inc_model)
    self.include_model = inc_model.for(:image)
    self
  end

  def as_json
    hash = { id: image.id }
    hash.merge!(url_hash) if include_model.inclusive_of?(:url)
    hash
  end

  private

  def url_hash
    url = if image.picture.attached?
      h.url_for(image.picture)
    end

    if url
      { url: url }
    else
      { __url_developer_note: "image is not attached" } #this helps your fellow FE develper to debug why the image is not displaying. Feel free to put this develepoper notes trough out your application in variaus situations. Makes debugging process more friendly.
    end
  end

  def url_helper
    Rails.application.routes.url_helpers
  end
end
```




This way when you query `/students/123?include=student.name,student.dob` you get:


```json
{
  "id": 123,
  "first_name": "Johnny",
  "last_name": "Bravo",
  "date_of_birth": "1995-03-26",
}
```

When you query `/students/123?include=student.dob` you get:


```json
{
  "id": 123,
  "date_of_birth": "..some value..",
}
```

When you query `/students/123?include=student.name,student.work_list`


```json
{
  "id": 123,
  "first_name": "Johnny",
  "last_name": "Bravo",
  "work_list": [
    { "id": 111 },
    { "id": 222 },
  ]
}
```


When you query `/students/123?include=student.name,student.work_list,student.work.title`



```json
{
  "id": 123,
  "first_name": "Johnny",
  "last_name": "Bravo",
  "work_list": [
    {
       "id": 111,
       "title": "Why is Parkway Drive one of the best bands"
    },
    {
      "id": 222,
      "title": "Influence of the band Atrey on Metalcore culture"
    }
  ]
}
```

When you query `/students/123?include=student.name,student.work_list,student.work.title,student.work.image_list,student.work.image.url`

```json
{
  "id": 123,
  "first_name": "Johnny",
  "last_name": "Bravo",
  "work_list": [
    {
       "id": 111,
       "title": "Why is Parkway Drive one of the best bands",
       "image_list": [
         {
           "id": "111111",
           "url" "https://url-to-image.com/...."
         }
       ]
    },
    {
      "id": 222,
      "title": "Influence of the band Atrey on Metalcore culture",
       "image_list": [
         {
           "id": "111111",
           "__url_developer_note": "image is not attached"
         }
       ]
    }
  ]
}
```

