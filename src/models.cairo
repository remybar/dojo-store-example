use starknet::ContractAddress;

// Migration to 1.6.0: Implements Default trait using `Default` derive attribute
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug, Default)]
pub enum Direction {
    #[default]
    None,
    Left,
    Right,
    Up,
    Down,
}

// Migration to 1.6.0: Implements Default trait using `Default` derive attribute,
// because `WeaponStat` is used in an enum (`Weapon`)
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug, Default)]
pub struct WeaponStat {
    pub damage: u32,
    pub extra: Option<u32>,
}

// Migration to 1.6.0: Implements Default trait using `Default` derive attribute
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug, Default)]
pub enum Weapon {
    #[default]
    Sword: WeaponStat,
    Dagger: WeaponStat,
    Knife: WeaponStat,
    Axe: WeaponStat,
    Mace: WeaponStat,
    Spear: WeaponStat,
}

// Migration to 1.6.0:
// - As the model is composed of an enum (`Direction`), add
// the `DojoLegacyStorage` derive attribute to use the old
// storage system and to keep existing storage working.
// - (optional): remove useless derive attributes which are
// directly injected by dojo::model now.
#[dojo::model]
#[derive(DojoLegacyStorage, PartialEq)]
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
// Migration to 1.6.0:
// Use `DojoLegacyStorage` as explained in `Moves` model description.
// (optional): remove useless derive attributes which are
// directly injected by dojo::model now.
#[dojo::model]
#[derive(DojoLegacyStorage, PartialEq)]
pub struct PlayerConfig {
    #[key]
    pub player: ContractAddress,
    pub name: ByteArray,
    pub weapon: Weapon,
    pub items: Array<PlayerItem>,
    pub favorite_item: Option<u32>,
}

// Create NewMoves and NewPlayerConfig which are identical to Moves
// and PlayerConfig but using the new storage system.
#[dojo::model]
#[derive(PartialEq)]
pub struct NewMoves {
    #[key]
    pub player: ContractAddress,
    pub remaining: u8,
    pub last_direction: Direction,
}

#[dojo::model]
#[derive(PartialEq)]
pub struct NewPlayerConfig {
    #[key]
    pub player: ContractAddress,
    pub name: ByteArray,
    pub weapon: Weapon,
    pub items: Array<PlayerItem>,
    pub favorite_item: Option<u32>,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Attack {
    Shout: u8,
    Kick: (u8, u8),
    Poise: (u8, u8, u8),
    Freeze,
}

// Define the default Attack value by implementing the Default trait manually.
// It allows to use other values than 0.
impl AttackDefault of Default<Attack> {
    fn default() -> Attack {
        Attack::Poise((32, 56, 89))
    }
}

// Define the default Equipment value using the `Default` derive attribute.
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug, Default)]
pub enum Equipment {
    Shield,
    #[default]
    Armor: u8,
    Boots,
    Amulet,
}

// Define a model which uses the new storage system (DojoStore trait).
#[dojo::model]
#[derive(PartialEq)]
pub struct PlayerBag {
    #[key]
    pub player: ContractAddress,
    pub attack: Attack,
    pub equipment: Equipment,
}
