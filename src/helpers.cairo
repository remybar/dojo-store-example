use starknet::ContractAddress;
use crate::models::*;

pub const P1: ContractAddress = 0x01.try_into().unwrap();
pub const P2: ContractAddress = 0x02.try_into().unwrap();
pub const P3: ContractAddress = 0x03.try_into().unwrap();
pub const P4: ContractAddress = 0x04.try_into().unwrap();

pub fn get_moves(player: ContractAddress) -> Moves {
    if player == P1 {
        return Moves { player: P1, remaining: 42, last_direction: Direction::Up };
    }

    if player == P2 {
        return Moves { player: P2, remaining: 36, last_direction: Direction::Down };
    }

    if player == P3 {
        return Moves { player: P3, remaining: 78, last_direction: Direction::None };
    }

    if player == P4 {
        return Moves { player: P4, remaining: 83, last_direction: Direction::Left };
    }

    panic!("Invalid player")
}

pub fn get_config(player: ContractAddress) -> PlayerConfig {
    if player == P1 {
        return PlayerConfig {
            player: P1,
            name: "Bob",
            weapon: Weapon::Sword(WeaponStat { damage: 13, extra: Option::Some(5) }),
            items: array![
                PlayerItem { item_id: 1, quantity: 5, score: Option::Some(-30) },
                PlayerItem { item_id: 2, quantity: 1, score: Option::None },
                PlayerItem { item_id: 3, quantity: 45, score: Option::Some(2) },
            ],
            favorite_item: Option::None,
        };
    }

    if player == P2 {
        return PlayerConfig {
            player: P2,
            name: "Alice",
            weapon: Weapon::Mace(WeaponStat { damage: 80, extra: Option::None }),
            items: array![PlayerItem { item_id: 6, quantity: 9, score: Option::Some(-18) }],
            favorite_item: Option::Some(6),
        };
    }

    if player == P3 {
        return PlayerConfig {
            player: P3,
            name: "John",
            weapon: Weapon::Spear(WeaponStat { damage: 2, extra: Option::Some(8) }),
            items: array![
                PlayerItem { item_id: 2, quantity: 1, score: Option::None },
                PlayerItem { item_id: 3, quantity: 66, score: Option::Some(2) },
            ],
            favorite_item: Option::None,
        };
    }

    panic!("Invalid player")
}

pub fn get_new_moves(player: ContractAddress) -> NewMoves {
    let move = get_moves(player);
    NewMoves { player, remaining: move.remaining, last_direction: move.last_direction }
}

pub fn get_new_config(player: ContractAddress) -> NewPlayerConfig {
    let config = get_config(player);
    NewPlayerConfig {
        player,
        name: config.name,
        weapon: config.weapon,
        items: config.items,
        favorite_item: config.favorite_item,
    }
}

pub fn get_player_bag(player: ContractAddress) -> PlayerBag {
    if player == P1 {
        return PlayerBag { player, attack: Attack::Kick((45, 28)), equipment: Equipment::Boots };
    }

    panic!("Invalid player")
}

pub fn check_default_move(read_move: Moves) {
    assert!(read_move.remaining == 0, "Bad default remaining");

    // in Dojo 1.5.0, the default enum variant is the first one.
    assert!(read_move.last_direction == Direction::None, "Bad default last_direction");
}

pub fn check_default_config(read_config: PlayerConfig) {
    assert!(read_config.name == "", "Bad default config name");

    // in Dojo 1.5.0, the default enum variant is the first one, with variant data set to 0.
    // in Dojo 1.5.0, the default Option<T> value is Some() with variant data set to 0.
    assert!(
        read_config.weapon == Weapon::Sword(WeaponStat { damage: 0, extra: Some(0) }),
        "Bad default config weapon",
    );
    assert!(read_config.items == array![], "Bad default config items");

    // in Dojo 1.5.0, the default Option<T> value is Some() with variant data set to 0.
    assert!(read_config.favorite_item == Option::Some(0), "Bad default config favorite_item");
}

pub fn check_new_default_move(read_move: NewMoves) {
    assert!(read_move.remaining == 0, "Bad default remaining");

    // in Dojo 1.6.0, the default enum value is the one defined with the `Default` trait.
    assert!(read_move.last_direction == Direction::None, "Bad default last_direction");
}

pub fn check_new_default_config(read_config: NewPlayerConfig) {
    assert!(read_config.name == "", "Bad default config name");

    // in Dojo 1.6.0, the default enum value is the one defined with the `Default` trait.
    // in Dojo 1.6.0, the default Option<T> value is None.
    assert!(
        read_config.weapon == Weapon::Sword(WeaponStat { damage: 0, extra: None }),
        "Bad default config weapon",
    );
    assert!(read_config.items == array![], "Bad default config items");

    // in Dojo 1.6.0, the default Option<T> value is None.
    assert!(read_config.favorite_item == Option::None, "Bad default config favorite_item");
}

pub fn check_default_player_bag(bag: PlayerBag) {
    assert!(bag.attack == Default::default(), "Bad default attack");
    assert!(bag.equipment == Default::default(), "Bad default equipment");
}
