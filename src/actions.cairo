use starknet::ContractAddress;
use crate::models::*;

#[starknet::interface]
pub trait IActions<T> {
    fn write_data(ref self: T);
    fn read_moves(self: @T, player: ContractAddress) -> Moves;
    fn read_player_config(self: @T, player: ContractAddress) -> PlayerConfig;

    fn write_new_data(ref self: T);
    fn read_new_moves(self: @T, player: ContractAddress) -> NewMoves;
    fn read_new_player_config(self: @T, player: ContractAddress) -> NewPlayerConfig;

    fn check_migration(self: @T);
}

#[dojo::contract]
pub mod actions {
    use dojo::model::ModelStorage;
    use starknet::ContractAddress;
    use crate::helpers::*;
    use crate::models::*;

    #[abi(embed_v0)]
    impl ActionsImpl of super::IActions<ContractState> {
        fn write_data(ref self: ContractState) {
            let mut world = self.world(@"ns");

            world.write_model(@get_moves(P1));
            world.write_model(@get_moves(P2));
            world.write_model(@get_moves(P3));
            world.write_model(@get_moves(P4));

            world.write_model(@get_config(P1));
            world.write_model(@get_config(P2));
            world.write_model(@get_config(P3));
        }

        fn read_moves(self: @ContractState, player: ContractAddress) -> Moves {
            let world = self.world(@"ns");
            world.read_model(player)
        }

        fn read_player_config(self: @ContractState, player: ContractAddress) -> PlayerConfig {
            let world = self.world(@"ns");
            world.read_model(player)
        }

        /// Write data for the new models NewMoves and NewPlayerConfig which
        /// use the new Dojo storage mechanism.
        fn write_new_data(ref self: ContractState) {
            let mut world = self.world(@"ns");

            world.write_model(@get_new_moves(P1));
            world.write_model(@get_new_moves(P2));
            world.write_model(@get_new_moves(P3));
            world.write_model(@get_new_moves(P4));

            world.write_model(@get_new_config(P1));
            world.write_model(@get_new_config(P2));
            world.write_model(@get_new_config(P3));

            world.write_model(@get_player_bag(P1));
        }

        // Helper to read NewMoves
        fn read_new_moves(self: @ContractState, player: ContractAddress) -> NewMoves {
            let world = self.world(@"ns");
            world.read_model(player)
        }

        // Helper to read NewPlayerConfig
        fn read_new_player_config(
            self: @ContractState, player: ContractAddress,
        ) -> NewPlayerConfig {
            let world = self.world(@"ns");
            world.read_model(player)
        }

        // This function should be called after these steps:
        // - migrate the dojo-store-example 1.5.0 world,
        // - call the `write_data` system,
        // - migrate the dojo-store-example 1.6.0 world to upgrade everything,
        // - call the `write_new_data` system,
        // - call this check_migration system.
        fn check_migration(self: @ContractState) {
            let world = self.world(@"ns");

            // for legacy models:
            // enum default value is always the first variant with all variant data set to 0.
            // option default value is always `Some` with variant data set to 0.
            check_default_move(world.read_model(999));
            check_default_config(world.read_model(999));

            // read values for existing legacy models must return the same values than in 1.5.0
            let moves_1: Moves = world.read_model(P1);
            let moves_2: Moves = world.read_model(P2);
            let moves_3: Moves = world.read_model(P3);
            let moves_4: Moves = world.read_model(P4);

            assert!(moves_1 == get_moves(P1), "Bad moves 1");
            assert!(moves_2 == get_moves(P2), "Bad moves 2");
            assert!(moves_3 == get_moves(P3), "Bad moves 3");
            assert!(moves_4 == get_moves(P4), "Bad moves 4");

            let config_1: PlayerConfig = world.read_model(P1);
            let config_2: PlayerConfig = world.read_model(P2);
            let config_3: PlayerConfig = world.read_model(P3);

            assert!(config_1 == get_config(P1), "Bad config 1");
            assert!(config_2 == get_config(P2), "Bad config 2");
            assert!(config_3 == get_config(P3), "Bad config 3");

            // for new models using DojoStore (default storage system),
            // enum default value is the one defined using the `Default` trait,
            // Option<T> default value is None.
            check_new_default_move(world.read_model(999));
            check_new_default_config(world.read_model(999));
            check_default_player_bag(world.read_model(999));

            // read values for existing legacy models must return the same values than in 1.5.0
            let moves_1: NewMoves = world.read_model(P1);
            let moves_2: NewMoves = world.read_model(P2);
            let moves_3: NewMoves = world.read_model(P3);
            let moves_4: NewMoves = world.read_model(P4);

            assert!(moves_1 == get_new_moves(P1), "Bad new moves 1");
            assert!(moves_2 == get_new_moves(P2), "Bad new moves 2");
            assert!(moves_3 == get_new_moves(P3), "Bad new moves 3");
            assert!(moves_4 == get_new_moves(P4), "Bad new moves 4");

            let config_1: NewPlayerConfig = world.read_model(P1);
            let config_2: NewPlayerConfig = world.read_model(P2);
            let config_3: NewPlayerConfig = world.read_model(P3);

            assert!(config_1 == get_new_config(P1), "Bad new config 1");
            assert!(config_2 == get_new_config(P2), "Bad new config 2");
            assert!(config_3 == get_new_config(P3), "Bad new config 3");

            // read values for the new PlayerBag model
            let bag_1: PlayerBag = world.read_model(P1);
            assert!(bag_1 == get_player_bag(P1), "Bad player bag 1");
        }
    }
}
