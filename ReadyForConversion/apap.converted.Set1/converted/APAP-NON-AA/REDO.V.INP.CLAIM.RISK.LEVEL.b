SUBROUTINE REDO.V.INP.CLAIM.RISK.LEVEL
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
* PROGRAM NAME : REDO.V.INP.CLAIM.RISK.LEVEL
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 27.07.2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
*01-MAR-2010      PRABHU              HD1100464         Defaulting support group removed
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SLA.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****

    Y.RISK  = ''
    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS  = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
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

    Y.CUST         = R.NEW(ISS.CL.CUSTOMER.CODE)
    CALL F.READ(FN.CUSTOMER,Y.CUST,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        Y.SEGMENT  = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
    END

    Y.PROD         = R.NEW(ISS.CL.PRODUCT.TYPE)

    Y.TYPE1        = R.NEW(ISS.CL.TYPE)
    Y.OPEN.CHANNEL = R.NEW(ISS.CL.OPENING.CHANNEL)
    Y.DESC.CLAIM   = R.NEW(ISS.CL.CLAIM.TYPE)
    Y.SLA.ID       = Y.TYPE1:'-':Y.PROD
    Y.SEG.CHA      = Y.OPEN.CHANNEL:'-':Y.SEGMENT
    CALL F.READ(FN.REDO.SLA.PARAM,Y.SLA.ID,R.REDO.SLA,F.REDO.SLA.PARAM,SLA.ERR)
    IF R.REDO.SLA THEN
        Y.SLA.DESC = R.REDO.SLA<SLA.DESCRIPTION>
    END
    CHANGE @VM TO @FM IN Y.SLA.DESC
    LOCATE Y.DESC.CLAIM IN Y.SLA.DESC SETTING SLA.POS THEN
        Y.RISK     = R.REDO.SLA<SLA.RISK.LEVEL,SLA.POS>
        Y.SUPP.GRP = R.REDO.SLA<SLA.SUPPORT.GROUP,SLA.POS>
    END
    IF Y.RISK NE '' THEN
        R.NEW(ISS.CL.RISK.LEVEL) = Y.RISK
    END ELSE
        R.NEW(ISS.CL.RISK.LEVEL) = ''
    END
RETURN
END
