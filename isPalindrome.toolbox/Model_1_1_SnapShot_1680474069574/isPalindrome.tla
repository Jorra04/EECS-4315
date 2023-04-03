---------------------------- MODULE isPalindrome ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm isPalindrome {
    variables i =1, j = Len(input), output = TRUE;
    
    {
        while(i < j) {
            if(input[i] # input[j]) {
                output := FALSE;
            };
            
            i := i + 1;
            j := j - 1;
        };
        
        assert (output = TRUE) <=> (\A a \in 1..Len(input) : input[a] = input[Len(input) - a + 1]);
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "202b0953" /\ chksum(tla) = "960a1902")
VARIABLES i, j, output, pc

vars == << i, j, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = Len(input)
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i < j
               THEN /\ IF input[i] # input[j]
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ j' = j - 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert((output = TRUE) <=> (\A a \in 1..Len(input) : input[a] = input[Len(input) - a + 1]), 
                              "Failure of assertion at line 19, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, j, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 18:20:39 EDT 2023 by jorra04
\* Created Sun Apr 02 18:12:17 EDT 2023 by jorra04
