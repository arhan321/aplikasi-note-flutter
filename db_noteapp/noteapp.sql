/*
 Navicat Premium Data Transfer

 Source Server         : VPS
 Source Server Type    : MySQL
 Source Server Version : 100244
 Source Host           : 103.127.96.16:33306
 Source Schema         : noteapp

 Target Server Type    : MySQL
 Target Server Version : 100244
 File Encoding         : 65001

 Date: 20/08/2024 00:22:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for notes
-- ----------------------------
DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `color` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `textcolor` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notes
-- ----------------------------
INSERT INTO `notes` VALUES (5, 'Arhan malik alrasyid', 'percuma rajin sholat tapi kalo kelakuan nya kek iblis, bahkan itu rasanya seperti menjelekan agama', 'ffc70000', 'ff000000', 3, '2024-08-19 17:18:27', '2024-08-19 17:18:44');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `since_member` date NOT NULL,
  `textcolor` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `color` varchar(7) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `theme_preference` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE,
  INDEX `idx_since_member`(`since_member`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (3, 'arhan malik alrasyid', 'djncloud@gmail.com', 'password', '2024-08-10', NULL, NULL, 1);
INSERT INTO `users` VALUES (5, 'hanssss', 'djony@gmail.com', 'password', '2024-08-10', NULL, NULL, 0);
INSERT INTO `users` VALUES (6, 'rizkiwahyu', 'rizkiwahyu@gmail.com', 'password', '2024-08-10', NULL, NULL, 0);

SET FOREIGN_KEY_CHECKS = 1;
