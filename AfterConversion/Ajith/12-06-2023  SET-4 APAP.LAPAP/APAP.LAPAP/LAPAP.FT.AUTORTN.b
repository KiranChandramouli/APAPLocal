* @ValidationCode : MjotMTg5NDQ2NDczOkNwMTI1MjoxNjg2NTczODAxOTQzOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jun 2023 18:13:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.FT.AUTORTN
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
*DATE           WHO           REFERENCE         DESCRIPTION
*28.05.2010  S SUDHARSANAN    PACS00062653   INITIAL CREATION
*14.12.2020                   SQA-7888       Based on REDO.FT.AUTORTN
*----------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-06-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP IS REMOVED, VM to @VM
*12-06-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERISON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.TELLER.PROCESS.COMMON ;*R22 AUTO CODE CONVERSION

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
    IF Y.CONCEPT EQ 'PASO RAPIDO' OR Y.CONCEPT EQ 'KIT PASO RAPIDO' OR Y.CONCEPT EQ 'KIT PASO RAPIDO PIGGY'  THEN
        R.NEW(FT.CREDIT.ACCT.NO) = 'DOP1763600010017'
    END ELSE
        R.NEW(FT.CREDIT.ACCT.NO) = 'PL':Y.CATEGORY
    END
*    R.NEW(FT.CREDIT.AMOUNT) = Y.AMOUNT
    R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS> = Y.AMOUNT
    R.NEW(FT.ORDERING.CUST) = Y.CLIENT
    R.NEW(FT.DEBIT.CUSTOMER) = Y.CLIENT
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.CONCEPT>= Y.CONCEPT
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.PROCESS>= Y.REDO.TELLER.PROCESS.ID
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TRANS.AMT> = Y.AMOUNT
RETURN

END
