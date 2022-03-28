-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `auth0_id` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `User_auth0_id_key`(`auth0_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Auth` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `refresh_token` VARCHAR(1000) NULL,
    `access_token` VARCHAR(1000) NULL,
    `username` VARCHAR(191) NULL,
    `password` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Action` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `reaction_id` INTEGER NOT NULL,
    `service_type` VARCHAR(191) NOT NULL,
    `action_type` VARCHAR(191) NOT NULL,
    `auth_id` INTEGER NOT NULL,
    `params` JSON NULL,

    UNIQUE INDEX `Action_reaction_id_key`(`reaction_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Reaction` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `service_type` VARCHAR(191) NOT NULL,
    `reaction_type` VARCHAR(191) NOT NULL,
    `auth_id` INTEGER NOT NULL,
    `params` JSON NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Auth` ADD CONSTRAINT `Auth_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Action` ADD CONSTRAINT `Action_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Action` ADD CONSTRAINT `Action_auth_id_fkey` FOREIGN KEY (`auth_id`) REFERENCES `Auth`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Action` ADD CONSTRAINT `Action_reaction_id_fkey` FOREIGN KEY (`reaction_id`) REFERENCES `Reaction`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reaction` ADD CONSTRAINT `Reaction_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Reaction` ADD CONSTRAINT `Reaction_auth_id_fkey` FOREIGN KEY (`auth_id`) REFERENCES `Auth`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
