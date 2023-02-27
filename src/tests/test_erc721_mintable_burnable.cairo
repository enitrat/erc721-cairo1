use src::contracts::ERC721MintableBurnableContract;

use zeroable::Zeroable;
use starknet::get_caller_address;
use starknet::ContractAddressZeroable;
use starknet::ContractAddressIntoFelt;
use src::corelib_extension::ContractAddressPartialEq;
use starknet::FeltTryIntoContractAddress;
use traits::Into;
use traits::TryInto;
use array::ArrayTrait;
use option::OptionTrait;


#[test]
#[available_gas(2000000)]
fn test_mint() {
    ERC721MintableBurnableContract::constructor('Foo', 'BAR');
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    ERC721MintableBurnableContract::mint(me, nft_id);
    let owner = ERC721MintableBurnableContract::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('TOKEN_NOT_EXISTS', ))]
fn test_burn() {
    ERC721MintableBurnableContract::constructor('Foo', 'BAR');
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();
    ERC721MintableBurnableContract::mint(me, nft_id);
    let owner = ERC721MintableBurnableContract::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
    ERC721MintableBurnableContract::burn(nft_id);
    let owner = ERC721MintableBurnableContract::owner_of(nft_id);
}
