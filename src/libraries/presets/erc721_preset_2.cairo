#[contract]
mod ERC721Preset2Library {
    // Import core library requirements
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::get_contract_address;
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

    use src::interfaces::IERC721Preset2;
    use src::interfaces::IOwnable;
    use src::libraries::ownable_library::OwnableLibrary::OwnableImpl; // Import ERC721Base implementation


    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    struct Storage {
        total_supply: u128,
        max_supply: u128,
        max_date: u64,
        whitelited_collection: ContractAddress,
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    // No extra events are required for this contract

    ////////////////////////////////
    // TRAIT IMPL
    ////////////////////////////////

    impl ERC721Preset2Impl of IERC721Preset2 {
        ////////////////////////////////
        // CONSTRUCTOR
        ////////////////////////////////
        #[constructor]
        fn constructor(
            name_: felt,
            symbol_: felt,
            max_supply_: u128,
            max_date_: u64,
            whitelited_collection_: ContractAddress
        ) {
            IERC721::constructor(name_, symbol_);
            max_supply::write(max_supply_);
            max_date::write(max_date_);
            whitelited_collection::write(whitelited_collection_);
        }

        ////////////////////////////////
        // EXTERNAL FUNCTIONS
        ////////////////////////////////
        #[external]
        fn mint(to: ContractAddress, token_id: u256) {
            //TODO assert only contact owner
            let total_supply = total_supply::read();
            let caller = get_caller_address();
            let whitelited_collection = whitelited_collection::read();
            //TODO not yet implemented by cairo1.
            // assert(
            //     IERC721Dispatcher::balance_of(whitelited_collection, caller) > 0.into(),
            //     'NOT_WHITELISTED_HOLDER'
            // );
            assert(total_supply < max_supply::read(), 'MAX_SUPPLY_REACHED');
            assert(get_block_timestamp() < max_date::read(), 'MINTING_PERIOD_OVER');
            IERC721::_mint(to, token_id);
            total_supply::write(total_supply + 1_u128);
        }
    }
}
