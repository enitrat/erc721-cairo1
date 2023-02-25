#[contract]
mod ERC721 {
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddressZeroable;
    use starknet::ContractAddressIntoFelt;
    // use starknet::ContractAddressPartialEq;
    use starknet::FeltTryIntoContractAddress;
    use starknet::contract_address_try_from_felt;
    use traits::Into;
    use traits::TryInto;
    use array::ArrayTrait;
    use option::OptionTrait;
    // use erc721::interfaces::IERC721ReceiverDispatcher;
    // use erc721::interfaces::IERC165Dispatcher;

    impl ContractAddressPartialEq of traits::PartialEq::<ContractAddress> {
        #[inline(always)]
        fn eq(a: ContractAddress, b: ContractAddress) -> bool {
            a.into() == b.into()
        }
        #[inline(always)]
        fn ne(a: ContractAddress, b: ContractAddress) -> bool {
            !(a == b)
        }
    }


    ////////////////////////////////
    // STORAGE
    ////////////////////////////////

    struct Storage {
        name: felt,
        symbol: felt,
        owners: LegacyMap::<u256, felt>,
        balances: LegacyMap::<felt, u256>,
        token_approvals: LegacyMap::<u256, felt>,
        operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
        token_uri: LegacyMap::<u256, felt>,
    }

