* @ValidationCode : MjotMTI0ODU3MjgwMjpDcDEyNTI6MTY4MTI5NTIxNjM1MjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:56:56
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
SUBROUTINE REDO.INT.ACCT.PAYOFF
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 12.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------

    FN.REDO.MULTITXN.PARAMETER = 'F.REDO.MULTITXN.PARAMETER'
    F.REDO.MULTITXN.PARAMETER = ''
    CALL OPF(FN.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER)

    CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,'SYSTEM',R.RMP,RMP.ERR)

    IF APPLICATION EQ "FUNDS.TRANSFER" THEN
        IF R.NEW(FT.DEBIT.ACCT.NO) EQ '' AND R.RMP<RMP.CHECK.ACCOUNT> NE '' THEN
            Y.DEB.AC = LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            CALL INT.ACC.OPEN(Y.DEB.AC,PRETURN.CODE)
            IF PGM.VERSION EQ ',REDO.UNC.CUR' THEN
                R.NEW(FT.DEBIT.ACCT.NO)= LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            END ELSE
                R.NEW(FT.CREDIT.ACCT.NO)= LCCY:R.RMP<RMP.CHECK.ACCOUNT>
            END
        END
    END

RETURN

END
