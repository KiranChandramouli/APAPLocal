* @ValidationCode : Mjo0NDQ3MzIxNDg6Q3AxMjUyOjE2ODExOTAwNjY0Nzg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:44:26
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
SUBROUTINE REDO.V.CHK.TAX.CHRG.CLEARING
*-----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for Outward return FT VERSIONS.
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : H GANESH
* PROGRAM NAME : REDO.V.CHK.TAX.CHRG.CLEARING
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE          WHO                     REFERENCE       DESCRIPTION
* 01/09/2013    H Ganesh                PACS00321684    Commission will changed based on customer type.
* -----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
*

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN

*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
    WCHG.CODE = ''
    GOSUB GET.COMM.ON.CUST
    IF WCHG.CODE ELSE
        RETURN
    END

    R.NEW(FT.COMMISSION.TYPE) = WCHG.CODE

RETURN
*
*----------------------------------------------------------------------------
GET.COMM.ON.CUST:
*----------------------------------------------------------------------------

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,PARAM.ERR)

    Y.DR.ACC = R.NEW(FT.DEBIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.DR.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUS.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUST,F.CUSTOMER,CUS.ERR)
    Y.CUST.TYPE = R.CUST<EB.CUS.LOCAL.REF,POS.L.CU.SEGMENTO>
    IF Y.CUST.TYPE THEN
        LOCATE Y.CUST.TYPE IN R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CUSTOMER.TYPE,1> SETTING SEG.POS THEN
            WCHG.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.FT.REF.CHG,SEG.POS>
        END
    END




RETURN
*----------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------

    WAPP.LST  = "CUSTOMER"
    WFLD.LST = 'L.CU.SEGMENTO'
    YPOS=''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    POS.L.CU.SEGMENTO = YPOS<1,1>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM  = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

RETURN
END
