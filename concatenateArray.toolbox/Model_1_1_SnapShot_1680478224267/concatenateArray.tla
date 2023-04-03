-------------------------- MODULE concatenateArray --------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm concatenateArr {
    variable i = 1, output = <<>>;
    
    {
        while(i <= 2 * Len(input)) {
            output := Append(output, input[(i % Len(input)) + 1]);
            i := i + 1;
        };
        
        assert Len(output) = (2 * Len(input));
        assert (\A a \in 1..Len(input) : output[a] = input[a]) /\ (\A b \in Len(input)..Len(output) : output[b] = input[(b % Len(input)) + 1]);
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "c78daffc" /\ chksum(tla) = "894d65e5")
VARIABLES i, output, pc

vars == << i, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = <<>>
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= 2 * Len(input)
               THEN /\ output' = Append(output, input[(i % Len(input)) + 1])
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(Len(output) = (2 * Len(input)), 
                              "Failure of assertion at line 15, column 9.")
                    /\ Assert((\A a \in 1..Len(input) : output[a] = input[a]) /\ (\A b \in Len(input)..Len(output) : output[b] = input[(b % Len(input)) + 1]), 
                              "Failure of assertion at line 16, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 19:30:16 EDT 2023 by jorra04
\* Created Sun Apr 02 19:03:48 EDT 2023 by jorra04
