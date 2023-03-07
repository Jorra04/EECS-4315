------------------------------- MODULE twoSum -------------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, target


(*
--algorithm twoSum {

    variable output = <<>>,
    i= 1,
    j = 1;
    
    {
        \* assert that there is some solution.
\*        assert (\E x \in 1..Len(input) : 
\*        (\E y \in 1..Len(input) :
\*            ((x /= y)/\ input[x] + input[y] = target)
\*        ));

        assert (\E x,y \in 1..Len(input) :
        (x # y) /\(input[x] + input[y] = target)
        );
        
        
        while(i <= Len(input)) {
            j := i + 1;
            while( j <= Len(input)) {
                if((i /= j) /\ ((input[i] + input[j]) = target)) {
                    output := output \o <<i,j>>;
                };
                j := j + 1;
            };
            
            i := i + 1;
        };
        
\*        assert (\A x \in 1..Len(input) : 
\*        (\A y \in 1..Len(input) : 
\*        ((x /= y) /\ (input[x] + input[y] = target)) => ((<<x,y>> = output)\/(<<y,x>> = output))
\*        ));
 assert (\A x \in 1..Len(input) : 
        (\A y \in 1..Len(input) : 
        ((x /= y) /\ (input[x] + input[y] = target)) => ((output[1] = x /\ output[2] = y)\/(output[1] = y /\ output[2] = x))
        ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "1a7e872a" /\ chksum(tla) = "5eebab8e")
VARIABLES output, i, j, pc

vars == << output, i, j, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(       (\E x,y \in 1..Len(input) :
                   (x # y) /\(input[x] + input[y] = target)
                   ), "Failure of assertion at line 20, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i, j >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ j' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ Assert((\A x \in 1..Len(input) :
                              (\A y \in 1..Len(input) :
                              ((x /= y) /\ (input[x] + input[y] = target)) => ((output[1] = x /\ output[2] = y)\/(output[1] = y /\ output[2] = x))
                              )), 
                              "Failure of assertion at line 41, column 2.")
                    /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << output, i >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF j <= Len(input)
               THEN /\ IF (i /= j) /\ ((input[i] + input[j]) = target)
                          THEN /\ output' = output \o <<i,j>>
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ j' = j + 1
                    /\ pc' = "Lbl_3"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << output, j >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 22:25:24 EST 2023 by jorra04
\* Created Sun Mar 05 23:25:37 EST 2023 by jorra04
