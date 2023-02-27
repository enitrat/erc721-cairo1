use src::contracts::ERC721Contract;
use src::contracts::ERC721Contract::ERC721Library;

use src::corelib_extension::ContractAddressPartialEq;
use zeroable::Zeroable;
use starknet::get_caller_address;

use starknet::ContractAddressZeroable;
use starknet::ContractAddressIntoFelt;
use starknet::FeltTryIntoContractAddress;
use traits::Into;
use traits::TryInto;
use array::ArrayTrait;
use option::OptionTrait;

////////////////////////////////
// VIEWS
////////////////////////////////
#[test]
#[available_gas(2000000)]
fn test_get_name() {
    ERC721Contract::constructor('Foo', 'BAR');

    assert(ERC721Contract::get_name() == 'Foo', 'wrong name');
}

#[test]
#[available_gas(2000000)]
fn test_get_symbol() {
    ERC721Contract::constructor('Foo', 'BAR');

    assert(ERC721Contract::get_symbol() == 'BAR', 'wrong symbol');
}

#[test]
#[available_gas(2000000)]
fn test_balance_of() {
    ERC721Contract::constructor('Foo', 'BAR');
    let me: felt = 123;
    ERC721Library::balances::write(me, 1.into());

    let balance = ERC721Contract::balance_of(me.try_into().unwrap());
    assert(balance == 1.into(), 'wrong balance');
}

#[test]
#[available_gas(2000000)]
fn test_owner_of() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = integer::u256_from_felt(1);
    ERC721Library::owners::write(nft_id, 123);

    let owner = ERC721Contract::owner_of(nft_id);
    assert(owner.into() == 123, 'wrong owner');
}

#[test]
#[available_gas(2000000)]
fn test_get_approved() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = 1.into();
    let me: felt = 123;
    ERC721Library::owners::write(nft_id, me);
    ERC721Library::balances::write(me, 1.into());

    let me: ContractAddress = me.try_into().unwrap();
    let friend: ContractAddress = 456.try_into().unwrap();

    starknet_testing::set_caller_address(me);
    ERC721Contract::approve(friend, nft_id);

    let approved = ERC721Contract::get_approved(nft_id);
    assert(approved == friend, 'wrong approved');
}

#[test]
#[available_gas(2000000)]
fn test_is_approved_for_all() {
    ERC721Contract::constructor('Foo', 'BAR');
    let me: felt = 123;
    let friend: felt = 456;

    let me: ContractAddress = me.try_into().unwrap();
    let friend: ContractAddress = friend.try_into().unwrap();

    starknet_testing::set_caller_address(me);
    ERC721Contract::set_approval_for_all(friend, true);

    let is_approved = ERC721Contract::is_approved_for_all(me, friend);
    assert(is_approved, 'not approved for all');
}

#[test]
#[available_gas(2000000)]
fn test_get_token_uri() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = 1.into();
    ERC721Library::token_uri::write(nft_id, 'https://example.com/1');

    let uri = ERC721Contract::get_token_uri(nft_id);
    assert(uri == 'https://example.com/1', 'wrong uri');
}

////////////////////////////////
// EXTERNAL
////////////////////////////////

#[test]
#[available_gas(2000000)]
fn test_transfer_from() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = integer::u256_from_felt(1);
    ERC721Library::owners::write(nft_id, 123);
    ERC721Library::balances::write(123, 1.into());

    let me = starknet::contract_address_const::<123>();
    let friend = starknet::contract_address_const::<456>();
    starknet_testing::set_caller_address(me);
    ERC721Contract::transfer_from(me, friend, nft_id);

    let new_owner = ERC721Library::owners::read(nft_id);
    assert(new_owner == 456, 'wrong new owner');
}

//TODO not yet cairo1-compatible
// #[test]
// #[available_gas(2000000)]
// fn test_safe_transfer_from() {
//     ERC721Contract::constructor('Foo', 'BAR');
//     let nft_id: u256 = integer::u256_from_felt(1);
//     ERC721Library::owners::write(nft_id, 123);
//     ERC721Library::balances::write(123, 1.into());

//     let me = starknet::contract_address_const::<123>();
//     let friend = starknet::contract_address_const::<456>();
//     starknet_testing::set_caller_address(me);
//     ERC721Contract::safe_transfer_from(me, friend, nft_id, ArrayTrait::new());

//     let new_owner = ERC721Library::owners::read(nft_id);
//     assert(new_owner == 456, 'wrong new owner');
// }

#[test]
#[available_gas(2000000)]
fn test_transfer_from_approved() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = 1.into();
    let me: felt = 123;
    ERC721Library::owners::write(nft_id, me);
    ERC721Library::balances::write(me, 1.into());

    let me: ContractAddress = me.try_into().unwrap();
    let friend: ContractAddress = 456.try_into().unwrap();

    starknet_testing::set_caller_address(me);
    ERC721Contract::approve(friend, nft_id);

    starknet_testing::set_caller_address(friend);
    ERC721Contract::transfer_from(me, 789.try_into().unwrap(), nft_id);
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from_approved_for_all() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = 1.into();
    let me: felt = 123;
    ERC721Library::owners::write(nft_id, me);
    ERC721Library::balances::write(me, 1.into());

    let me: ContractAddress = me.try_into().unwrap();
    let friend: ContractAddress = 456.try_into().unwrap();

    starknet_testing::set_caller_address(me);
    ERC721Contract::approve(friend, nft_id);

    starknet_testing::set_caller_address(friend);
    ERC721Contract::transfer_from(me, 789.try_into().unwrap(), nft_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_transfer_from_not_approved() {
    ERC721Contract::constructor('Foo', 'BAR');
    let nft_id: u256 = 1.into();
    let me: felt = 123;
    ERC721Library::owners::write(nft_id, me);
    ERC721Library::balances::write(me, 1.into());

    let me: ContractAddress = me.try_into().unwrap();
    let friend: ContractAddress = 456.try_into().unwrap();
    // random caller address
    starknet_testing::set_caller_address(127846125.try_into().unwrap());
    ERC721Contract::approve(friend, nft_id);
    ERC721Contract::transfer_from(friend, starknet::contract_address_const::<789>(), nft_id);
}

