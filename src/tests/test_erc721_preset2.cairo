use src::presets::interfaces::IERC721Preset2;
use src::ERC721Preset2; // Import contract
use src::ERC721Preset2::ERC721Preset2Impl;
use src::ERC721Preset2::IERC721;
use zeroable::Zeroable;
use starknet::get_caller_address;
use src::corelib_extension::ContractAddressPartialEq;
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
    IERC721Preset2::constructor('Foo', 'BAR', 3_u128, 100_u64, 0.try_into().unwrap());
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    IERC721Preset2::mint(me, nft_id);
    let owner = IERC721::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
    assert(ERC721Preset2::total_supply::read() == 1_u128, 'wrong total supply');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MAX_SUPPLY_REACHED', ))]
fn test_mint_above_max_supply() {
    IERC721Preset2::constructor('Foo', 'BAR', 2_u128, 100_u64, 0.try_into().unwrap());
    let me: ContractAddress = 123.try_into().unwrap();

    IERC721Preset2::mint(me, 1.into());
    IERC721Preset2::mint(me, 2.into());
    IERC721Preset2::mint(me, 3.into());
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MINTING_PERIOD_OVER', ))]
fn test_mint_above_limit_date() {
    IERC721Preset2::constructor('Foo', 'BAR', 3_u128, 0_u64, 0.try_into().unwrap());
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    starknet_testing::set_block_timestamp(1_u64);
    IERC721Preset2::mint(me, nft_id);
}
//TODO not yet cairo1-compatible
// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('NOT_OWNER', ))]
// fn test_mint_not_whitelisted_collection_owner() {
//     IERC721Preset2::constructor('Foo', 'BAR', 3_u128, 100_u64, 0.try_into().unwrap());
//     let me: ContractAddress = 123.try_into().unwrap();
//     let nft_id: u256 = 1.into();

//     IERC721Preset2::mint(me, nft_id);
// }


