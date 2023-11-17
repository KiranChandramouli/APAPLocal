* @ValidationCode : Mjo5MjM2MTU1NTg6Q3AxMjUyOjE2ODI0MTIzMzA5ODY6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CHQ.REPRINT.OVRD
*------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Shankar Raju
*Program Name      : REDO.INP.CHQ.REPRINT.OVRD
*Date              : 11 MARCH 2011
*-----------------------------------------------------------------------------------------------------------------
*Description       : This is a input routine which will show override when check is printed next day/after
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : N/A
* Out : N/A
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : N/A
* Called By : N/A
*------------------------------------------------------------------------------------------------------------------

*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 FM to @FM, VM to @VM
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.PRINT.CHQ.LIST
*
    R.NEW(PRINT.CHQ.LIST.OVERRIDE)=''
    TAM.V.OVERRIDES = OFS$OVERRIDES
    TAM.V.OVERRIDES = FIELD(TAM.V.OVERRIDES,@FM,2)
    TAM.V.OVERRIDES = CHANGE(TAM.V.OVERRIDES,'NO','')
    TAM.V.OVERRIDES = CHANGE(TAM.V.OVERRIDES,@VM,'')
    VAR.PRINT = R.NEW(PRINT.CHQ.LIST.PRINT)
    IF OFS$OPERATION EQ 'PROCESS' AND VAR.PRINT EQ 'Y' THEN
        GOSUB INITIALISE
        GOSUB PROCESS
    END
*
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*==========

    Y.CHQ.NO = R.NEW(PRINT.CHQ.LIST.CHEQUE.NO)
    Y.AMOUNT = R.NEW(PRINT.CHQ.LIST.AMOUNT)
    Y.BENEFI = R.NEW(PRINT.CHQ.LIST.BENEFICIARY)
    IF TAM.V.OVERRIDES EQ '' THEN
        IF R.NEW(PRINT.CHQ.LIST.NO.OF.REPRINT) EQ '' THEN
            R.NEW(PRINT.CHQ.LIST.NO.OF.REPRINT) = 1
        END ELSE
            R.NEW(PRINT.CHQ.LIST.NO.OF.REPRINT) += 1
        END
    END

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*=======
    CURR.NO=DCOUNT(R.NEW(PRINT.CHQ.LIST.OVERRIDE),@VM) + 1

    TEXT="REDO.CHQ.REPRINT.OVR":@FM:Y.CHQ.NO
    CALL STORE.OVERRIDE(CURR.NO)

    TEXT="REDO.CHQ.REPRINT.OVRD"
    CALL STORE.OVERRIDE(CURR.NO+1)

RETURN
*---------------------------------------------------------------------------------
END
