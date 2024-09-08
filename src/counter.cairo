#[starknet::interface]
trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
}

#[starknet::contract]
pub mod counter_contract {
    #[storage]
    struct Storage {
        counter : u32,
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncrease,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncrease {
        #[key]
        value: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value : u32 ){
        self.counter.write(initial_value);
    }

    #[abi(embed_v0)]
    impl counter_contract of super::ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            // self.ownable.assert_only_owner();
            
        //     let kill_switch_dispatcher = IKillSwitchDispatcher {
        //         contract_address: self.kill_switch.read()
        //     };

        //     assert!(!kill_switch_dispatcher.is_active(), "Kill Switch is active");
            let incremented_counter = self.counter.read() + 1;
            self.counter.write(incremented_counter);

            self.emit(Event::CounterIncreased(CounterIncrease { value: self.counter.read() }));
        }
    }
}