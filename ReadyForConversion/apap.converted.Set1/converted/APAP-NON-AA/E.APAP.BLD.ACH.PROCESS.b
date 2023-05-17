SUBROUTINE E.APAP.BLD.ACH.PROCESS(ENQ.DATA)

* Enquiry : REDO.ACH.PROCESS
* New Build Routine introduced for Performance

    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EQUATE

*---- Instead of selecting from EXEC.DATE its better to select from @ID as the date is already there

    LOCATE "EXEC.DATE" IN ENQ.DATA<2,1> SETTING POS THEN
        EXEC.DT = ENQ.DATA<4,POS>
        EXEC.DT = SQUOTE(EXEC.DT:'.')
        ENQ.DATA<2,POS> = "@ID"
        ENQ.DATA<3,POS> = "LK"
        ENQ.DATA<4,POS> = '"':EXEC.DT:'..."'
    END

RETURN
STOP
