-- DropForeignKey
ALTER TABLE `Action` DROP FOREIGN KEY `Action_auth_id_fkey`;

-- DropForeignKey
ALTER TABLE `Action` DROP FOREIGN KEY `Action_user_id_fkey`;

-- DropForeignKey
ALTER TABLE `Auth` DROP FOREIGN KEY `Auth_user_id_fkey`;

-- DropForeignKey
ALTER TABLE `Reaction` DROP FOREIGN KEY `Reaction_auth_id_fkey`;

-- DropForeignKey
ALTER TABLE `Reaction` DROP FOREIGN KEY `Reaction_user_id_fkey`;

-- AddForeignKey
ALTER TABLE `Auth` ADD CONSTRAINT `Auth_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Action` ADD CONSTRAINT `Action_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Action` ADD CONSTRAINT `Action_auth_id_fkey` FOREIGN KEY (`auth_id`) REFERENCES `Auth`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reaction` ADD CONSTRAINT `Reaction_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reaction` ADD CONSTRAINT `Reaction_auth_id_fkey` FOREIGN KEY (`auth_id`) REFERENCES `Auth`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
