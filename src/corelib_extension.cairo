//TODO remove this file once these functionalities are implemented in the corelib

use starknet::FeltTryIntoContractAddress;
use starknet::ContractAddressIntoFelt;
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
