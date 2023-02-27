#[contract]
mod ERC721Preset3Contract {
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

    // Import Base ERC721 contract
    use src::interfaces::IERC721; // Import IERC721 interface
    use src::libraries::erc721_library::ERC721Library::ERC721Impl;

    use src::interfaces::IERC721Preset3;
    use src::libraries::ERC721Preset3Library;
    use src::libraries::ERC721Preset3Library::ERC721Preset3Impl;

    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    // Storage imported from IERC721
    
    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, approved: ContractAddress, token_id: u256) {}

    #[event]
    fn ApprovalForAll(owner: ContractAddress, operator: ContractAddress, approved: bool) {}

    ////////////////////////////////
    // CONSTRUCTOR
    ////////////////////////////////

    #[constructor]
    fn constructor(name_: felt, symbol_: felt, max_supply: u128, max_date: u64) {
        IERC721Preset3::constructor(name_, symbol_, max_supply, max_date);
    }

    ////////////////////////////////
    // VIEW FUNCTIONS
    ////////////////////////////////

    #[view]
    fn get_name() -> felt {
        IERC721::get_name()
    }

    #[view]
    fn get_symbol() -> felt {
        IERC721::get_symbol()
    }

    #[view]
    fn balance_of(owner: ContractAddress) -> u256 {
        IERC721::balance_of(owner)
    }

    #[view]
    fn owner_of(token_id: u256) -> ContractAddress {
        IERC721::owner_of(token_id)
    }

    #[view]
    fn get_approved(token_id: u256) -> ContractAddress {
        IERC721::get_approved(token_id)
    }

    #[view]
    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool {
        IERC721::is_approved_for_all(owner, operator)
    }

    #[view]
    fn get_token_uri(token_id: u256) -> felt {
        IERC721::get_token_uri(token_id)
    }

    ////////////////////////////////
    // EXTERNAL FUNCTIONS
    ////////////////////////////////

    #[external]
    fn approve(to: ContractAddress, token_id: u256) {
        IERC721::approve(to, token_id);
    }


    #[external]
    fn set_approval_for_all(operator: ContractAddress, approved: bool) {
        IERC721::set_approval_for_all(operator, approved);
    }

    #[external]
    fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256) {
        IERC721::transfer_from(from, to, token_id);
    }

    #[external]
    fn safe_transfer_from(
        from: ContractAddress, to: ContractAddress, token_id: u256, data: Array::<felt>
    ) {
        IERC721::safe_transfer_from(from, to, token_id, data);
    }

    #[external]
    fn mint(to: ContractAddress, token_id: u256) { //pass
        IERC721Preset3::mint(to, token_id);
    }
}
