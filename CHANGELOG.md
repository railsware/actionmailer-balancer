## [1.2.0] - 2025-03-06

- Drop Ruby 3.0 support
- Update dependencies

## [1.1.2] - 2024-12-13

- Allow Rails 8 

  *Alex Ghiculescu*

## [1.1.1] - 2024-12-09

- Fix crash when no settings are provided for a delivery method
  
  ```ruby
  config.action_mailer.balancer_settings = {
    delivery_methods: [
      {
        method: :mailtrap,
        weight: 1
      }
    ]
  }
  ``` 

  *Alex Ghiculescu*

## [1.1.0] - 2024-08-19

- Drop Ruby 2.7 support
- Update dependencies

## [1.0.0] - 2022-10-07

- Initial release
