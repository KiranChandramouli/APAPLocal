* @ValidationCode : MjoxMjQwNDM4NTIxOkNwMTI1MjoxNjgyNDEyMzI5MTkxOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.UPD.WAIVE.LEDGER.ACCT
*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.UPD.WAIVE.LEDGER.ACCT
*--------------------------------------------------------------------------------
* Description: This routine is for updating local concat file for WAIVE LEDGER FEE is set to yes
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                          REFERENCE               DESCRIPTION
* 02-12-2011      Jeeva T                For COB Performance
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023       Samaran T              Manual R22 Code Conversion         No Changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB OPEN.FILE

    GOSUB PROCESS.FILE

RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
    FN.REDO.WAIVE.LEDGER.ACCT = 'F.REDO.WAIVE.LEDGER.ACCT'
    F.REDO.WAIVE.LEDGER.ACCT = ''
    CALL OPF(FN.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT)

RETURN
*---------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------

    Y.TRANS.ID = APPLICATION
    IF R.NEW(AC.WAIVE.LEDGER.FEE) EQ 'Y' THEN
        GOSUB INSERT.CONCAT.TABLE
    END
    IF R.NEW(AC.WAIVE.LEDGER.FEE) NE 'Y' THEN
        GOSUB DELETE.CONCAT.TABLE
    END
RETURN
*----------------------
INSERT.CONCAT.TABLE:
*----------------------

    CALL F.READ(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT,LED.ERR)
    LOCATE ID.NEW IN R.REDO.WAIVE.LEDGER.ACCT SETTING PO ELSE
        R.REDO.WAIVE.LEDGER.ACCT<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT)
    END
RETURN
*----------------------
DELETE.CONCAT.TABLE:
*----------------------
    CALL F.READ(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT,LED.ERR)
    LOCATE ID.NEW IN R.REDO.WAIVE.LEDGER.ACCT SETTING PO THEN
        DEL R.REDO.WAIVE.LEDGER.ACCT<PO>
        CALL F.WRITE(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT)
    END
RETURN
*----------------------
END
