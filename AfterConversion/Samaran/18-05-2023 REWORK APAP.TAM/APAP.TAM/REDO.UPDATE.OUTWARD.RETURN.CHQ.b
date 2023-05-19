* @ValidationCode : MjoxMjA1ODI5Njk4OkNwMTI1MjoxNjg0NDEzODAzNTkzOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 18:13:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDATE.OUTWARD.RETURN.CHQ(ACC.NO,Y.CHQ.ID)
*------------------------------------------------------------------------
*Description: This routine is to update the return chq of each account.
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    IF ACC.NO EQ '' OR Y.CHQ.ID EQ '' THEN
        RETURN
    END

    FN.REDO.OUTWARD.RETURN.CHQ = 'F.REDO.OUTWARD.RETURN.CHQ'
    F.REDO.OUTWARD.RETURN.CHQ  = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN.CHQ,F.REDO.OUTWARD.RETURN.CHQ)

    CALL F.READU(FN.REDO.OUTWARD.RETURN.CHQ,ACC.NO,R.REDO.OUTWARD.RETURN.CHQ,F.REDO.OUTWARD.RETURN.CHQ,RET.ERR,'')
    LOCATE Y.CHQ.ID IN R.REDO.OUTWARD.RETURN.CHQ<1> SETTING POS1 ELSE
        R.REDO.OUTWARD.RETURN.CHQ<-1> = Y.CHQ.ID
        CALL F.WRITE(FN.REDO.OUTWARD.RETURN.CHQ,ACC.NO,R.REDO.OUTWARD.RETURN.CHQ)
    END
    CALL F.RELEASE(FN.REDO.OUTWARD.RETURN.CHQ,ACC.NO,F.REDO.OUTWARD.RETURN.CHQ)

RETURN
END
