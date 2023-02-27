use src::contracts::ERC721Preset2Contract;
use src::contracts::ERC721Preset2Contract::ERC721Preset2Library;
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
    ERC721Preset2Contract::constructor('Foo', 'BAR', 3_u128, 100_u64, 0.try_into().unwrap());
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    ERC721Preset2Contract::mint(me, nft_id);
    let owner = ERC721Preset2Contract::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
    assert(
        ERC721Preset2Contract::ERC721Preset2Library::total_supply::read() == 1_u128,
        'wrong total supply'
    );
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MAX_SUPPLY_REACHED', ))]
fn test_mint_above_max_supply() {
    ERC721Preset2Contract::constructor('Foo', 'BAR', 2_u128, 100_u64, 0.try_into().unwrap());
    let me: ContractAddress = 123.try_into().unwrap();

    ERC721Preset2Contract::mint(me, 1.into());
    ERC721Preset2Contract::mint(me, 2.into());
    ERC721Preset2Contract::mint(me, 3.into());
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MINTING_PERIOD_OVER', ))]
fn test_mint_above_limit_date() {
    ERC721Preset2Contract::constructor('Foo', 'BAR', 3_u128, 0_u64, 0.try_into().unwrap());
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    starknet_testing::set_block_timestamp(1_u64);
    ERC721Preset2Contract::mint(me, nft_id);
}
//TODO not yet cairo1-compatible
// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('NOT_OWNER', ))]
// fn test_mint_not_whitelisted_collection_owner() {
//     ERC721Preset2Contract::constructor('Foo', 'BAR', 3_u128, 100_u64, 0.try_into().unwrap());
//     let me: ContractAddress = 123.try_into().unwrap();
//     let nft_id: u256 = 1.into();

//     ERC721Preset2Contract::mint(me, nft_id);
// }


