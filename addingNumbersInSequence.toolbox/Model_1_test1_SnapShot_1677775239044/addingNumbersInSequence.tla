---------------------- MODULE addingNumbersInSequence ----------------------
EXTENDS Integers, Sequences, TLC
CONSTANT bound

(*
--algorithm addNumbersInOrder {
    variable i = 0,
    array = <<>>;
    
    {
        assert /\ (Len(array) = 0 /\ i =0);
    
        while(i < bound) {
            array:= Append(array, i);
            i := i + 1;
        };
        
        assert /\ ((Len(array) = bound) /\ (\A x \in 1..Len(array) -1 : array[x] = (array[x] + 1) ));
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "e31e9cd5" /\ chksum(tla) = "a07ccaf7")
VARIABLES i, array, pc

vars == << i, array, pc >>

Init == (* Global variables *)
        /\ i = 0
        /\ array = <<>>
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (Len(array) = 0 /\ i =0), 
                   "Failure of assertion at line 11, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, array >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i < bound
               THEN /\ array' = Append(array, i)
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(/\ ((Len(array) = bound) /\ (\A x \in 1..Len(array) -1 : array[x] = (array[x] + 1) )), 
                              "Failure of assertion at line 18, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, array >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Thu Mar 02 11:34:34 EST 2023 by jorra04
\* Created Thu Mar 02 11:17:18 EST 2023 by jorra04