    ////////////////////////////////
    // EVENTS
    ////////////////////////////////

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, approved: ContractAddress, token_id: u256) {}

    #[event]
    fn ApprovalForAll(owner: ContractAddress, operator: ContractAddress, approved: bool) {}

    ////////////////////////////////
    // CONSTRUCTOR
    ////////////////////////////////

    #[constructor]
    fn constructor(name_: felt, symbol_: felt) {
        name::write(name_);
        symbol::write(symbol_);
    }

    ////////////////////////////////
    // VIEW FUNCTIONS
    ////////////////////////////////

    #[view]
    fn get_name() -> felt {
        name::read()
    }

    #[view]
    fn get_symbol() -> felt {
        symbol::read()
    }

    #[view]
    fn balance_of(owner: felt) -> u256 {
        assert(!owner.is_zero(), 'OWNER_IS_ZERO');
        balances::read(owner)
    }

    #[view]
    fn owner_of(token_id: u256) -> ContractAddress {
        let owner = owners::read(token_id);
        assert(!owner.is_zero(), 'TOKEN_NOT_EXISTS');
        owner.try_into().unwrap()
    }

    #[view]
    fn get_approved(token_id: u256) -> ContractAddress {
        let owner = owners::read(token_id);
        assert(!owner.is_zero(), 'TOKEN_NOT_EXISTS');
        token_approvals::read(token_id).try_into().unwrap()
    }

    #[view]
    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool {
        operator_approvals::read((owner, operator, ))
    }

    #[view]
    fn get_token_uri(token_id: u256) -> felt {
        token_uri::read(token_id)
    }

    ////////////////////////////////
    // EXTERNAL FUNCTIONS
    ////////////////////////////////

    //TODO add a mint function here

    #[external]
    fn approve(to: ContractAddress, token_id: u256) {
        let caller = get_caller_address();
        assert(!caller.is_zero(), 'APPROVE_ZERO_ADDRESS');

        let owner: ContractAddress = owners::read(token_id).try_into().unwrap();
        assert(owner != to, 'APPROVAL_TO_OWNER');

        //TODO refactor this with internal _approve function
        if is_approved_or_owner(
            caller, token_id
        ) {
            _approve(to, token_id);
        } else {
            assert(false, 'CALLER_NOT_ALLOWED');
        }
    }


    #[external]
    fn set_approval_for_all(operator: ContractAddress, approved: bool) {
        let caller = get_caller_address();
        assert(!caller.is_zero() & !operator.is_zero(), 'CALLER_OR_OPERATOR_IS_ZERO');
        assert(caller != operator, 'APPROVED_TO_CALLER');
        operator_approvals::write((caller, operator), approved);
        ApprovalForAll(caller, operator, approved);
    }

    #[external]
    fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256) {
        let caller = get_caller_address();
        assert(!caller.is_zero(), 'ERC721: caller is zero');
        assert(is_approved_or_owner(caller, token_id), 'NOT_APPROVED_NOR_OWNER');

        _transfer(from, to, token_id);
    }

    //TODO check for IERC165 support
    // const IERC721_RECEIVER_ID: felt = 0x150b7a02;
    // const IACCOUNT_ID: felt = 0xa66bd575;

    // #[external]
    // fn safe_transfer_from(
    //     from: ContractAddress, to: ContractAddress, token_id: u256, data: Array::<felt>
    // ) {
    //     let caller = get_caller_address();
    //     assert(is_approved_or_owner(caller, token_id), 'ERC721: not approved');

    //     if IERC165Dispatcher::supports_interface(
    //         to, IERC721_RECEIVER_ID
    //     ) {
    //         let selector = IERC721ReceiverDispatcher::on_erc721_received(
    //             to, caller, from, token_id, data
    //         );
    //         assert(selector == IERC721_RECEIVER_ID, 'ERC721: not ERC721Receiver');
    //     } else {
    //         assert(
    //             IERC165Dispatcher::supports_interface(to, IACCOUNT_ID), 'ERC721: wrong interface'
    //         );
    //     }
    //     _transfer(from, to, token_id);
    // }

    ////////////////////////////////
    // INTERNAL_FUNCTIONS
    ////////////////////////////////

    fn assert_only_token_owner(token_id: u256) {
        let caller = get_caller_address();
        let owner: ContractAddress = owners::read(token_id).try_into().unwrap();
        assert(caller == owner, 'CALLER_NOT_OWNER');
    }

    fn is_approved_or_owner(spender: ContractAddress, token_id: u256) -> bool {
        let owner: ContractAddress = owners::read(token_id).try_into().unwrap();
        (spender == owner | get_approved(token_id) == spender | is_approved_for_all(owner, spender))
    }


    fn _approve(to: ContractAddress, token_id: u256) {
        token_approvals::write(token_id, to.into());
        Approval(owner_of(token_id), to, token_id);
    }

    fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {
        let owner = owner_of(token_id);
        assert(owner == from, 'FROM_NOT_OWNER');
        assert(!to.is_zero(), 'TO_IS_ZERO');

        // Clear approvals
        _approve(0.try_into().unwrap(), token_id);

        // Decrease owner balance
        let owner_balance = balances::read(from.into());
        balances::write(from.into(), owner_balance - 1.into());

        // Increase receiver balance
        let receiver_balance = balances::read(to.into());
        balances::write(to.into(), receiver_balance + 1.into());

        // Update token_id owner
        owners::write(token_id, to.into());
        Transfer(from, to, token_id);
    }

    fn _mint(to: ContractAddress, token_id: u256) {
        assert(!to.is_zero(), 'TO_IS_ZERO_ADDRESS');

        // Ensures token_id is unique
        assert(owners::read(token_id).is_zero(), 'TOKEN_ALREADY_MINTED');

        // Increase receiver balance
        let receiver_balance = balances::read(to.into());
        balances::write(to.into(), receiver_balance + 1.into());

        // Update token_id owner
        owners::write(token_id, to.into());
        Transfer(0.try_into().unwrap(), to, token_id);
    }

    fn _burn(token_id: u256) {
        let owner = owner_of(token_id);

        // Clear approvals
        _approve(0.try_into().unwrap(), token_id);

        // Decrease owner balance
        let owner_balance = balances::read(owner.into());
        balances::write(owner.into(), owner_balance - 1.into());

        // Delete owner
        owners::write(token_id, 0);
        Transfer(owner, 0.try_into().unwrap(), token_id);
    }
    fn _set_token_uri(token_id: u256, token_uri: felt) {
        assert(!owner_of(token_id).is_zero(), 'TOKEN_NOT_MINTED');
        token_uri::write(token_id, token_uri);
    }
}

