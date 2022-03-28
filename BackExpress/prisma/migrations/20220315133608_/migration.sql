-- DropForeignKey
ALTER TABLE `Action` DROP FOREIGN KEY `Action_reaction_id_fkey`;

-- AddForeignKey
ALTER TABLE `Action` ADD CONSTRAINT `Action_reaction_id_fkey` FOREIGN KEY (`reaction_id`) REFERENCES `Reaction`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
