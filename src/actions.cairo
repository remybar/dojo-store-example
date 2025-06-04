use crate::models::*;
use starknet::ContractAddress;

#[starknet::interface]
pub trait IActions<T> {
    fn write_data(ref self: T);
    fn read_moves(self: @T, player: ContractAddress) -> Moves;
    fn read_player_config(self: @T, player: ContractAddress) -> PlayerConfig;
}

#[dojo::contract]
pub mod actions {
    use crate::models::*;
    use starknet::{ContractAddress, contract_address_const};

    use dojo::model::ModelStorage;

    #[abi(embed_v0)]
    impl ActionsImpl of super::IActions<ContractState> {
        /// Write some data that must remain the same after migrating to Dojo 1.6.0
        /// using the DojoLegacyStore derive attribute on models.
        fn write_data(ref self: ContractState) {
            let mut world = self.world(@"ns");

            world
                .write_model(
                    @Moves {
                        player: contract_address_const::<0x01>(),
                        remaining: 42,
                        last_direction: Direction::Up,
                    },
                );
            world
                .write_model(
                    @Moves {
                        player: contract_address_const::<0x02>(),
                        remaining: 36,
                        last_direction: Direction::Down,
                    },
                );
            world
                .write_model(
                    @Moves {
                        player: contract_address_const::<0x03>(),
                        remaining: 78,
                        last_direction: Direction::None,
                    },
                );
            world
                .write_model(
                    @Moves {
                        player: contract_address_const::<0x04>(),
                        remaining: 83,
                        last_direction: Direction::Left,
                    },
                );

            world
                .write_model(
                    @PlayerConfig {
                        player: contract_address_const::<0x01>(),
                        name: "Bob",
                        weapon: Weapon::Sword(WeaponStat { damage: 13, extra: Option::Some(5) }),
                        items: array![
                            PlayerItem { item_id: 1, quantity: 5, score: Option::Some(-30) },
                            PlayerItem { item_id: 2, quantity: 1, score: Option::None },
                            PlayerItem { item_id: 3, quantity: 45, score: Option::Some(2) },
                        ],
                        favorite_item: Option::None,
                    },
                );

            world
                .write_model(
                    @PlayerConfig {
                        player: contract_address_const::<0x02>(),
                        name: "Alice",
                        weapon: Weapon::Mace(WeaponStat { damage: 80, extra: Option::None }),
                        items: array![
                            PlayerItem { item_id: 6, quantity: 9, score: Option::Some(-18) },
                        ],
                        favorite_item: Option::Some(6),
                    },
                );

            world
                .write_model(
                    @PlayerConfig {
                        player: contract_address_const::<0x03>(),
                        name: "John",
                        weapon: Weapon::Spear(WeaponStat { damage: 2, extra: Option::Some(8) }),
                        items: array![
                            PlayerItem { item_id: 2, quantity: 1, score: Option::None },
                            PlayerItem { item_id: 3, quantity: 66, score: Option::Some(2) },
                        ],
                        favorite_item: Option::None,
                    },
                );
        }

        /// Helper to read Moves
        fn read_moves(self: @ContractState, player: ContractAddress) -> Moves {
            let world = self.world(@"ns");
            world.read_model(player)
        }

        /// Helper to read PlayerConfig
        fn read_player_config(self: @ContractState, player: ContractAddress) -> PlayerConfig {
            let world = self.world(@"ns");
            world.read_model(player)
        }
    }
}
