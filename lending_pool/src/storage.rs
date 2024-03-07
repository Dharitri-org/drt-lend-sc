dharitri_sc::imports!();

use common_structs::{BorrowPosition, DepositPosition};

#[dharitri_sc::module]
pub trait LendingStorageModule {
    #[view(getDepositPositions)]
    #[storage_mapper("deposit_positions")]
    fn deposit_positions(
        &self,
        owner_nonce: u64,
    ) -> MapMapper<TokenIdentifier, DepositPosition<Self::Api>>;

    #[view(getBorrowPositions)]
    #[storage_mapper("borrow_positions")]
    fn borrow_positions(
        &self,
        owner_nonce: u64,
    ) -> MapMapper<TokenIdentifier, BorrowPosition<Self::Api>>;
}
