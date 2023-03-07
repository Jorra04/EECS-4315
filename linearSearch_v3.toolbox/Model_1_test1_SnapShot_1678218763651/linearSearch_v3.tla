-------------------------- MODULE linearSearch_v3 --------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, target

(*
--algorithm linearSearch_v3 {

    variable index = -1,
    i = 1;
    
    {
    \* assert that there are no duplicate elements.
        assert ~(\E x,y \in 1..Len(input) : 
        (x # y) /\ (input[x] = input[y])
        );
        
        \* assert that the length is gt than 0
        assert (Len(input) > 0);
        
        while(i <= Len(input)) {
            if(input[i] = target) {
                index := i;
            };
            i := i + 1;
        };
        
        assert IF index = -1
        THEN ~(\E x \in 1..Len(input) : (input[x] = target))
        ELSE (\E x \in 1..Len(input) : ((input[x] = target) /\ (index = x) ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "6cf96bd2" /\ chksum(tla) = "b297f473")
VARIABLES index, i, pc

vars == << index, i, pc >>

Init == (* Global variables *)
        /\ index = -1
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(       ~(\E x,y \in 1..Len(input) :
                   (x # y) /\ (input[x] = input[y])
                   ), "Failure of assertion at line 13, column 9.")
         /\ Assert((Len(input) > 0), 
                   "Failure of assertion at line 18, column 9.")
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
               ELSE /\ Assert(       IF index = -1
                              THEN ~(\E x \in 1..Len(input) : (input[x] = target))
                              ELSE (\E x \in 1..Len(input) : ((input[x] = target) /\ (index = x) )), 
                              "Failure of assertion at line 27, column 9.")
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
\* Last modified Tue Mar 07 14:52:37 EST 2023 by jorra04
\* Created Tue Mar 07 14:39:26 EST 2023 by jorra04
