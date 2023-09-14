* @ValidationCode : MjoxNTQ4MzM2NDA6Q3AxMjUyOjE2ODEyMTEyODI2MjU6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:38:02
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
SUBROUTINE REDO.V.INP.COMP.RISK.LEVEL
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION :An Input routine is written to update the RISK.LEVEL from the
* local parameter table REDO.SLA.PARAM
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.INP.COMP.RISK.LEVEL
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE                          DESCRIPTION
* 27.07.2010       RENUGADEVI B       ODR-2009-12-0283                    INITIAL CREATION
*11-04-2023         Conversion Tool   R22 Auto Code conversion           FM TO @FM VM TO @VM
*11-04-2023         Samaran T         R22 Manual Code conversion             No Changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SLA.PARAM
    
    

    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
    FN.REDO.SLA.PARAM = 'F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM  = ''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APPLICATION = 'CUSTOMER'
    LREF.FIELD = 'L.CU.SEGMENTO'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APPLICATION,LREF.FIELD,LREF.POS)
    L.CU.SEGMENTO.POS = LREF.POS<1,1>

RETURN
********
PROCESS:
********
    Y.CUST         = R.NEW(ISS.COMP.CUSTOMER.CODE)
    CALL F.READ(FN.CUSTOMER,Y.CUST,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        Y.SEGMENT  = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
    END

    Y.PROD         = R.NEW(ISS.COMP.PRODUCT.TYPE)
*    Y.PRODUCT      = FIELD(Y.PROD,'-',2)
    Y.TYPE1        = R.NEW(ISS.COMP.TYPE)
*    Y.TYPE         = FIELD(Y.TYPE1,'-',2)
    Y.OPEN.CHANNEL = R.NEW(ISS.COMP.OPENING.CHANNEL)
    Y.DESC.CLAIM   = R.NEW(ISS.COMP.CLAIM.TYPE)
    Y.SLA.ID       = Y.TYPE1:'-':Y.PROD
    Y.SEG.CHA      = Y.OPEN.CHANNEL:'-':Y.SEGMENT
    CALL F.READ(FN.REDO.SLA.PARAM,Y.SLA.ID,R.REDO.SLA,F.REDO.SLA.PARAM,SLA.ERR)
    IF R.REDO.SLA THEN
        Y.SLA.DESC = R.REDO.SLA<SLA.DESCRIPTION>
    END
    CHANGE @VM TO @FM IN Y.SLA.DESC
    LOCATE Y.DESC.CLAIM IN Y.SLA.DESC SETTING SLA.POS THEN
        Y.RISK     = R.REDO.SLA<SLA.RISK.LEVEL,SLA.POS>
    END
    IF Y.RISK NE '' THEN
        R.NEW(ISS.COMP.RISK.LEVEL) = Y.RISK
    END ELSE
        R.NEW(ISS.COMP.RISK.LEVEL) = ''
    END
RETURN
END
