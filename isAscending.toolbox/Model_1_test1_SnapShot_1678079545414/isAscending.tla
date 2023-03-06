---------------------------- MODULE isAscending ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
    --algorithm isAscending {
        variable ascending = TRUE,
        i = 1;
        
        {
            while(i < Len(input)) {
            if(input[i] > input[i+1]) {
                ascending := FALSE;
            };
            i := i + 1;
        };
        
        assert ((ascending = TRUE) => (\A x \in 1..Len(input)-1 : input[x] < input[x+1]));
        }
    }
*)
\* BEGIN TRANSLATION (chksum(pcal) = "aa607655" /\ chksum(tla) = "3e9c9e5e")
VARIABLES ascending, i, pc

vars == << ascending, i, pc >>

Init == (* Global variables *)
        /\ ascending = TRUE
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i < Len(input)
               THEN /\ IF input[i] > input[i+1]
                          THEN /\ ascending' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED ascending
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(((ascending = TRUE) => (\A x \in 1..Len(input)-1 : input[x] < input[x+1])), 
                              "Failure of assertion at line 18, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << ascending, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 00:11:52 EST 2023 by jorra04
\* Created Mon Mar 06 00:06:24 EST 2023 by jorra04
