use src::contracts::ERC721Preset3Contract;
use src::contracts::ERC721Preset3Contract::ERC721Preset3Library;
use zeroable::Zeroable;
use starknet::get_caller_address;
use starknet::ContractAddressZeroable;
use src::corelib_extension::ContractAddressPartialEq;
use starknet::ContractAddressIntoFelt;
use starknet::FeltTryIntoContractAddress;
use traits::Into;
use traits::TryInto;
use array::ArrayTrait;
use option::OptionTrait;

#[test]
#[available_gas(2000000)]
fn test_mint() {
    ERC721Preset3Contract::constructor('Foo', 'BAR', 3_u128, 100_u64);
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    ERC721Preset3Contract::mint(me, nft_id);
    let owner = ERC721Preset3Contract::owner_of(nft_id);
    assert(owner == me, 'wrong owner');
    assert(ERC721Preset3Library::total_supply::read() == 1_u128, 'wrong total supply');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MAX_SUPPLY_REACHED', ))]
fn test_mint_above_max_supply() {
    ERC721Preset3Contract::constructor('Foo', 'BAR', 2_u128, 100_u64);
    let me: ContractAddress = 123.try_into().unwrap();

    ERC721Preset3Contract::mint(me, 1.into());
    ERC721Preset3Contract::mint(me, 2.into());
    ERC721Preset3Contract::mint(me, 3.into());
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('MINTING_PERIOD_OVER', ))]
fn test_mint_above_limit_date() {
    ERC721Preset3Contract::constructor('Foo', 'BAR', 3_u128, 1_u64);
    let me: ContractAddress = 123.try_into().unwrap();
    let nft_id: u256 = 1.into();

    starknet_testing::set_block_timestamp(1_u64);
    ERC721Preset3Contract::mint(me, nft_id);
}
