------------------------- MODULE findDuplicateValue -------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm findDuplicate {
    variable i = 1, j = 1, output = -1;
    
    {
        while(i <= Len(input)) {
            j := 1;
            while(j <= Len(input)) {
                if((i # j)/\(input[i] = input[j])){
                    output := input[i];
                };
                j := j + 1;
            };
            
            i := i + 1;
        };
        
        assert output = -1 => ~(\E a,b \in 1..Len(input) : (a # b)/\(input[a] = input[b]));
        assert output # -1 => (\E a,b \in 1..Len(input) : (a # b)/\(input[a] = input[b])/\( (input[a] = output) \/ (input[b] = output) ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "5f8f8369" /\ chksum(tla) = "5dc6ed13")
VARIABLES i, j, output, pc

vars == << i, j, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(output = -1 => ~(\E a,b \in 1..Len(input) : (a # b)/\(input[a] = input[b])), 
                              "Failure of assertion at line 22, column 9.")
                    /\ Assert(output # -1 => (\E a,b \in 1..Len(input) : (a # b)/\(input[a] = input[b])/\( (input[a] = output) \/ (input[b] = output) )), 
                              "Failure of assertion at line 23, column 9.")
                    /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF (i # j)/\(input[i] = input[j])
                          THEN /\ output' = input[i]
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << j, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 21:53:08 EDT 2023 by jorra04
\* Created Sun Apr 02 21:37:20 EDT 2023 by jorra04
