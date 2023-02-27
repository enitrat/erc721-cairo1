#[contract]
mod ERC721MintableBurnableLibrary {
    // Import core library requirements
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddressZeroable;
    use starknet::ContractAddressIntoFelt;
    use starknet::FeltTryIntoContractAddress;
    use starknet::contract_address_try_from_felt;
    use traits::Into;
    use traits::TryInto;
    use array::ArrayTrait;
    use option::OptionTrait;

    use src::corelib_extension::StorageAccessContractAddress;

    // Import Base ERC721 contract
    use src::interfaces::IERC721; // Import IERC721 interface
    use src::libraries::ERC721Library::ERC721Impl; // Import ERC721Base implementation

    use src::interfaces::IERC721MintableBurnable;

    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    // Storage imported from IERC721

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    // Events imported from IERC721

    ////////////////////////////////
    // TRAIT
    ////////////////////////////////

    impl ERC721MintableBurnableImpl of IERC721MintableBurnable {
        #[external]
        fn mint(to: ContractAddress, token_id: u256) { //pass
            IERC721::_mint(to, token_id);
        }
        #[external]
        fn burn(token_id: u256) { //pass
            IERC721::_burn(token_id);
        }
    }
}
