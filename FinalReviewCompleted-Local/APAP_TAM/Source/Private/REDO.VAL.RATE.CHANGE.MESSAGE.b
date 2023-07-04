* @ValidationCode : MjotMTYyNTQ4NTEyNjpDcDEyNTI6MTY4MzAyNDMzNjc5NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE  REDO.VAL.RATE.CHANGE.MESSAGE
*---------------------------------------------------------
* Description: This routine is validation routine for REDO.RATE.CHANGE.MESSAGE Paramter Table.
*
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : NA
* Deals With     : REDO.RATE.CHANGE.MESSAGE
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
* 01-NOV-2011     H GANESH            PACS00180420 - B.16 Initial Draft.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, ++ TO +=
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RATE.CHANGE.MESSAGE


    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------

    Y.MESSAGE.BODY = R.NEW(REDO.RT.MSG.MESSAGE.BODY)
    Y.MESSAGE.LINES = DCOUNT(Y.MESSAGE.BODY,@VM)
    IF ID.NEW EQ 'ARCIB' OR ID.NEW EQ 'TELLER' THEN
        GOSUB CHECK.SYMBOL
    END

    Y.DATA.ORDER.CNT = DCOUNT(R.NEW(REDO.RT.MSG.DATA.ORDER),@VM)
    Y.TOTAL.AMPS.CNT = SUM(COUNTS(Y.MESSAGE.BODY,'&'))
    IF Y.DATA.ORDER.CNT NE Y.TOTAL.AMPS.CNT THEN
        AF = REDO.RT.MSG.MESSAGE.BODY
        ETEXT = 'EB-REDO.SYMBOL.NOT.MATCH'
        CALL STORE.END.ERROR
    END
RETURN
*------------------------------------------------------------------------
CHECK.SYMBOL:
*------------------------------------------------------------------------
    Y.ERROR.LINES = ''
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.MESSAGE.LINES
        Y.LINE = Y.MESSAGE.BODY<1,Y.VAR1>
        Y.SYMBOL.CNT = COUNT(Y.LINE,"&")
        IF Y.SYMBOL.CNT GT 2 THEN
            IF Y.ERROR.LINES THEN
                Y.ERROR.LINES := ' , ':Y.VAR1
            END ELSE
                Y.ERROR.LINES = Y.VAR1
            END
        END
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    IF Y.ERROR.LINES THEN
        AF = REDO.RT.MSG.MESSAGE.BODY
        ETEXT = 'EB-REDO.SYMBOL.EXCEED':@FM:Y.ERROR.LINES:'.'
        CALL STORE.END.ERROR
        RETURN
    END


RETURN
END
