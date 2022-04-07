FactoryBot.define do
  factory :base_error, class: Core::Helpers::Errors::Base do
    initialize_with {
      new(
        status: 500,
        field: 'concerned_field',
        error: 'returned_error'
      )
    }
  end
  factory :not_found_error, class: Core::Helpers::Errors::NotFound do
    initialize_with {
      new(
        field: 'concerned_field',
        error: 'unknown'
      )
    }
  end
  factory :forbidden_error, class: Core::Helpers::Errors::Forbidden do
    initialize_with {
      new(
        field: 'concerned_field',
        error: 'forbidden'
      )
    }
  end
  factory :bad_request_error, class: Core::Helpers::Errors::BadRequest do
    initialize_with {
      new(
        field: 'concerned_field',
        error: 'required'
      )
    }
  end
end