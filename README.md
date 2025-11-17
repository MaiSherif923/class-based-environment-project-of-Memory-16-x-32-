# class-based-environment-project-of-Memory-16-x-32-
This class-based verification environment targets a 16×32 memory, with sequencer-to-driver stimulus via mailbox and dual-event synchronization. Driver runs non-blocking at posedge; monitor samples blocking and forwards transactions to scoreboard and coverage. All classes run in parallel using fork-join_any.
