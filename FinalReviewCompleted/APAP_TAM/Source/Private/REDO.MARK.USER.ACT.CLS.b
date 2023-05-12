* @ValidationCode : MjotNTQ5ODYwOTc1OkNwMTI1MjoxNjgzODA4NDU1OTQwOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 18:04:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.TAM
SUBROUTINE REDO.MARK.USER.ACT.CLS
    
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
*
* Date             Who               Reference       Description
* 04.04.2023    Conversion Tool      R22             Auto Conversion     - VM TO @VM
* 04.04.2023    Shanmugapriya M      R22             Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER

MAIN:

    IF APPLICATION NE 'USER' THEN
        GOSUB PGM.END
    END

    Y.APL = 'USER'
    Y.FLDS = 'L.TELR.LOAN':@VM:'L.ALLOW.ACTS'  ; PS.OO = ''
    CALL MULTI.GET.LOC.REF(Y.APL,Y.FLDS,PS.OO) ;*MANUAL R22 CODE CONVERSION
    Y.TLR.POS = PS.OO<1,1>
    Y.AL.C.POS = PS.OO<1,2>

    Y.USR = R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS>

    BEGIN CASE
        CASE R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS> EQ 'TELLER'
            IF R.NEW(EB.USE.LOCAL.REF)<1,Y.AL.C.POS> EQ '' THEN
                AF = EB.USE.LOCAL.REF
                AV = Y.AL.C.POS
                ETEXT = 'EB-MAND.IF.TELLER'
                CALL STORE.END.ERROR
            END

        CASE R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS> EQ 'LOANUSER'
            IF R.NEW(EB.USE.LOCAL.REF)<1,Y.AL.C.POS> NE '' THEN
                AF = EB.USE.LOCAL.REF
                AV = Y.AL.C.POS
                ETEXT = 'EB-NOT.APPL.LOANS'
                CALL STORE.END.ERROR
            END

        CASE R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS> EQ 'OTHERS'
            IF R.NEW(EB.USE.LOCAL.REF)<1,Y.AL.C.POS> NE '' THEN
                AF = EB.USE.LOCAL.REF
                AV = Y.AL.C.POS
                ETEXT = 'EB-NOT.OTH.LOANS'
                CALL STORE.END.ERROR
            END

    END CASE

RETURN

PGM.END:

END
