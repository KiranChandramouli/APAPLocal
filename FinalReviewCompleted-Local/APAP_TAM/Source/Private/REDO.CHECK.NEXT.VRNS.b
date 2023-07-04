* @ValidationCode : MjotMTg3ODg1NjM3MDpDcDEyNTI6MTY4NDg0MjA4NjM3MzpJVFNTOi0xOi0xOjM5NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 397
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            FM TO @FM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION          NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CHECK.NEXT.VRNS
*-----------------------------------------------------------------------------
* PACS00251840
* Marimuthu S
* 28 Mar 2013
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    $INSERT I_F.TELLER.ID
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.TELLER
    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON

    IF OFS$SOURCE.ID EQ 'FASTPATH' AND R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
        RETURN
    END

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC = ''
    CALL OPF(FN.RTC,F.RTC)

    FN.TEL.USER = 'F.TELLER.USER'
    F.TEL.USER = ''
    CALL OPF(FN.TEL.USER,F.TEL.USER)

    POSS = ''
    Y.FLDS = 'L.NEXT.VERSION':@FM:'L.INITIAL.ID':@FM:'L.NEXT.VERSION'
    Y.APLN = 'FUNDS.TRANSFER':@FM:'TELLER.ID':@FM:'TELLER'
    CALL MULTI.GET.LOC.REF(Y.APLN,Y.FLDS,POSS)
    Y.POS.NXT.VER = POSS<1,1>
    Y.POS.TT.INI = POSS<2,1>
    Y.POS.TT.NX = POSS<3,1>

    Y.TELLER.ID = System.getVariable("CURRENT.TID.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION
        Y.TELLER.ID = ""
    END

    CALL F.READ(FN.TELLER.ID,Y.TELLER.ID,R.TT.ID,F.TELLER.ID,TT.ERRR)
    IF R.TT.ID THEN
        Y.INITIAL.ID = R.TT.ID<TT.TID.LOCAL.REF,Y.POS.TT.INI>
        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            IF NOT(Y.INITIAL.ID) AND R.NEW(FT.LOCAL.REF)<1,Y.POS.NXT.VER> EQ '' THEN
                AF = FT.LOCAL.REF
                AV = Y.POS.NXT.VER
                ETEXT = 'EB-NXT.VER.INPUT'
                CALL STORE.END.ERROR
            END
        END
        IF APPLICATION  EQ 'TELLER' THEN
            IF NOT(Y.INITIAL.ID) AND R.NEW(TT.TE.LOCAL.REF)<1,Y.POS.TT.NX> EQ '' THEN
                AF = TT.TE.LOCAL.REF
                AV = Y.POS.TT.NX
                ETEXT = 'EB-NXT.VER.INPUT'
                CALL STORE.END.ERROR
            END
        END
    END

RETURN

* PGM.END: ; **TUS (S/E)
END
