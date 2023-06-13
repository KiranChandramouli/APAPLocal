* @ValidationCode : MjoxMjY0OTUyMDUyOkNwMTI1MjoxNjg2NTc0MzA0MDI4OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:21:44
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.LTTP.V.TAG.RT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: J.Q.
* PROGRAM NAME: LAPAP.LTTP.V.TAG.RT
* ODR NO      : CTO-73
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.PROCESS to
* validate Quantity against L.TTP.PASO.RAPI  field when SUB.GROUP EQ 'PASO RAPIDO'
*
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TELLER.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO             REFERENCE          DESCRIPTION
* Nov 16, 2023   J.Q.            CTO-73             INITIAL CREATION
*
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-06-2023            Conversion Tool             R22 Auto Code conversion                     INSERT FILE MODIFIED
*12-06-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.VERSION  ;*R22 AUTO CODE CONVERSION.END

    GOSUB LOAD.LOCREF
    GOSUB INITIAL.VAL


RETURN

INITIAL.VAL:
    Y.SUB.GROUP = R.NEW(TEL.PRO.SUB.GROUP)
    IF Y.SUB.GROUP EQ 'PASO RAPIDO' OR Y.SUB.GROUP EQ 'KIT PASO RAPIDO' OR Y.SUB.GROUP EQ 'KIT PASO RAPIDO PIGGY' THEN
        GOSUB PROCESS
    END
RETURN

LOAD.LOCREF:
    APPL.NAME.ARR = "REDO.TELLER.PROCESS"
    FLD.NAME.ARR = "L.TTP.PASO.RAPI"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TTP.PASO.RAPI.POS = FLD.POS.ARR<1,1>

RETURN

PROCESS:

    Y.QTY.SM = DCOUNT(R.NEW(TEL.PRO.LOCAL.REF)<1,1>,@SM)
    IF Y.QTY.SM NE R.NEW(TEL.PRO.QUANTITY) THEN
        AF=27
        TEXT = "Cantidad de TAGs digitados no concuerda con la cantidad vendida."
        ETEXT = TEXT
        CALL STORE.END.ERROR
    END

    FOR A.CNT = 1 TO Y.QTY.SM STEP 1
        IF R.NEW(TEL.PRO.LOCAL.REF)<1,1,A.CNT> EQ '' THEN
            AF=27
            AV = 1
            AS = A.CNT
            TEXT = "Ingreso de TAG requerido."
            ETEXT = TEXT
            CALL STORE.END.ERROR
        END
    NEXT A.CNT
RETURN
END.OF.PGM:

RETURN

END
