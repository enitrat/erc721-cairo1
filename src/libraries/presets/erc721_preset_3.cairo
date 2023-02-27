#[contract]
mod ERC721Preset3Library {
    // Import core library requirements
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddressZeroable;
    use starknet::ContractAddressIntoFelt;
    use starknet::FeltTryIntoContractAddress;
    use starknet::contract_address_try_from_felt;
    use starknet::StorageAccess;
    use starknet::StorageBaseAddress;
    use starknet::get_block_timestamp;
    use traits::Into;
    use traits::TryInto;
    use array::ArrayTrait;
    use option::OptionTrait;

    use src::corelib_extension::StorageAccessContractAddress;

    // Import Base ERC721 contract
    use src::interfaces::IERC721; // Import IERC721 interface
    use src::libraries::ERC721Library::ERC721Impl; // Import ERC721Base implementation
    use src::interfaces::IERC721Dispatcher;

    use src::interfaces::IERC721Preset3;
    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    struct Storage {
        total_supply: u128,
        max_supply: u128,
        max_date: u64
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    // No extra events are required for this contract

    impl ERC721Preset3Impl of IERC721Preset3 {
        ////////////////////////////////
        // CONSTRUCTOR
        ////////////////////////////////

        fn constructor(name_: felt, symbol_: felt, max_supply_: u128, max_date_: u64) {
            IERC721::constructor(name_, symbol_);
            max_supply::write(max_supply_);
            max_date::write(max_date_);
        }
        ////////////////////////////////
        // EXTERNAL FUNCTIONS
        ////////////////////////////////

        #[external]
        fn mint(to: ContractAddress, token_id: u256) {
            let total_supply = total_supply::read();
            assert(total_supply < max_supply::read(), 'MAX_SUPPLY_REACHED');
            assert(get_block_timestamp() < max_date::read(), 'MINTING_PERIOD_OVER');
            IERC721::_mint(to, token_id);
            total_supply::write(total_supply + 1_u128);
        }
    }
}
