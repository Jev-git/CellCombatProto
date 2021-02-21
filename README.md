# Player states left
* Deal damage (atk: 1 square ahead, special: 2 square ahead)
* Take damage
* Sub weapon (like gem in Hades)
* Parry? (like in Cyber Shadow): Forward to stop projectile, attack to send it back

# Enemy
* Simple one:
    * Stay in place
    * Atk after a set amount of time, or when player is in front of them
* Mobile:
    * Move in col

# Room
* Do a first room like in Hades
    * You can move around, stance, atk, special
    * Have some chests to try your atk on
    * Have a portal to the next room
    * Drop down transition when entering and exiting a room

# Moving with actual speed? (maybe)
* Updating m_vBoardPos and global_position in the set_board_pos() function
* There are 2 position: m_vBoardPos and global_position
* m_vBoardPos are actual position that will be used when checking for contact between units (highlighted on tile)
* global_position are position that are gradually updated each time the m_vBoardPos is updated, with specified moving speed
* For example: when player pressed right, the m_vBoardPos is updated with y += 1, and global_position += speed * delta until it moved a distance of tile.width
* m_vDistanceLeft: Vector2
* while abs(m_vDistanceLeft.x) > 0: global_position.x += speed * delta (same for y axis)

# Đang làm dở
* Defend and counter-attack (like Hornet): hold the sword up. If the player attacks, the Warrior also attack back
* Finalize warrior boss:
    * After the boss has these attacks: teleport behind and hit, jump down, slash projectile, mind attack (require player to turn around), make a simple state machine/AI script for the boss to fight the player properly
    * Add proper telegraph where needed
