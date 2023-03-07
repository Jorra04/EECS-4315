------------------------------ MODULE move34s ------------------------------
EXTENDS Integers, Sequences, TLC, FiniteSets
CONSTANT input

(*
--algorithm move34s {
    variable output = input, i = 2, indexOfFour = -1, j= 1;
    
    
    {
        assert (Cardinality({\A x \in 1..Len(input) : (input[x] = 3)}) = Cardinality({\A x \in 1..Len(input) : (input[x] = 4)}));
        assert (\A x \in 1..Len(input)-1 :
        (input[x] = 3) => (input[x+1] # 3));
        
        assert (\A x \in 1..Len(input): 
        (input[x] = 3) => ~(\E y \in 1..x-1 : (x = 4))
        ); 

\*        assert (\A x \in 1..Len(input)-1 : 
\*        (output[x] = 3) => (output[x+1] = 4)
\*        );
\*        
\*        assert (\A x \in 1..Len(input) : 
\*        (input[x] = 3) => (output[x] = 3)
\*        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "cbbe4477" /\ chksum(tla) = "6ca89ff1")
VARIABLES output, i, indexOfFour, j, pc

vars == << output, i, indexOfFour, j, pc >>

Init == (* Global variables *)
        /\ output = input
        /\ i = 2
        /\ indexOfFour = -1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert((Cardinality({\A x \in 1..Len(input) : (input[x] = 3)}) = Cardinality({\A x \in 1..Len(input) : (input[x] = 4)})), 
                   "Failure of assertion at line 11, column 9.")
         /\ Assert(       (\A x \in 1..Len(input)-1 :
                   (input[x] = 3) => (input[x+1] # 3)), 
                   "Failure of assertion at line 12, column 9.")
         /\ Assert(       (\A x \in 1..Len(input):
                   (input[x] = 3) => ~(\E y \in 1..x-1 : (x = 4))
                   ), "Failure of assertion at line 15, column 9.")
         /\ pc' = "Done"
         /\ UNCHANGED << output, i, indexOfFour, j >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 22:08:58 EST 2023 by jorra04
\* Created Mon Mar 06 21:49:31 EST 2023 by jorra04
