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
        

        (*
            The assertion should state that for all elements in the input array, if the element is equal to the target
            and the found index value is equal to the element's index, then that implies that there is NO element after said element
            that is equal to target.
        *)
        assert (\A x \in 1..Len(input) : 
        ((input[x] = target)/\ ( index = x)) => (~(\E y \in (x+1)..Len(input) : input[y] = target)));
    
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "5bfc4dae" /\ chksum(tla) = "17956fe1")
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
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              ((input[x] = target)/\ ( index = x)) => (~(\E y \in (x+1)..Len(input) : input[y] = target))), 
                              "Failure of assertion at line 30, column 9.")
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
\* Last modified Sat Mar 04 23:56:52 EST 2023 by jorra04
\* Created Fri Mar 03 18:49:44 EST 2023 by jorra04
