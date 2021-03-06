-- DB update 2021_03_28_02 -> 2021_03_28_03
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
SELECT COUNT(*) INTO @COLEXISTS
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'version_db_world' AND COLUMN_NAME = '2021_03_28_02';
IF @COLEXISTS = 0 THEN LEAVE proc; END IF;
START TRANSACTION;
ALTER TABLE version_db_world CHANGE COLUMN 2021_03_28_02 2021_03_28_03 bit;
SELECT sql_rev INTO OK FROM version_db_world WHERE sql_rev = '1616345174221959057'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--

INSERT INTO `version_db_world` (`sql_rev`) VALUES ('1616345174221959057');

SET
@POOL            = 11652,
@POOLSIZE        = 5,
@POOLDESC        = 'Treasures - Eastern Plaguelands',
@RESPAWN         = 900,
@GUID = '45734,45735,45910,45915,45931,45933,45938,45949,45950,85791,85792,85793,85795,85797,100086';

-- Create pool(s)
DELETE FROM `pool_template` WHERE `entry`=@POOL;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES (@POOL,@POOLSIZE,@POOLDESC);

-- Add gameobjects to pools
DELETE FROM `pool_gameobject` WHERE FIND_IN_SET (`guid`,@GUID);
INSERT INTO `pool_gameobject` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(45734,@POOL,0,@POOLDESC),
(45735,@POOL,0,@POOLDESC),
(45910,@POOL,0,@POOLDESC),
(45915,@POOL,0,@POOLDESC),
(45931,@POOL,0,@POOLDESC),
(45933,@POOL,0,@POOLDESC),
(45938,@POOL,0,@POOLDESC),
(45949,@POOL,0,@POOLDESC),
(45950,@POOL,0,@POOLDESC),
(85791,@POOL,0,@POOLDESC),
(85792,@POOL,0,@POOLDESC),
(85793,@POOL,0,@POOLDESC),
(85795,@POOL,0,@POOLDESC),
(85797,@POOL,0,@POOLDESC),
(100086,@POOL,0,@POOLDESC);

-- Respawn rates of gameobjects
UPDATE `gameobject` SET `spawntimesecs`=@RESPAWN WHERE FIND_IN_SET (`guid`,@GUID);

--
-- END UPDATING QUERIES
--
COMMIT;
END //
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;
