#[contract]
mod ERC721Preset3 {
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

    // Import Base ERC721 contract
    use src::ERC721::IERC721; // Import IERC721 interface
    use src::ERC721::ERC721Impl; // Import ERC721Base implementation
    use src::ERC721; // Import ERC721 contract (storage, events ,etc)

    //TODO remove once in corelib
    impl StorageAccessU64 of StorageAccess::<u64> {
        fn read(address_domain: felt, base: StorageBaseAddress) -> Result::<u64, Array::<felt>> {
            Result::Ok(
                StorageAccess::<felt>::read(
                    address_domain, base
                )?.try_into().expect('StorageAccessU64 - non u64')
            )
        }
        #[inline(always)]
        fn write(
            address_domain: felt, base: StorageBaseAddress, value: u64
        ) -> Result::<(), Array::<felt>> {
            StorageAccess::<felt>::write(address_domain, base, value.into())
        }
    }


    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    // Storage imported from IERC721
    struct Storage {
        total_supply: u128,
        max_supply: u128,
        max_date: u64
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    // Events imported from IERC721

    ////////////////////////////////
    // TRAIT
    ////////////////////////////////

    trait IERC721Preset3 {
        fn constructor(name_: felt, symbol_: felt, max_supply: u128, max_date: u64);
        fn mint(to: ContractAddress, token_id: u256);
    }

    impl ERC721Preset3Impl of IERC721Preset3 {
        #[constructor]
        fn constructor(name_: felt, symbol_: felt, max_supply_: u128, max_date_: u64) {
            IERC721::constructor(name_, symbol_);
            max_supply::write(max_supply_);
            max_date::write(max_date_);
        }

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
