use src::presets::interfaces::IERC721Preset3;
use src::ERC721Preset3; // Import contract
use src::ERC721Preset3::ERC721Preset3Impl;
use src::ERC721Preset3::IERC721;
use zeroable::Zeroable;
use starknet::get_caller_address;
use starknet::ContractAddressZeroable;
use starknet::contract_address::ContractAddressPartialEq;
use starknet::ContractAddressIntoFelt;
use starknet::FeltTryIntoContractAddress;
use traits::Into;
use traits::TryInto;
use array::ArrayTrait;
use option::OptionTrait;

#[test]
#[available_gas(2000000)]
fn test_mint() {
    IERC721Preset3::constructor('Foo', 'BAR', 3_u128, 100_u64);
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    IERC721Preset3::mint(me, nft_id);
    let owner = IERC721::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
    assert(ERC721Preset3::total_supply::read() == 1_u128, 'wrong total supply');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MAX_SUPPLY_REACHED', ))]
fn test_mint_above_max_supply() {
    IERC721Preset3::constructor('Foo', 'BAR', 2_u128, 100_u64);
    let me: ContractAddress = 123.try_into().unwrap();

    IERC721Preset3::mint(me, 1.into());
    IERC721Preset3::mint(me, 2.into());
    IERC721Preset3::mint(me, 3.into());
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MINTING_PERIOD_OVER', ))]
fn test_mint_above_limit_date() {
    IERC721Preset3::constructor('Foo', 'BAR', 3_u128, 1_u64);
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    starknet_testing::set_block_timestamp(1_u64);
    IERC721Preset3::mint(me, nft_id);
}
