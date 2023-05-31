$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.DISPLAY.OVERRIDE
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM and ++ to +=1
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
RETURN
**********
PROCESS:
*********
    FN.ACCOUNT.NAU = 'F.ACCOUNT$NAU'
    F.ACCOUNT.NAU = ''
    CALL OPF(FN.ACCOUNT.NAU,F.ACCOUNT.NAU)

    Y.ID = O.DATA
    CALL F.READ(FN.ACCOUNT.NAU,Y.ID,R.ACC.NAU,F.ACCOUNT.NAU,ACC.ERR)

    MESS=R.ACC.NAU<AC.OVERRIDE>
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
    O.DATA = MSG

RETURN
*-------------------------------
END
