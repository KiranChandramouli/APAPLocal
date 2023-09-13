* @ValidationCode : MjotMjA1ODM0NjU4OTpDcDEyNTI6MTY4MDY5Nzc4NzcxNDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 17:59:47
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
SUBROUTINE REDO.FT.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.FT.AUTORTN
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.PROCESS to
* default the value for the TELLER application from REDO.TELLER.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TELLER.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE                WHO              REFERENCE         DESCRIPTION
*28.05.2010       S SUDHARSANAN     PACS00062653      INITIAL CREATION
*05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM
*05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes

*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.TELLER.PROCESS.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.REDO.TELLER.PROCESS = 'F.REDO.TELLER.PROCESS'
    F.REDO.TELLER.PROCESS = ''
    CALL OPF(FN.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS)

    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.FT.CONCEPT':@VM:'L.TT.PROCESS':@VM:'L.COMMENTS':@VM:'L.TT.TRANS.AMT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.FT.CONCEPT=LOC.REF.POS<1,1>
    POS.L.TT.PROCESS = LOC.REF.POS<1,2>
    POS.L.COMMENTS = LOC.REF.POS<1,3>
    POS.L.TT.TRANS.AMT = LOC.REF.POS<1,4>
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

* Y.DATA = ""
* CALL BUILD.USER.VARIABLES(Y.DATA)
* Y.REDO.TELLER.PROCESS.ID=FIELD(Y.DATA,"*",2)
    Y.REDO.TELLER.PROCESS.ID = VAR.PROCESS.ID
    CALL F.READ(FN.REDO.TELLER.PROCESS,Y.REDO.TELLER.PROCESS.ID,R.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS,PRO.ERR)

* Y.TXN.DETAILS = 'AC80'
    Y.CURRENCY = R.REDO.TELLER.PROCESS<TEL.PRO.CURRENCY>
    Y.AMOUNT =R.REDO.TELLER.PROCESS<TEL.PRO.AMOUNT>
    Y.CATEGORY = R.REDO.TELLER.PROCESS<TEL.PRO.CATEGORY>

    Y.CONCEPT =R.REDO.TELLER.PROCESS<TEL.PRO.CONCEPT>
    Y.CLIENT = R.REDO.TELLER.PROCESS<TEL.PRO.CLIENT.ID>
    R.NEW(FT.CREDIT.CURRENCY)=Y.CURRENCY
    R.NEW(FT.CREDIT.ACCT.NO) = 'PL':Y.CATEGORY
*    R.NEW(FT.CREDIT.AMOUNT) = Y.AMOUNT
    R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS> = Y.AMOUNT
    R.NEW(FT.ORDERING.CUST) = Y.CLIENT
    R.NEW(FT.DEBIT.CUSTOMER) = Y.CLIENT
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.CONCEPT>= Y.CONCEPT
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.PROCESS>= Y.REDO.TELLER.PROCESS.ID
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TRANS.AMT> = Y.AMOUNT
RETURN

END
