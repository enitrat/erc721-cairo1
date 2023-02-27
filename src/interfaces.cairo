use starknet::contract_address::ContractAddressSerde;
#[abi]
trait IERC721 {
    fn constructor(name_: felt, symbol_: felt);
    fn get_name() -> felt;
    fn get_symbol() -> felt;
    fn balance_of(owner: ContractAddress) -> u256;
    fn owner_of(token_id: u256) -> ContractAddress;
    fn get_approved(token_id: u256) -> ContractAddress;
    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool;
    fn get_token_uri(token_id: u256) -> felt;
    fn approve(to: ContractAddress, token_id: u256);
    fn set_approval_for_all(operator: ContractAddress, approved: bool);
    fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256);
    // fn safe_transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256);
    fn safe_transfer_from(
        from: ContractAddress, to: ContractAddress, token_id: u256, data: Array::<felt>
    );
    fn assert_only_token_owner(token_id: u256);
    fn is_approved_or_owner(spender: ContractAddress, token_id: u256) -> bool;
    fn _approve(to: ContractAddress, token_id: u256);
    fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256);
    fn _mint(to: ContractAddress, token_id: u256);
    fn _burn(token_id: u256);
    fn _set_token_uri(token_id: u256, token_uri: felt);
}

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

#[abi]
trait IERC721Preset3 {
    fn constructor(name_: felt, symbol_: felt, max_supply: u128, max_date: u64);
    fn mint(to: ContractAddress, token_id: u256);
}

#[abi]
trait IERC721MintableBurnable {
    fn mint(to: ContractAddress, token_id: u256);
    fn burn(token_id: u256);
}

#[abi]
trait IERC721Receiver {
    fn on_erc721_received(
        operator: ContractAddress, from_: ContractAddress, token_id: u256, data: Array::<felt>
    ) -> felt;
}

#[abi]
trait IERC165 {
    fn supports_interface(interface_id: felt) -> bool;
}

#[abi]
trait IOwnable {
    fn initializer(owner_: ContractAddress);
    fn assert_only_owner();
    fn get_owner() -> ContractAddress;
    fn transfer_ownership(new_owner: ContractAddress);
    fn renounce_ownership();
    fn _transfer_ownership(new_owner: ContractAddress);
}
