#[contract]
mod ERC721Contract {
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddressZeroable;
    use starknet::ContractAddressIntoFelt;
    use src::corelib_extension::ContractAddressPartialEq;
    use starknet::FeltTryIntoContractAddress;
    use starknet::contract_address_try_from_felt;
    use traits::Into;
    use traits::TryInto;
    use array::ArrayTrait;
    use option::OptionTrait;

    use src::interfaces::IERC721;
    use src::corelib_extension::StorageAccessContractAddress;

    use src::libraries::erc721_library::ERC721Library;
    use src::libraries::erc721_library::ERC721Library::ERC721Impl;


    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    // From library
    // use src::libraries::erc721_library::ERC721Library::name;
    // use src::libraries::erc721_library::ERC721Library::symbol;
    // use src::libraries::erc721_library::ERC721Library::token_uri;
    // use src::libraries::erc721_library::ERC721Library::token_approvals;
    // use src::libraries::erc721_library::ERC721Library::owners;
    // use src::libraries::erc721_library::ERC721Library::balances;
    // use src::libraries::erc721_library::ERC721Library::operator_approvals;

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    //TODO find if there's a way to avoid c/c from library

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, approved: ContractAddress, token_id: u256) {}

    #[event]
    fn ApprovalForAll(owner: ContractAddress, operator: ContractAddress, approved: bool) {}

    ////////////////////////////////
    // TRAIT
    ////////////////////////////////

    ////////////////////////////////
    // CONSTRUCTOR
    ////////////////////////////////

    #[constructor]
    fn constructor(name_: felt, symbol_: felt) {
        IERC721::constructor(name_, symbol_);
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
}