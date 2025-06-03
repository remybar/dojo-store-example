use starknet::ContractAddress;

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Direction {
    None,
    Left,
    Right,
    Up,
    Down,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub struct WeaponStat {
    damage: u32,
    extra: Option<u32>
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Weapon {
    Sword: WeaponStat,
    Dagger: WeaponStat,
    Knife: WeaponStat,
    Axe: WeaponStat,
    Mace: WeaponStat,
    Spear: WeaponStat
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
