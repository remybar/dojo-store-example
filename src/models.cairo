use starknet::ContractAddress;

// In Dojo 1.5.0, the default value for an enum is the first variant,
// so here: `None`.
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Direction {
    None,
    Left,
    Right,
    Up,
    Down,
}

// In Dojo 1.5.0, if an unitialized WeaponStat is read,
// the extra field will be set to `Some(0)` due to the way
// Option<T> is defined in Cairo.
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub struct WeaponStat {
    pub damage: u32,
    pub extra: Option<u32>,
}

// In Dojo 1.5.0, the default value for an enum is the first variant,
// so here: `Sword(WeaponStat{ damage: 0, extra: Some(0) })`.
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Weapon {
    Sword: WeaponStat,
    Dagger: WeaponStat,
    Knife: WeaponStat,
    Axe: WeaponStat,
    Mace: WeaponStat,
    Spear: WeaponStat,
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Moves {
    #[key]
    pub player: ContractAddress,
    pub remaining: u8,
    pub last_direction: Direction,
}

#[derive(Copy, Drop, Serde, Introspect, PartialEq)]
pub struct PlayerItem {
    pub item_id: u32,
    pub quantity: u32,
    pub score: Option<i32>,
}

// In Dojo 1.5.0, like for the `extra` field of the `WeaponStat` struct,
// the default value of `favorite_item` is `Some(0)`.
#[derive(Drop, Serde)]
#[dojo::model]
pub struct PlayerConfig {
    #[key]
    pub player: ContractAddress,
    pub name: ByteArray,
    pub weapon: Weapon,
    pub items: Array<PlayerItem>,
    pub favorite_item: Option<u32>,
}
