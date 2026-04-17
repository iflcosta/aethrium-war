-- Seed for Accounts 1-7
-- Passwords are SHA1(N) where N is the account number
INSERT INTO `accounts` (`id`, `name`, `password`, `type`) VALUES
(1, '1', '356a192b7913b04c54574d18c28d46e6395428ab', 1),
(2, '2', 'da4b9237bacccdf19c0760cab7aec4a8359010b0', 1),
(3, '3', '77de68daecd823babbb58edb1c8e14d7106e83bb', 1),
(4, '4', '1b6453892473a467d07372d45eb05abc2031647a', 1),
(5, '5', 'ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4', 1),
(6, '6', 'c1dfd96eea8cc2b62785275bca38ac261256e278', 1),
(7, '7', '902ba3cda1883801594b6e1b452790cc53948fda', 1)
ON DUPLICATE KEY UPDATE `password` = VALUES(`password`);
