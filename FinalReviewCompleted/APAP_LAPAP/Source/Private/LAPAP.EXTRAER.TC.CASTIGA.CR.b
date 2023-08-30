* @ValidationCode : MjotMjAzNjg4MzQ4NzpDcDEyNTI6MTY5MzM3NDU4MTM2OTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Aug 2023 11:19:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>89</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*29-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.EXTRAER.TC.CASTIGA.CR
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT ;*R22 MANUAL CONVERSION END




    GOSUB INIT

    SEL.CMD =  "SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.GROUP EQ 'LINEAS.DE.CREDITO.TC' AND ARR.STATUS EQ 'CLOSE' 'PENDING.CLOSURE'"

    CALL EB.READLIST(SEL.CMD, ID.LIST, "", NO.RECS, SEL.ERR)

    LOOP
        REMOVE AC.ID FROM ID.LIST SETTING POS
    WHILE AC.ID : POS

        CALL F.READ(FN.ARR,AC.ID,R.AA,FV.ARR,ERROR.AA)
        Y.CUENTA = R.AA<AA.ARR.LINKED.APPL.ID,1>

        CALL F.READ(FN.AC,Y.CUENTA,R.AC,FV.AC,ERROR.AC)
        IF NOT(R.AC) THEN
            CONTINUE
        END

        IF R.AC<AC.RECORD.STATUS> NE 'CLOSED' THEN

            CRT "AGREGANDO LA CUENTA ":Y.CUENTA
            Y.ARRAGLO<-1> = Y.CUENTA
        END

    REPEAT

    OPEN "&SAVEDLISTS&" TO VV.SAVELISTS ELSE STOP "Unable to open SaveLists File"
    WRITE Y.ARRAGLO TO VV.SAVELISTS, "TSR.360506.IDS"
    CALL JOURNAL.UPDATE('')
    CRT "PROCESO FINALIZADO"

RETURN


INIT:

    FN.ARR = 'F.AA.ARRANGEMENT'
    FV.ARR = ''
    CALL OPF(FN.ARR, FV.ARR)

    FN.AC = 'F.ACCOUNT'
    FV.AC = ''
    CALL OPF(FN.AC, FV.AC)

    FN.SL = '&SAVEDLISTS&'
    F.SL = ''
    CALL OPF(FN.SL,F.SL)

RETURN



END
