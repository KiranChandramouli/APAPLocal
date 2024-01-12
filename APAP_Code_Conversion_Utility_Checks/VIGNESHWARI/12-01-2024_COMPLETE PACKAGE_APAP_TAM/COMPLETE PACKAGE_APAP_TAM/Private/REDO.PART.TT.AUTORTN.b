* @ValidationCode : MjoxMTg4Mzc1NjM2OkNwMTI1MjoxNjgyNTI4NDY4NzkwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PART.TT.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.PART.TT.AUTORTN
*----------------------------------------------------------------------
*DESCRIPTION: This is the Routine for REDO.PART.TT.PROCESS to
* default the value for the TELLER application from REDO.PART.TT.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.PART.TT.AUTORTN
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE WHO REFERENCE DESCRIPTION
*29.06.2010 S SUDHARSANAN B.12 INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.PART.TT.PROCESS
    $INSERT I_F.TELLER
    $INSERT I_F.ALTERNATE.ACCOUNT
   $USING EB.LocalReferences

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.PART.TT.PROCESS = 'F.REDO.PART.TT.PROCESS'
    F.REDO.PART.TT.PROCESS = ''
    CALL OPF(FN.REDO.PART.TT.PROCESS,F.REDO.PART.TT.PROCESS)
    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.TT.DUE.PRS'
    LOC.REF.POS=''
*    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS);* R22 UTILITY AUTO CONVERSION
    POS.L.TT.DUE.PRS=LOC.REF.POS<1,1>

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.REDO.PART.TT.PROCESS.ID=FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.REDO.PART.TT.PROCESS,Y.REDO.PART.TT.PROCESS.ID,R.REDO.PART.TT.PROCESS,F.REDO.PART.TT.PROCESS,PRO.ERR)

    Y.ARR.ID = R.REDO.PART.TT.PROCESS<PAY.PART.TT.ARRANGEMENT.ID>
    Y.CURRENCY= R.REDO.PART.TT.PROCESS<PAY.PART.TT.CURRENCY>
    Y.AMOUNT = R.REDO.PART.TT.PROCESS<PAY.PART.TT.AMOUNT>
    Y.TRAN.TYPE = R.REDO.PART.TT.PROCESS<PAY.PART.TT.TRAN.TYPE>
    Y.DATE = R.REDO.PART.TT.PROCESS<PAY.PART.TT.VALUE.DATE>
    Y.REMARKS = R.REDO.PART.TT.PROCESS<PAY.PART.TT.REMARKS>

    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ARR.ID,R.ALT.ACC,F.ALTERNATE.ACCOUNT,ALT.ERR)
    ACC.ID = R.ALT.ACC<AAC.GLOBUS.ACCT.NUMBER>

    R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>=Y.AMOUNT
    R.NEW(TT.TE.CURRENCY.2)=Y.CURRENCY
    R.NEW(TT.TE.TRANSACTION.CODE)=Y.TRAN.TYPE
    R.NEW(TT.TE.ACCOUNT.2)=ACC.ID
    R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.DUE.PRS>=Y.REDO.PART.TT.PROCESS.ID

RETURN
END
