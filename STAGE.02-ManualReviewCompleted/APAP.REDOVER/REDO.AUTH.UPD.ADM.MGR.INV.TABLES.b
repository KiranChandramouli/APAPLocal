* @ValidationCode : Mjo0MjYzMTQyNzA6Q3AxMjUyOjE2ODA2ODg0MjM2NDE6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:23:43
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.UPD.ADM.MGR.INV.TABLES
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.AUTH.UPD.ADM.MGR.INV.TABLES
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion         TNO TO C$T24.SESSION.NO
*05-04-2023       Samaran T              Manual R22 Code Conversion         No Changes
*----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS
    $INSERT I_F.REDO.H.BANK.DRAFTS
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.REDO.H.ADMIN.CHEQUES

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.REDO.MANAGER.CHQ.DETAILS='F.REDO.MANAGER.CHQ.DETAILS'
    F.REDO.MANAGER.CHQ.DETAILS=''

    FN.REDO.H.BANK.DRAFTS='F.REDO.H.BANK.DRAFTS'
    F.REDO.H.BANK.DRAFTS=''

    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS = ''

    FN.REDO.H.ADMIN.CHEQUES = 'F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES = ''

*


    Y.NOSTRO.ACCT = ""
    W.STATUS      = ""          ;* VNL - 20120328 - E
*
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.REDO.MANAGER.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS)
    CALL OPF(FN.REDO.H.BANK.DRAFTS,F.REDO.H.BANK.DRAFTS)
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)

*
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    IF APPLICATION EQ "REDO.MANAGER.CHQ.DETAILS" THEN
        GOSUB MGR.UPDATE
    END ELSE
        GOSUB ADM.UPDATE
    END

RETURN
*----------------------------------------------------------------------
MGR.UPDATE:
*----------------------------------------------------------------------
* IF Application equals REDO.MANAGER.CHQ.DETAILS
*
    Y.REDO.H.BDRAFT.CHQ.ID =  R.NEW(MAN.CHQ.DET.CHQ.SEQ.NUM)
    IF R.NEW(MAN.CHQ.DET.STATUS) NE "ISSUED" AND R.NEW(MAN.CHQ.DET.STATUS)[1,4] EQ "STOP" THEN
        WSTATUS = "CANCELLED"
    END ELSE
        IF R.NEW(MAN.CHQ.DET.STATUS) EQ "ISSUED" THEN
            W.STATUS = "ISSUED"
        END
    END

    GOSUB UPDATE.DRAFTS.CHEQUE
RETURN
*----------------------------------------------------------------------
UPDATE.DRAFTS.CHEQUE:
*----------------------------------------------------------------------
*
    CALL F.READ(FN.REDO.H.BANK.DRAFTS,Y.REDO.H.BDRAFT.CHQ.ID,R.REDO.H.BANK.DRAFTS,F.REDO.H.BANK.DRAFTS,REDO.H.BANK.DRAFTS.ERR)
    IF R.REDO.H.BANK.DRAFTS NE '' THEN
        CON.DATE = OCONV(DATE(),"D-")
        Y.DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
*
        R.REDO.H.BANK.DRAFTS<REDO.BANK.STATUS>     = W.STATUS
        R.REDO.H.BANK.DRAFTS<REDO.BANK.CURR.NO>    = R.NEW(REDO.BANK.CURR.NO) + 1
        R.REDO.H.BANK.DRAFTS<REDO.BANK.INPUTTER>   = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CODE CONVERSION
        R.REDO.H.BANK.DRAFTS<REDO.BANK.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR   ;*R22 AUTO CODE CONVERSION
        R.REDO.H.BANK.DRAFTS<REDO.BANK.DATE.TIME>  = Y.DATE.TIME
        R.REDO.H.BANK.DRAFTS<REDO.BANK.CO.CODE>    = ID.COMPANY
        R.REDO.H.BANK.DRAFTS<REDO.BANK.DEPT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
        R.REDO.H.BANK.DRAFTS<REDO.BANK.TRANS.REF>  = ID.NEW
*
        CALL F.WRITE(FN.REDO.H.BANK.DRAFTS,Y.REDO.H.BDRAFT.CHQ.ID,R.REDO.H.BANK.DRAFTS)
*
    END
*
RETURN

*-----------------------------------
ADM.UPDATE:
*-------------------------------------
    Y.REDO.H.ADMIN.CHQ.ID  = R.NEW(ADMIN.CHQ.DET.CHQ.SEQ.NUM)

    IF R.NEW(ADMIN.CHQ.DET.STATUS) NE "ISSUED" AND R.NEW(ADMIN.CHQ.DET.STATUS)[1,4] EQ "STOP" THEN
        WSTATUS = "CANCELLED"
    END ELSE
        IF R.NEW(ADMIN.CHQ.DET.STATUS) EQ "ISSUED" THEN
            W.STATUS = "ISSUED"
        END
    END
    GOSUB UPDATE.ADMIN.CHEQUE

RETURN
*------------------------------------------------------------------------------
*----------------------------------------------------------------------
UPDATE.ADMIN.CHEQUE:
*----------------------------------------------------------------------

    CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,Y.REDO.H.ADMIN.CHQ.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,REDO.H.ADMIN.CHEQUES.ERR)
    IF R.REDO.H.ADMIN.CHEQUES NE '' THEN
        CON.DATE = OCONV(DATE(),"D-")
        Y.DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
*
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS>       = W.STATUS
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.BENEFICIARY>  = R.NEW(ADMIN.CHQ.DET.BENEFICIARY)
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.UPDATED> = TODAY
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.USER>         = OPERATOR
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CURR.NO>      = R.NEW(REDO.ADMIN.CURR.NO) + 1
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.INPUTTER>     = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CODE CONVERSION
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.AUTHORISER>   = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CODE CONVERSION
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.TIME>    = Y.DATE.TIME
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CO.CODE>      = ID.COMPANY
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DEPT.CODE>    = R.USER<EB.USE.DEPARTMENT.CODE>
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.TRANS.REF>    = ID.NEW
*
        CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.REDO.H.ADMIN.CHQ.ID,R.REDO.H.ADMIN.CHEQUES)

    END
*
RETURN
*--------------------------------------
*
END
