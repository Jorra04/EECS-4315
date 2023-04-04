---------------------------- MODULE isGeometric ----------------------------
EXTENDS Integers, Naturals, Sequences, TLC
CONSTANT input

(*
--algorithm isGeometric {
    
    variable geoCoeff = 1, i = 3, output = TRUE;
    
    {
        if(Len(output = 2)) {
            output := TRUE;
        } else if(Len(input) > 2) {
            geoCoeff := input[2] \div input[1];
            while(i <= Len(input)) {
                if((input[i] \div input[i -1]) # geoCoeff ) {
                    output := FALSE;
                };
                
                i:= i + 1;
            };
        } else {
            output := FALSE;
        };
        
\*        assert (output = TRUE) <=> (\E x \in 1..1000 : (\A y \in 1..(Len(input)-1) : ((input[y+1] \div input[y]) = x )));
\*        assert (output = TRUE) <=> (
\*         \A x, y \in 1..(Len(input) -1) : (y = x + 1) => ((input[y] \div input[x]) = (input[y+1] \div input[y]) )
\*        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "8d261c2b" /\ chksum(tla) = "5c1a891a")
VARIABLES geoCoeff, i, output, pc

vars == << geoCoeff, i, output, pc >>

Init == (* Global variables *)
        /\ geoCoeff = 1
        /\ i = 3
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(output = 2)
               THEN /\ output' = TRUE
                    /\ pc' = "Done"
                    /\ UNCHANGED geoCoeff
               ELSE /\ IF Len(input) > 2
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
\* Last modified Mon Apr 03 19:53:39 EDT 2023 by jorra04
\* Created Mon Apr 03 18:50:02 EDT 2023 by jorra04
