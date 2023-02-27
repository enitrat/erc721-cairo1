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
    // fn safe_transfer_from(
    // from: ContractAddress, to: ContractAddress, token_id: u256, data: felt
    // );
    fn assert_only_token_owner(token_id: u256);
    fn is_approved_or_owner(spender: ContractAddress, token_id: u256) -> bool;
    fn _approve(to: ContractAddress, token_id: u256);
    fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256);
    fn _mint(to: ContractAddress, token_id: u256);
    fn _burn(token_id: u256);
    fn _set_token_uri(token_id: u256, token_uri: felt);
}
