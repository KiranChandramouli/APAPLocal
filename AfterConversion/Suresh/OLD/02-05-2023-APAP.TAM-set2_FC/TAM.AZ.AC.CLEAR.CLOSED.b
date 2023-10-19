* @ValidationCode : MjotMTA2ODg1Nzg5NjpDcDEyNTI6MTY4MTIwMjM2NDkxMjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 14:09:24
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
SUBROUTINE TAM.AZ.AC.CLEAR.CLOSED
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - SM TO @SM, ++ TO += 1, $INCLUDE TO $INSERT
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON                ;** R22 Auto conversion - $INCLUDE TO $INSERT
    $INSERT I_EQUATE                ;** R22 Auto conversion - $INCLUDE TO $INSERT
    $INSERT I_F.AZ.ACCOUNT          ;** R22 Auto conversion - $INCLUDE TO $INSERT

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB MAIN.PROCESS

    END


RETURN
INIT:


    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.DEBIT.ACC'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.VAL.DEBIT.ACC = FLD.POS<1,1>
RETURN

MAIN.PROCESS:

    Y.ACC.CNT = DCOUNT(R.NEW(AZ.LOCAL.REF)<1,Y.VAL.DEBIT.ACC>,@SM)
    Y.VAR = 1
    LOOP
    WHILE Y.VAR LE Y.ACC.CNT
        Y.ACC.ID = R.NEW(AZ.LOCAL.REF)<1,Y.VAL.DEBIT.ACC,Y.VAR>
        CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT EQ '' THEN
            DEL R.NEW(AZ.LOCAL.REF)<1,Y.VAL.DEBIT.ACC,Y.VAR>
        END

        Y.VAR += 1            ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN

END
