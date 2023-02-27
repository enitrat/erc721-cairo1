use starknet::contract_address::ContractAddressSerde;
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
