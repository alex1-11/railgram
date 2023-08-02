# Railgram

Railgram is a social media application inspired by Instagram, built using Ruby on Rails. It allows users to share images, connect with others, and interact through posts, comments, and likes. This README provides an overview of the application's functionality and instructions for setting it up.

## Table of Contents

- [Railgram](#railgram)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Database Setup](#database-setup)
  - [Usage](#usage)
    - [User Authentication](#user-authentication)
    - [Posting Images](#posting-images)
    - [Interacting with Posts](#interacting-with-posts)
    - [Managing Account](#managing-account)
  - [Visual design](#visual-design)
  - [Credits](#credits)

## Getting Started

### Prerequisites

- Ruby version: 3.1.2
- Rails version: 7.0.4
- PostgreSQL database
- Bundler gem installed

### Installation

1. Clone the repository: `git clone <repository-url>`
2. Navigate to the project directory: `cd railgram`
3. Install dependencies: `bundle install`

### Database Setup

1. Create the database: `rails db:create`
2. Run migrations: `rails db:migrate`

## Usage

Railgram provides the following functionality:

### User Authentication

- Sign up for an account
- Log in to your account
- Change your password
- Delete your account

### Posting Images

- Upload images with or without captions
- Edit your own posts

### Interacting with Posts

- Like/dislike posts
- View the number of likes on a post
- Leave comments under posts
- Remove your comments
- View a feed of posts from users you follow
- View posts, comments, and other users

### Managing Account

- Follow/unfollow other users
- View followers and following lists
- Add, change, or remove your avatar
- Toggle between light and dark themes (preference saved to cookies)

## Visual design

Railgram offers a visually appealing experience built with use of Bootstrap with two themes: light and dark. You can customize your theme preference, and the application will remember your choice using cookies.
Due to Bootstrap the app has a mobile compatible design.

## Credits

Styling done with [Bootstrap](https://getbootstrap.com/) v.5.3

Sample testing images by Thorsten Schulze from [Pixabay](https://pixabay.com/users/thorsten1970-11841595/).

This project is developed and maintained by [Your Name]. Feel free to contribute by submitting issues or pull requests.
