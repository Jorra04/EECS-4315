-------------------------- MODULE linearSearch_v2 --------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, target

(*
Modified version of linear search which returns the FIRST element that matches the target.
Similar to the first version, if no element matches target, then we return -1
--algorithm linearSearch_v2 {

    variable index = -1,
    i = 1;
    
    {
        
        assert /\ (i = 1) /\ (index = -1) /\ (Len(input) > 0);
        
        while(i <= Len(input)) {
            if(input[i] = target) {
                index := i;
            };
            \* break of sorts
            if(index /= -1) {
                i := Len(input) + 1;
            } else {
                i := i + 1;
            };
            
        };
        

        (*
            The assertion should state that for all elements in the input array, if the element is equal to the target
            and the found index value is equal to the element's index, then that implies that there is NO element prior said element
            that is equal to target.
        *)
        assert (\A x \in 1..Len(input) : 
        ((target = input[x]) /\ (index = x)) => ~(\E y \in 1..(x-1) : (target = input[y]))
        );
    
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "efb2f8af" /\ chksum(tla) = "91f5a7d3")
VARIABLES index, i, pc

vars == << index, i, pc >>

Init == (* Global variables *)
        /\ index = -1
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (i = 1) /\ (index = -1) /\ (Len(input) > 0), 
                   "Failure of assertion at line 15, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << index, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] = target
                          THEN /\ index' = i
                          ELSE /\ TRUE
                               /\ index' = index
                    /\ IF index' /= -1
                          THEN /\ i' = Len(input) + 1
                          ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              ((target = input[x]) /\ (index = x)) => ~(\E y \in 1..(x-1) : (target = input[y]))
                              ), 
                              "Failure of assertion at line 36, column 9.")
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
\* Last modified Sun Mar 05 00:07:40 EST 2023 by jorra04
\* Created Sat Mar 04 23:58:16 EST 2023 by jorra04
