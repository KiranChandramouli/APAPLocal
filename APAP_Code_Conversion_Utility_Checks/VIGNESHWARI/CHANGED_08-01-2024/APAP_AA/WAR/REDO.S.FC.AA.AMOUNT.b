* @ValidationCode : MjotODkxNjE0MTg5OkNwMTI1MjoxNzA0NDM4NzcyNjY2OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:42:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA ;*Manual R22 Code Conversion
SUBROUTINE REDO.S.FC.AA.AMOUNT(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.TERM.AMOUNT>AMOUNT field
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
* Date           Who                 Reference                                    Descripition
* 29-03-2023     Samaran T            Manual R22 Code Conversion                Package Name Added APAP.AA
* 29-03-2023   Conversion Tool         Auto R22 Code Conversion                   No Changes
*05-01-2024     VIGNESHWARI             Manual R22 Code Conversion              AA.FRAMEWORK IS MODIFIED
*-----------------------------------------------------------------------------------
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Updated by      : MG - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.TERM.AMOUNT
   $USING AA.Framework

GOSUB INITIALISE
GOSUB OPEN.FILES

IF PROCESS.GOAHEAD THEN
GOSUB PROCESS
END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

idPropertyClass = "TERM.AMOUNT"
*      --- SI Falla usar COMMITMENT
ArrangementID = AA.ID
idProperty = ''
effectiveDate = Y.PROCESS.DATE
returnIds = ''
R.CONDITION =''
returnConditions = ''
returnError = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 AUTO CONVERSION
IF returnError THEN
AA.ARR.AMT = 'NO.EXISTE'
END ELSE
R.AA.TERM.AMOUNT = RAISE(returnConditions)
AA.ARR.AMT = R.AA.TERM.AMOUNT<AA.AMT.AMOUNT>
END


AA.ARR = AA.ARR.AMT

IF NOT(AA.ARR) THEN
GOSUB SEARCH.OLDER.ARR
IF NOT(AA.ARR) THEN
AA.ARR = 'NULO'
END
END

RETURN
*------------------------
SEARCH.OLDER.ARR:
*=========
Y.BANDERA = 1
ID.TERM.AMOUNT = AA.ID:'-COMMITMENT-...'
SELECT.STATEMENT = 'SELECT ':FN.AA.ARR.TERM.AMOUNT: ' WITH @ID LIKE ':ID.TERM.AMOUNT
AA.ARR.TERM.AMOUNT.LIST = ''
LIST.NAME = ''
SELECTED = ''
SYSTEM.RETURN.CODE = ''
CALL EB.READLIST(SELECT.STATEMENT,AA.ARR.TERM.AMOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
LOOP
REMOVE AA.ARR.TERM.AMOUNT.ID FROM AA.ARR.TERM.AMOUNT.LIST SETTING AA.ARR.TERM.AMOUNT.MARK
WHILE AA.ARR.TERM.AMOUNT.ID : AA.ARR.TERM.AMOUNT.MARK AND Y.BANDERA
ID.TERM.AMOUNT = AA.ARR.TERM.AMOUNT.ID

*CALL F.READ(FN.AA.ARR.TERM.AMOUNT,ID.TERM.AMOUNT,R.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,"")
IDVAR.1 = "" ;* R22 AUTO CONVERSION
CALL F.READ(FN.AA.ARR.TERM.AMOUNT,ID.TERM.AMOUNT,R.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,IDVAR.1);* R22 AUTO CONVERSION
IF R.AA.ARR.TERM.AMOUNT THEN
AA.ARR = R.AA.ARR.TERM.AMOUNT<AA.AMT.AMOUNT>
END
IF AA.ARR THEN
Y.BANDERA = 0
END
REPEAT

RETURN
*------------------------
INITIALISE:
*=========
Y.PROCESS.DATE = TODAY
PROCESS.GOAHEAD = 1
*Y.START.DATE = AA.ARR<AA.ARR.START.DATE>
Y.START.DATE = AA.ARR<AA.Framework.ArrangementSim.ArrStartDate> ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS MODIFIED
AA.ARR = ""
R.AA.TERM.AMOUNT = ''
AA.ARR.AMT = ''
RETURN

*------------------------
OPEN.FILES:
*=========
FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
F.AA.ARR.TERM.AMOUNT = ''
R.AA.ARR.TERM.AMOUNT = ''
CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

FN.AA.ARR = 'F.AA.ARRANGEMENT'
F.AA.ARR = ''
CALL OPF(FN.AA.ARR, F.AA.ARR)

RETURN
*------------
END
