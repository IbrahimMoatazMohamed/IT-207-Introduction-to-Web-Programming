DROP DATABASE IF EXISTS `balqgivg_main`;
CREATE DATABASE `balqgivg_main` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `balqgivg_main`;
CREATE TABLE `users`
(
    `user_id`           INT AUTO_INCREMENT PRIMARY KEY,
    `joined_date`       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `name`              VARCHAR(255),
    `password`          VARCHAR(255),
    `email`             VARCHAR(255) UNIQUE,
    `img`               VARCHAR(255),
    `DOB`               DATE, # Date Of Birth
    `phone`             VARCHAR(30) UNIQUE,
    `country`           VARCHAR(255),
    `job_title`         VARCHAR(255),
    `YOE`               INT,  # Years Of Experience
    `level`             INT,
    `number_of_friends` INT       DEFAULT 0,
    `gender`            VARCHAR(15),
    `nationality`       VARCHAR(255),
    `skills`            TEXT,
    `ratings`           TEXT
);
CREATE TABLE `friend_requests`
(
    `request_id`   INT AUTO_INCREMENT PRIMARY KEY,
    `requester_id` INT,
    `requested_id` INT,
    `added_time`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status`       BOOLEAN,
    FOREIGN KEY (`requester_id`) REFERENCES `users` (`user_id`),
    FOREIGN KEY (`requested_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `user_friends`
(
    `friendship_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id`       INT, #requester
    `friend_id`     INT, #requested
    `added_time`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    FOREIGN KEY (`friend_id`) REFERENCES `users` (`user_id`),
    CONSTRAINT `chk_different_users` CHECK (`user_id` <> `friend_id`)
);
CREATE TABLE `password_history`
(
    `user_id`     INT,
    `change_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_password_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `widgets`
(
    `user_id`     INT UNIQUE,
    `drafts`      BOOLEAN DEFAULT TRUE,
    `targets`     BOOLEAN DEFAULT TRUE,
    `tickets`     BOOLEAN DEFAULT TRUE,
    `quick_draft` BOOLEAN DEFAULT TRUE,
    CONSTRAINT `fk_widgets_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `activities`
(
    `activities_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id`       INT,
    `img_src`       TEXT,
    `name`          VARCHAR(255),
    `description`   VARCHAR(255),
    `date`          DATE,
    `time`          TIME,
    CONSTRAINT `fk_activities_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `drafts`
(
    `draft_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id`  INT,
    `title`    VARCHAR(40),
    `content`  TEXT,
    `time`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_draft_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `targets`
(
    `target_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id`   INT,
    `label`     VARCHAR(30),
    `goal`      DECIMAL(10, 2),
    `icon`      VARCHAR(30),
    `achieved`  DECIMAL(10, 2),
    `year`      YEAR DEFAULT (YEAR(CURDATE())),
    CONSTRAINT `fk_targets_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `tickets`
(
    `ticket_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id`   INT,
    `label`     VARCHAR(30),
    `icon`      VARCHAR(30),
    `achieved`  DECIMAL(10, 2),
    CONSTRAINT `fk_tickets_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);
CREATE TABLE `items`
(
    `item_id`        INT AUTO_INCREMENT PRIMARY KEY,
    `name`           VARCHAR(255),
    `description`    TEXT,
    `day_price`      DECIMAL(10, 2),
    `person_price`   DECIMAL(10, 2),
    `stock_quantity` INT,
    `imgs_srcs`      TEXT,
    `min_days`       INT,
    `days`           INT,
    `max_days`       INT,
    `min_persons`    VARCHAR(255),
    `persons`        VARCHAR(255),
    `max_persons`    VARCHAR(255),
    `category`       VARCHAR(255),
    `title`          VARCHAR(255),
    `intro`          VARCHAR(255),
    `status`         VARCHAR(255),
    `added_time`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE `carts`
(
    `cart_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT,
    CONSTRAINT `fk_cart_user_id` FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`) ON DELETE CASCADE
);
CREATE TABLE `cart_items`
(
    `cart_item_id`     INT AUTO_INCREMENT PRIMARY KEY,
    `cart_id`          INT,
    `item_id`          INT,
    `days_selected`    INT,
    `persons_selected` INT,
    CONSTRAINT `fk_cart_item_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`),
    CONSTRAINT `fk_cart_item_item_id` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_item_cart` (`item_id`, `cart_id`)
);
CREATE TABLE `projects`
(
    `project_id`   INT AUTO_INCREMENT PRIMARY KEY,
    `cart_item_id` INT,
    `start_date`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
#     TODO important i dont want default value here
    `end_date`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status`       INT       DEFAULT 0,
    `price`        DECIMAL(10, 2),
    CONSTRAINT fk_projects_item_id
        FOREIGN KEY (cart_item_id) REFERENCES cart_items (cart_item_id)
            ON DELETE CASCADE
);
CREATE TABLE `user_projects`
(
    `user_id`    INT,
    `project_id` INT,
    `price`      DECIMAL(10, 2),
    `position`   VARCHAR(30),
    CONSTRAINT `fk_user_projects_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
    CONSTRAINT `fk_user_projects_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_user_project` (`user_id`, `project_id`)
);
CREATE TABLE `coupon`
(
    `coupon_id`  INT AUTO_INCREMENT PRIMARY KEY,
    `used_times` INT DEFAULT 0,
    `max_times`  INT,
    `code`       VARCHAR(255),
    `amount`     INT,
    `percentage` DECIMAL(5, 2)
);
CREATE TABLE `articles`
(
    `article_id`  INT AUTO_INCREMENT PRIMARY KEY,
    `img_src`     VARCHAR(300),
    `img_desc`    VARCHAR(255),
    `category`    VARCHAR(255),
    `title`       VARCHAR(255),
    `country`     VARCHAR(255),
    `added_time`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `description` TEXT,
    `content`     TEXT,
    `status`      VARCHAR(255)
);
CREATE TABLE `feedbacks`
(
    `feedback_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name`        VARCHAR(255),
    `email`       VARCHAR(255),
    `phone`       VARCHAR(30),
    `added_time`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `message`     TEXT
);
