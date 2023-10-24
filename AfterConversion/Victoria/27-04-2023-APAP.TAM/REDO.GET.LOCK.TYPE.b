* @ValidationCode : MjoxNjE5MDMzMDYxOkNwMTI1MjoxNjgwNzE4ODA2NDQxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:50:06
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
SUBROUTINE REDO.GET.LOCK.TYPE(Y.FINAL.ARRAY)

*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_ENQUIRY.COMMON

    virtualTableName = 'L.AC.LOCKE.TYPE'

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    SEL.CMD = 'SELECT ':FN.EB.LOOKUP:' WITH @ID LIKE ':virtualTableName:'*...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.ARR)

    LOOP
        REMOVE LOOKUP.ID FROM SEL.LIST SETTING LOOKUP.POS
    WHILE LOOKUP.ID:LOOKUP.POS

        CALL F.READ(FN.EB.LOOKUP,LOOKUP.ID,R.LOOKUP,F.EB.LOOKUP,LOOKUP.ERR)
        Y.GET.DESC = R.LOOKUP<EB.LU.DESCRIPTION,2>

        IF Y.GET.DESC EQ '' THEN
            Y.GET.DESC = R.LOOKUP<EB.LU.DESCRIPTION,1>
        END

        Y.FINAL.ARRAY<-1> =  FIELD(LOOKUP.ID,'*',2):'*':Y.GET.DESC
        Y.GET.DESC = ''
    REPEAT

RETURN
