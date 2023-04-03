---------------------------- MODULE isGeometric ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm isGeometric {
    
    variable geoCoeff = 1, i = 3, output = TRUE;
    
    {
        if(Len(input) > 2) {
            geoCoeff := input[2] \div input[1];
            while(i <= Len(input)) {
                if((input[i] \div input[i -1]) # geoCoeff ) {
                    output := FALSE;
                };
                
                i:= i + 1;
            };
        } else {
            output := FALSE;
        }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "73b369d9" /\ chksum(tla) = "13e9b28")
VARIABLES geoCoeff, i, output, pc

vars == << geoCoeff, i, output, pc >>

Init == (* Global variables *)
        /\ geoCoeff = 1
        /\ i = 3
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(input) > 2
               THEN /\ geoCoeff' = (input[2] \div input[1])
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED output
               ELSE /\ output' = FALSE
                    /\ pc' = "Done"
                    /\ UNCHANGED geoCoeff
         /\ i' = i

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF (input[i] \div input[i -1]) # geoCoeff
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED geoCoeff

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 18:55:14 EDT 2023 by jorra04
\* Created Mon Apr 03 18:50:02 EDT 2023 by jorra04
