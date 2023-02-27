//TODO remove this file once these functionalities are implemented in the corelib

use starknet::FeltTryIntoContractAddress;
use starknet::ContractAddressIntoFelt;
use starknet::contract_address_to_felt;
use starknet::StorageAccess;
use starknet::StorageBaseAddress;
use starknet::SyscallResult;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;

impl StorageAccessContractAddress of StorageAccess::<ContractAddress> {
    fn read(address_domain: felt, base: StorageBaseAddress) -> SyscallResult::<ContractAddress> {
        Result::Ok(StorageAccess::<felt>::read(address_domain, base)?.try_into().expect('blah'))
    }
    fn write(
        address_domain: felt, base: StorageBaseAddress, value: ContractAddress
    ) -> SyscallResult::<()> {
        StorageAccess::<felt>::write(address_domain, base, value.into())
    }
}

impl ContractAddressPartialEq of PartialEq::<ContractAddress> {
    #[inline(always)]
    fn eq(a: ContractAddress, b: ContractAddress) -> bool {
        contract_address_to_felt(a) == contract_address_to_felt(b)
    }
    #[inline(always)]
    fn ne(a: ContractAddress, b: ContractAddress) -> bool {
        !(a == b)
    }
}

