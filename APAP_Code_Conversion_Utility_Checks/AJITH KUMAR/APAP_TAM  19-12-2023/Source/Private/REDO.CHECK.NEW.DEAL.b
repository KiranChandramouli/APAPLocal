* @ValidationCode : MjotMTM1MDcyMDgzMTpDcDEyNTI6MTY4MDY1ODQ0NzExOTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 07:04:07
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
SUBROUTINE REDO.CHECK.NEW.DEAL
*********************************************************************************************************
**Description      : New record not allowed
*Linked With       : APAP.H.GARNISH.DETAILS
*In  Parameter     : N.A
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                  Description
*   ------             -----                 -------------               -------------
* 13 JUN 2010       Prabhu N                 B88                         ERROR ON MODIFICATION

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    FN.APAP.H.GARNISH.DETAILS='F.APAP.H.GARNISH.DETAILS'
    F.APAP.H.GARNISH.DETAILS=''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS)


    CALL F.READ(FN.APAP.H.GARNISH.DETAILS,ID.NEW,R.GAR.REC,F.APAP.H.GARNISH.DETAILS,ERR)
    IF ERR AND V$FUNCTION EQ 'I' THEN
        E='EB-REDO.NO.NEW'
        CALL STORE.END.ERROR
    END

RETURN
END
