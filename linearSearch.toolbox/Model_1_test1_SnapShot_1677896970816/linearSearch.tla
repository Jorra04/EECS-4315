---------------------------- MODULE linearSearch ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, target


(*
--algorithm linearSearch {

    variable index = -1,
    i = 1;
    
    {
        
        assert /\ (i = 1) /\ (index = -1) /\ (Len(input) > 0);
        
        while(i <= Len(input)) {
            if(input[i] = target) {
                index := i;
            };
            
            i := i + 1;
        };
        

            assert (\A x \in 1..Len(input) : IF input[x] = target
            THEN x = index
            ELSE index = -1);
    
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "b0715601" /\ chksum(tla) = "6a1ff28d")
VARIABLES index, i, pc

vars == << index, i, pc >>

Init == (* Global variables *)
        /\ index = -1
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (i = 1) /\ (index = -1) /\ (Len(input) > 0), 
                   "Failure of assertion at line 14, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << index, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] = target
                          THEN /\ index' = i
                          ELSE /\ TRUE
                               /\ index' = index
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) : IF input[x] = target
                              THEN x = index
                              ELSE index = -1), 
                              "Failure of assertion at line 25, column 13.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << index, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Mar 03 21:29:25 EST 2023 by jorra04
\* Created Fri Mar 03 18:49:44 EST 2023 by jorra04
