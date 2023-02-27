#[contract]
mod OwnableLibrary {
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddressZeroable;
    use starknet::ContractAddressIntoFelt;
    use src::corelib_extension::ContractAddressPartialEq;
    use starknet::FeltTryIntoContractAddress;
    use starknet::contract_address_try_from_felt;
    use traits::Into;
    use traits::TryInto;
    use array::ArrayTrait;
    use option::OptionTrait;

    use src::interfaces::IOwnable;
    use src::corelib_extension::StorageAccessContractAddress;


    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    struct Storage {
        owner: felt, 
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    #[event]
    fn OwnershipTransferred(previous_owner: ContractAddress, new_owner: ContractAddress) {}

    impl OwnableImpl of IOwnable {
        ////////////////////////////////
        // CONSTRUCTOR
        ////////////////////////////////

        fn initializer(owner_: ContractAddress) {
            IOwnable::_transfer_ownership(owner_)
        }

        ////////////////////////////////
        // GUARDS
        ////////////////////////////////

        fn assert_only_owner() {
            let owner = owner::read();
            debug::print_felt(owner);
            let caller = get_caller_address();
            debug::print_felt(caller.into());
            assert(!caller.is_zero() & caller.into() == owner, 'CALLER_NOT_OWNER_OR_ZERO');
        }

        ////////////////////////////////
        // VIEW FUNCTIONS
        ////////////////////////////////

        fn get_owner() -> ContractAddress {
            owner::read().try_into().unwrap()
        }

        ////////////////////////////////
        // EXTERNAL FUNCTIONS
        ////////////////////////////////

        fn transfer_ownership(new_owner: ContractAddress) {
            assert(!new_owner.is_zero(), 'NEW_OWNER_IS_ZERO');
            IOwnable::assert_only_owner();
            IOwnable::_transfer_ownership(new_owner);
        }

        fn renounce_ownership() {
            IOwnable::assert_only_owner();
            IOwnable::_transfer_ownership(Zeroable::zero());
        }

        ////////////////////////////////
        // INTERNAL FUNCTIONS
        ////////////////////////////////

        fn _transfer_ownership(new_owner: ContractAddress) {
            let previous_owner = owner::read();
            owner::write(new_owner.into());
            OwnershipTransferred(previous_owner.try_into().unwrap(), new_owner);
        }
    }
}
