----------------------------- MODULE isAnagram -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input1, input2

(*
--algorithm isAnagram {
    variable i = 1, j = 1, output = TRUE, set = {};
    
    {
        if(Len(input1) # Len(input2)) {
            output := FALSE;
            i := Len(input1) + 1;
        };
        while(i <= Len(input1)) {
            set := set \cup {input1[i]};
            i:= i + 1;
        };
        i:= 1;
        while(i <= Len(input2)) {
            if(~(input2[i] \in set)) {
                output := FALSE;
            };
            i:= i + 1;
        };
        
        assert output = TRUE <=> /\ (Len(input1) = Len(input2))/\(\A a \in 1..Len(input1) : (\E b \in 1..Len(input2) : input1[a] = input2[b]));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "66a1d265" /\ chksum(tla) = "8cd8ca24")
VARIABLES i, j, output, set, pc

vars == << i, j, output, set, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = TRUE
        /\ set = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(input1) # Len(input2)
               THEN /\ output' = FALSE
                    /\ i' = Len(input1) + 1
               ELSE /\ TRUE
                    /\ UNCHANGED << i, output >>
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << j, set >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input1)
               THEN /\ set' = (set \cup {input1[i]})
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_3"
                    /\ set' = set
         /\ UNCHANGED << j, output >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input2)
               THEN /\ IF ~(input2[i] \in set)
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ Assert(output = TRUE <=> /\ (Len(input1) = Len(input2))/\(\A a \in 1..Len(input1) : (\E b \in 1..Len(input2) : input1[a] = input2[b])), 
                              "Failure of assertion at line 26, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED << j, set >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 18:06:49 EDT 2023 by jorra04
\* Created Sun Apr 02 17:48:58 EDT 2023 by jorra04
