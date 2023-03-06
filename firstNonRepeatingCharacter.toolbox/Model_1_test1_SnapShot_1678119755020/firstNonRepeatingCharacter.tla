--------------------- MODULE firstNonRepeatingCharacter ---------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm firstNonRepeating {

    variable i = 1, j = 1,k=1, firstNonRepeating = "", duplicateFound = FALSE;
    
    {
        
        assert (\A x \in 1..Len(input) : (\E y \in 1..Len(input) : 
        ((x # y) /\ (input[x] # input[y]) )
        ));
    
    
        while(i <= Len(input)) {
            duplicateFound := FALSE;
            j:= 1;
            while(j <= Len(input)) {
                if(input[i] = input[j] /\ (i # j)) {
                    duplicateFound := TRUE;
                    j := Len(input);
                };
                
                j := j + 1;
            };
            
            if(duplicateFound = FALSE) {
                firstNonRepeating := input[i];
                i:= Len(input);
            };
            
            i := i + 1;
        };
        
        assert (\A x \in 1..Len(input) :
        (input[x] = firstNonRepeating) => (\A y \in 1..Len(input) : 
        ((x # y) => input[x] # input[y])
        )
        );
        
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "e220c0b1" /\ chksum(tla) = "e975ee80")
VARIABLES i, j, k, firstNonRepeating, duplicateFound, pc

vars == << i, j, k, firstNonRepeating, duplicateFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ k = 1
        /\ firstNonRepeating = ""
        /\ duplicateFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(       (\A x \in 1..Len(input) : (\E y \in 1..Len(input) :
                   ((x # y) /\ (input[x] # input[y]) )
                   )), "Failure of assertion at line 12, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, j, k, firstNonRepeating, duplicateFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ duplicateFound' = FALSE
                    /\ j' = 1
                    /\ pc' = "Lbl_3"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              (input[x] = firstNonRepeating) => (\A y \in 1..Len(input) :
                              ((x # y) => input[x] # input[y])
                              )
                              ), 
                              "Failure of assertion at line 37, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << j, duplicateFound >>
         /\ UNCHANGED << i, k, firstNonRepeating >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF j <= Len(input)
               THEN /\ IF input[i] = input[j] /\ (i # j)
                          THEN /\ duplicateFound' = TRUE
                               /\ j' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << j, duplicateFound >>
                    /\ pc' = "Lbl_4"
                    /\ UNCHANGED << i, firstNonRepeating >>
               ELSE /\ IF duplicateFound = FALSE
                          THEN /\ firstNonRepeating' = input[i]
                               /\ i' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, firstNonRepeating >>
                    /\ pc' = "Lbl_5"
                    /\ UNCHANGED << j, duplicateFound >>
         /\ k' = k

Lbl_4 == /\ pc = "Lbl_4"
         /\ j' = j + 1
         /\ pc' = "Lbl_3"
         /\ UNCHANGED << i, k, firstNonRepeating, duplicateFound >>

Lbl_5 == /\ pc = "Lbl_5"
         /\ i' = i + 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << j, k, firstNonRepeating, duplicateFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3 \/ Lbl_4 \/ Lbl_5
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 11:22:30 EST 2023 by jorra04
\* Created Mon Mar 06 00:36:36 EST 2023 by jorra04
