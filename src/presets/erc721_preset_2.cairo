#[abi]
trait IERC721Preset2 {
    fn constructor(
        name_: felt,
        symbol_: felt,
        max_supply: u128,
        max_date: u64,
        whitelited_collection_: ContractAddress
    );
    fn mint(to: ContractAddress, token_id: u256);
}

#[contract]
mod ERC721Preset2 {
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

    // Import Base ERC721 contract
    use src::ERC721::IERC721; // Import IERC721 interface
    use src::interfaces::IERC721Dispatcher; // Import IERC721 dispatcher interface
    use src::ERC721::ERC721Impl; // Import ERC721Base implementation
    use src::ERC721; // Import ERC721 contract (storage, events ,etc)

    use super::IERC721Preset2;


    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    // Storage imported from IERC721
    struct Storage {
        total_supply: u128,
        max_supply: u128,
        max_date: u64,
        whitelited_collection: ContractAddress,
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    // Events imported from IERC721

    ////////////////////////////////
    // TRAIT
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

    impl ERC721Preset2Impl of IERC721Preset2 {
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

        #[external]
        fn mint(to: ContractAddress, token_id: u256) {
            //TODO assert only contract owner
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
