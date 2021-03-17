## basic example implementation

Most stupid simple implementation could be:


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
    student_im = include_model.for(:student)

    resp = { id: student.id }

    resp.merge!({
      first_name: student.first_name,
      last_name: student.last_name
    }) if student_im.inclusive_of(:names)

    resp.merge!(date_of_birth: student.first_name) if student_im.include(:dob)

    render json: resp
  end
end
```

This way when you query `/students/123?include=student.names,student.dob` you get:


```json
{
  "id": 123,
  "first_name": "Johnny",
  "last_name": "Bravo",
  "date_of_birth": "1995-03-26",
}
```

This way when you query `/students/123?include=student.dob` you get:


```json
{
  "id": 123,
  "date_of_birth": "..some value..",
}
```

> This is just demo of the most simple way how you can use this gem, I
> don't recommend this solution. Pls check other examples :)
