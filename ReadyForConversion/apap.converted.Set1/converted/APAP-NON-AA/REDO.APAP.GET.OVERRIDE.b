SUBROUTINE REDO.APAP.GET.OVERRIDE

* Description: This routine is the nofile enquiry routine to fetch the details of
* account closure records in INAO status

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26-02-2011      H GANESH      PACS00034162    Initial Draft
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER

    GOSUB PROCESS
RETURN

* ----------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------

    MESS=O.DATA
    MSG = ''
    CTR = 0
    NO.OF.MSG = DCOUNT(MESS,@VM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE NO.OF.MSG
        MAIN.TEXT = MESS<1,Y.VAR2,1>
        OVER.CLASS.TEXT = ''
        IF MESS<1,Y.VAR2,2> THEN
            OVER.CLASS.TEXT := '*':MESS<1,Y.VAR2,2>
        END
        IF MESS<1,Y.VAR2,3> THEN
            OVER.CLASS.TEXT := '*':MESS<1,Y.VAR2,3>
        END
        CHANGE '~' TO @FM IN MAIN.TEXT

        CHANGE '{' TO @FM IN MAIN.TEXT

        CHANGE '}' TO @VM IN MAIN.TEXT

        CALL TXT(MAIN.TEXT)
        IF CTR EQ 0 THEN
            MSG = MAIN.TEXT:OVER.CLASS.TEXT
            CTR = 1
        END ELSE
            MSG = MSG:@VM:MAIN.TEXT:OVER.CLASS.TEXT
        END
        Y.VAR2 += 1
    REPEAT
    O.DATA=MSG

RETURN
END
