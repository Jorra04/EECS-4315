---------------------- MODULE Lab2_Example_2_Find_Max ----------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm FindMax {
    variables
    result = input[1], \* Tupls start their indices at 1.
    i = 1;
    {
        \* precondition
        precondition: assert Len(input) > 0;
        
        loop: while(i =< Len(input)) {
            decision: if(input[i] > result) { result := input[i];};
            increment: i := i + 1;
        };
        
        \* Postcondition
        postcondition: assert \A j \in 1..Len(input): result >= input[j]
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "14246d7" /\ chksum(tla) = "c78f208f")
VARIABLES result, i, pc

vars == << result, i, pc >>

Init == (* Global variables *)
        /\ result = input[1]
        /\ i = 1
        /\ pc = "precondition"

precondition == /\ pc = "precondition"
                /\ Assert(Len(input) > 0, 
                          "Failure of assertion at line 12, column 23.")
                /\ pc' = "loop"
                /\ UNCHANGED << result, i >>

loop == /\ pc = "loop"
        /\ IF i =< Len(input)
              THEN /\ pc' = "decision"
              ELSE /\ pc' = "postcondition"
        /\ UNCHANGED << result, i >>

decision == /\ pc = "decision"
            /\ IF input[i] > result
                  THEN /\ result' = input[i]
                  ELSE /\ TRUE
                       /\ UNCHANGED result
            /\ pc' = "increment"
            /\ i' = i

increment == /\ pc = "increment"
             /\ i' = i + 1
             /\ pc' = "loop"
             /\ UNCHANGED result

postcondition == /\ pc = "postcondition"
                 /\ Assert(\A j \in 1..Len(input): result >= input[j], 
                           "Failure of assertion at line 20, column 24.")
                 /\ pc' = "Done"
                 /\ UNCHANGED << result, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == precondition \/ loop \/ decision \/ increment \/ postcondition
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Tue Feb 21 17:12:23 EST 2023 by jorra04
\* Created Tue Feb 21 17:05:50 EST 2023 by jorra04
