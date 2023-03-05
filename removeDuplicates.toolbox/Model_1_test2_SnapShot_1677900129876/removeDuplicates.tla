-------------------------- MODULE removeDuplicates --------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm removeDuplicates {

    variable output = <<>>,
    i = 1,
    j=1,
    itemFound = FALSE;
    
    {
        while(i <= Len(input)) {
            while(j <= Len(output)) {
                if(input[i] = output[j]){
                    itemFound := TRUE;
                };
                j := j + 1;
            };
            if(itemFound /= TRUE) {
                output := Append(output, input[i]);
            };
            itemFound := FALSE;
            
            i := i + 1;
        };
        
        assert (\A x \in 1..Len(output) : (\A y \in 1..Len(output) : 
        IF x /= y
        THEN output[x] /= output[y]
        ELSE output[x] = output[y]));
    
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "5e41d3e6" /\ chksum(tla) = "148b2fa2")
VARIABLES output, i, j, itemFound, pc

vars == << output, i, j, itemFound, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ j = 1
        /\ itemFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(output) : (\A y \in 1..Len(output) :
                              IF x /= y
                              THEN output[x] /= output[y]
                              ELSE output[x] = output[y])), 
                              "Failure of assertion at line 29, column 9.")
                    /\ pc' = "Done"
         /\ UNCHANGED << output, i, j, itemFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(output)
               THEN /\ IF input[i] = output[j]
                          THEN /\ itemFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED itemFound
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << output, i >>
               ELSE /\ IF itemFound /= TRUE
                          THEN /\ output' = Append(output, input[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ itemFound' = FALSE
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ j' = j

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Mar 03 20:14:59 EST 2023 by jorra04
\* Created Fri Mar 03 19:41:15 EST 2023 by jorra04
