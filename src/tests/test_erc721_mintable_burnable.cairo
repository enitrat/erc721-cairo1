use src::ERC721MintableBurnable::IERC721MintableBurnable;
use src::ERC721MintableBurnable::IERC721;
use src::ERC721MintableBurnable::ERC721;
use zeroable::Zeroable;
use starknet::get_caller_address;
use starknet::ContractAddressZeroable;
use starknet::ContractAddressIntoFelt;
use starknet::FeltTryIntoContractAddress;
use traits::Into;
use traits::TryInto;
use array::ArrayTrait;
use option::OptionTrait;

#[test]
#[available_gas(2000000)]
fn test_mint() {
    IERC721::constructor('Foo', 'BAR');
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    IERC721MintableBurnable::mint(me, nft_id);
    let owner = IERC721::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('TOKEN_NOT_EXISTS', ))]
fn test_burn() {
    IERC721::constructor('Foo', 'BAR');
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();
    IERC721MintableBurnable::mint(me, nft_id);
    let owner = IERC721::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
    IERC721MintableBurnable::burn(nft_id);
    let owner = IERC721::owner_of(nft_id);
}
